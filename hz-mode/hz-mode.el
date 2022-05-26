;; TODO: add syntax for eval-after-load ess mode
;; TODO: add highlight for ess mode
;; BUG: ess-mode does not work with the hightlight feature

(defcustom fic-highlighted-words '("FIXME" "TODO" "BUG" "KLUDGE")
  "Words to highlight"
  :group 'hz-mode)

(defcustom fic-foreground-color "Red"
  "Font foreground colour"
  :group 'hz-mode)

(defcustom fic-background-color  "Yellow"
  "Font background color"
  :group 'hz-mode)

(defcustom font-lock-fic-face 'font-lock-fic-face
  "variable storing the face for fic mode"
  :group 'hz-mode)

(make-face 'font-lock-fic-face)
(modify-face 'font-lock-fic-face fic-foreground-color
	     fic-background-color nil t nil t nil nil)

(defvar fic-search-list-re (regexp-opt fic-highlighted-words 'words)
  "regexp constructed from 'fic-highlighted-words")

(defun fic-in-doc/comment-region (pos)
  (memq (get-char-property pos 'face)
	(list font-lock-doc-face font-lock-string-face font-lock-comment-face)))

(defun fic-search-for-keyword (limit)
  (let ((match-data-to-set nil)
	found)
    (save-match-data
      (while (and (null match-data-to-set)
		  (re-search-forward fic-search-list-re limit t))
	(if (and (fic-in-doc/comment-region (match-beginning 0))
		 (fic-in-doc/comment-region (match-end 0)))
	    (setq match-data-to-set (match-data)))))
    (when match-data-to-set
      (set-match-data match-data-to-set)
      (goto-char (match-end 0))
      t)))

(defun run-current-file ()
  (interactive)
  (let (
	($suffix-map
	 ;; (extension . shell program name)
	 `(
	   ;; ("php" . "php")
	   ("lisp" . "sbcl --script")
	   ("clj" . "clj")
	   ("py" . "/Library/Frameworks/Python.framework/Versions/3.8/bin/python3")
	   ("lua" . "lua")
	   ("sh" . "bash")
	   ("go" . "go run")
	   ;; ("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
	   ;; ("java" . "javac")
	   ))
	$fname
	$fSuffix
	$prog-name
	$cmd-str)
    (when (not (buffer-file-name)) (save-buffer))
    (when (buffer-modified-p) (save-buffer))
    (setq $fname (car (last (split-string (buffer-file-name) "/"))))

    ;; (setq fname (buffer-file-name))

    (setq $fSuffix (file-name-extension $fname))
    (setq $prog-name (cdr (assoc $fSuffix $suffix-map)))
    (setq $cmd-str (concat $prog-name " \""   $fname "\""))

    (message $fname $fSuffix $prog-name $cmd-str)

    (cond
     ;; ((string-equal $fSuffix "sas")(message "SAS running..."))
     ((string-equal $fSuffix "el") (load $fname))
     ((string-equal $fSuffix "go")
      ;; (when (fboundp 'gofmt)
      ;; 	(gofmt)
	(shell-command $cmd-str "*run-current-file output*" ))
     ((string-equal $fSuffix "java")
      (progn
	(shell-command $cmd-str "*run-current-file output*" )
	(shell-command
	 (format "java %s" (file-name-sans-extension (file-name-nondirectory $fname))))))
     (t (if $prog-name
	    (progn
	      (message "... Job Running...")
	      (shell-command $cmd-str "*run-current-file output*" ))
	  (message "No recognized program file suffix for this file."))))))



(defun execute-current-file ()
    ;;; only works in tramp mode
  (interactive)
  (let (fname fsuffix cmdstr)
    (setq fname (buffer-file-name))
    ;; tramp mode
    ;; (setq fname (car (last (split-string (buffer-file-name) ":"))))
    (setq fsuffix (file-name-extension fname))
    (setq cmdstr (concat "" "\"" fname "\""))

    (when (buffer-modified-p)
      (save-buffer))
    (progn
      (message "...running...")
      (shell-command cmdstr "*run-current-file output*" ))
    ))


(defun current-file-status-check ()
  ;; it only works in tramp mode
  (interactive)
  (let (fname fsuffix cmdstr)
    (setq fname (car (last (split-string (buffer-file-name) ":"))))
    (setq fsuffix (file-name-extension fname))
    (setq fname-only (file-name-base fname))
    (setq cmdstr
	  (concat "ps -u hzhang -o pid,pcpu,start_time,cmd:200|grep " fsuffix "*." fname-only))
    (progn
      (message "process is not running")
      (shell-command cmdstr "*current process status*")
      )))


(defvar hz-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<f2>") 'revert-buffer)
    (define-key map (kbd "<f12>") 'toggle-truncate-lines)
    (define-key map (kbd "<f3>") 'run-current-file)
    (define-key map (kbd "<f8>") 'execute-current-file)
    (define-key map (kbd "<f9>") 'current-file-status-check)
    map)
    "key map for `hz-mode'.
add some more stuff here.")



;;;###autoload
(define-minor-mode hz-mode
  :init-value t
  :global t
  :lighter " hzhang"
  :keymap hz-mode-map
  :group 'hz-mode

  (let ((kwlist '((fic-search-for-keyword (0 'font-lock-fic-face t)))))
    (if hz-mode
	(font-lock-add-keywords nil kwlist)
      (font-lock-remove-keywords nil kwlist))))


;;;###autoload
(defun turn-off-hz-mode ()
  "turn off hz-mode"
  (interactive)
  (hz-mode 1))

(add-hook 'prog-mode-hook 'hz-mode)

(provide 'hz-mode)
