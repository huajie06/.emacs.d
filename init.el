;; add melpa
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line. ;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives
	'("melpa" . "http://melpa.org/packages/"))

;; (setq exec-path (append '("/usr/local/bin"
;; 			  "/usr/bin"
;; 			  "/usr/local/go/bin"
;; 			  "/Users/huajiezhang/go/bin") exec-path))

;; (setenv "PATH" (concat "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/Users/huajiezhang/go/bin:/Library/TeX/texbin:"
;; 		       (getenv "PATH")))

;;(setq tramp-remote-path (append '("/usr/local/go/bin"
;;				  "/usr/local/bin/") tramp-remote-path))



(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(require 'tramp)
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(add-to-list 'tramp-remote-path "~/go/bin")


;; (require 'go-eldoc)
;; (add-hook 'go-mode-hook 'go-eldoc-setup)

(defun my-go-mode-hook ()
    ;; prefer goimports, if present
    ;; (if (executable-find "goimports")
    ;; (setq gofmt-command "goimports"))
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save)

    ;; esc-space to jump to definition
    (local-set-key (kbd "M-SPC") 'godef-jump)
    (local-set-key (kbd "C-c C-g") 'golint)
    ;; escp-b to jump (b)ack
    (local-set-key (kbd "M-b") 'pop-tag-mark))

(add-hook 'go-mode-hook 'my-go-mode-hook)

;;=================lsp-mode======================
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)
;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-tramp-connection "go")
;;               :major-modes '(go-mode)
;;               :remote? t
;;               :server-id 'go-remote))


(defun align-equals (begin end)
    (interactive "r")
    (align-regexp begin end "\\(\\s-*\\)=" 1 1))


(global-set-key (kbd "M-=") 'align-equals)


(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

;; (add-hook 'go-mode-hook (lambda ()
;;                           (set (make-local-variable 'company-backends) '(company-go))
;;                           (company-mode)))

;; (add-hook 'html-mode-hook 'web-mode)
;; (add-hook 'python-mode-hook 'anaconda-mode)
;; (add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(require 'rx)
;; (eval-after-load "company"
;;  '(add-to-list 'company-backends 'company-anaconda))

;; (eval-after-load "company"
;;  '(add-to-list 'company-backends '(company-anaconda :with company-capf)))

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode t)
        (setq tab-width 4)
        (setq python-indent-offset 4)))


(require 'ob-go)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((go . t)))

(show-paren-mode t)
(electric-pair-mode 1)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)


;;(setq org-babel-python-command "/Library/Frameworks/Python.framework/Versions/3.8/bin/python3")

(setq org-confirm-babel-evaluate 'nil)

(setq ibuffer-saved-filter-groups
      '(("home"
	 ("Org" (or (mode . org-mode)
		    (filename . "OrgMode")))
	 ("htlm" (filename . "html"))
	 ("py" (mode . python-mode))
	 ("go" (mode . go-mode))
	 ("md" (mode . markdown-mode))
	 ("json" (mode . json-mode))
	 ("lisp" (mode . lisp-mode))
	 ("web" (or (mode . html-mode)
		    (mode . mhtml-mode)
		    (mode . css-mode)))
	 ("dired" (mode . dired-mode))
	 ("Subversion" (name . "\*svn"))
	 ("Magit" (name . "\*magit"))
	 ("emacs-config" (or (filename . ".emacs.d")
			     (filename . "emacs-config")))
	 ("ERC" (mode . erc-mode))
	 ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*"))))))
(setq ibuffer-show-empty-filter-groups nil)
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-switch-to-saved-filter-groups "home")))

;; (setq projectile-mode-line-prefix 'Prj)
;; (setq projectile-dynamic-mode-line 'nil)

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . nil)
    (R . t)
    (python . t)
    (shell . t)
    (lisp . t)
    ))

;; need to make a directory first
(setq backup-directory-alist `(("." . "~/.saves")))
;; this one copied from online
(setq delete-old-versions t
      kept-new-version 4
      kept-old-version 2
      version-control t)

(setq auto-save-default nil)
(setq auto-save-interval 10000)

;; igonre case when searching
(setq case-fold-search t)

;; don't show the tool bar

(menu-bar-mode t)

;; don't show tool bar
(tool-bar-mode -1) 

;; (with-eval-after-load 'ilist (evil-collection-imenu-list-setup))

;; (setq evil-want-keybinding nil)
;; (evil-collection-init)


(setq scroll-conservatively 101)

(evil-mode 1)
(evil-set-undo-system 'undo-tree)
(global-undo-tree-mode)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; display line numbers
;;(global-linum-mode t)
;;(setq linum-format "%4d \u2502")
(global-display-line-numbers-mode t)


(require 'recentf)
(recentf-mode 1)
;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)
(setq recentf-max-saved-items 150)

;; (defun ido-recentf-open ()
;;   "Use `ido-completing-read' to \\[find-file]] a recent file"
;;   (interactive)
;;   (if (find-file (ido-completing-read "Find recent files: "recentf-list))
;;       (message "Opening file ...")
;;     (message "Abortingn...")))



(ivy-mode 1)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-height 15)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;(global-set-key (kbd "C-x C-r") 'counsel-buffer-or-recentf)
;;(require 'prescient)

(ivy-prescient-mode +1)

(require 'helm)
;;(global-set-key (kbd "M-x") 'helm-M-x)
;;(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
;;(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x r l") 'helm-bookmark)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(setq helm-recentf-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t)


(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "<f6>") 'ivy-resume)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(global-set-key "\C-x\ \C-b" 'ibuffer)

(add-to-list 'load-path "~/.emacs.d/hz-mode")

(require 'hz-mode)

(defun my/shell-set-hook ()
  (when (file-remote-p (buffer-file-name))
    (setq shell-file-name "/bin/bash")))
(add-hook 'find-file-hook #'my/shell-set-hook)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-completion-system 'ivy)



(require 'telephone-line)
(telephone-line-evil-config)
(setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-vc-segment
                     telephone-line-erc-modified-channels-segment
                     telephone-line-process-segment))
          (nil    . (telephone-line-minor-mode-segment
                     telephone-line-buffer-segment))))
(setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment))
          (accent . (telephone-line-major-mode-segment))
          (evil   . (telephone-line-airline-position-segment))))
(telephone-line-mode 1)


;;(require 'ido-vertical-mode)
;;(ido-mode 1)
;;(ido-vertical-mode 1)
;;(setq ido-vertical-define-keys 'C-n-and-C-p-only)
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (setq ido-use-filename-at-point 'guess)
;;(setq ido-vertical-show-count t)

;;(global-set-key "\C-x\ \C-r" 'ido-recentf-open)

(global-set-key (kbd "<f12>") 'toggle-truncate-lines)
;; auto-complete package
(add-hook 'after-init-hook 'global-company-mode)

;; (global-auto-complete-mode t)

(setq company-show-numbers t)
;; (with-eval-after-load 'company
;;   (define-key company-active-map (kbd "M-n") nil)
;;   (define-key company-active-map (kbd "M-p") nil)
;;   (define-key company-active-map (kbd "C-n") #'company-select-next)
;;   (define-key company-active-map (kbd "C-p") #'company-select-previous))

(with-eval-after-load 'company
    (define-key company-active-map (kbd "C-n") (lambda () (interactive) (company-complete-common-or-cycle 1)))
    (define-key company-active-map (kbd "C-p") (lambda () (interactive) (company-complete-common-or-cycle -1))))

(setq sr-speedbar-right-side nil)
(global-set-key "\C-c\ \C-s" 'sr-speedbar-toggle)

;;(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)
(define-key evil-normal-state-map (kbd "SPC") 'avy-goto-char-2)
;;(define-key evil-normal-state-map (kbd "SPC") 'avy-goto-word-0)
(setq avy-background t)
(setq avy-orders-alist
      '((avy-goto-char . avy-order-closest)
        (avy-goto-word-0 . avy-order-closest)))

(define-key evil-insert-state-map (kbd "<C-return>") 'evil-open-below)

(global-anzu-mode +1)

(require 'diminish)
(diminish 'company-mode)
(diminish 'hz-mode "hz")
(diminish 'undo-tree-mode)
(diminish 'eldoc-mode)
(diminish 'ivy-mode)
(diminish 'projectile-mode)
(diminish 'anzu-mode)
(diminish 'auto-revert-mode)
(diminish 'slime-mode)
(diminish 'eldoc-mode)
(diminish 'aggressive-indent-mode)
(diminish 'auto-revert-mode)


(add-hook 'org-mode-hook '(lambda () (setq fill-column 80)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)


;; ==================== org mode ==========================
(require 'org-superstar)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files (quote ("~/Dropbox/notes"
			       "~/Dropbox/notes/archive/")))
(setq org-archive-location "~/Dropbox/notes/archive/archive.org::")
(setq org-default-notes-file "~/Dropbox/notes/org_capture.org")
(setq org-directory "~/Dropbox/notes/")
(setq org-capture-templates
      '(
	("n" "Note" entry (file org-default-notes-file) "* %? %i\n%U\tFile:%F" :empty-lines 1)
	("t" "TODO" entry (file org-default-notes-file) "* TODO %? %i\n%U\tFile:%F" :empty-lines 1)))



;; (setq org-journal-file-format "Journal%Y.org")
;; (setq org-journal-date-format "%A, %m/%d/%Y")
;; (setq org-journal-dir "~/Dropbox/notes/")
;; (setq org-journal-file-type 'yearly)
;; (require 'org-journal)

;; ==================== org mode ==========================

(setq imenu-list-position 'left)
(global-set-key (kbd "C-'") #'imenu-list-smart-toggle)

(setq visible-bell nil)
(setq ring-bell-function 'ignore)


;;(load-theme 'spacemacs-dark t)
(set-background-color "#FFFDE9")

(blink-cursor-mode -1)
(global-hl-line-mode)

(setq inhibit-splash-screen t)
;;(beacon-mode 1)



;;=================lsp-mode======================

;; lisp
(slime-setup '(slime-fancy slime-company))

;; (setq slime-lisp-implementations
;;       '((sbcl ("sbcl" "--core" "sbcl.core-for-slime"))))

(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))

(add-hook 'lisp-mode-hook #'aggressive-indent-mode)
(require 'eval-in-repl-slime)
(add-hook 'lisp-mode-hook
      '(lambda ()
         (local-set-key (kbd "<C-return>") 'eir-eval-in-slime)))

(with-eval-after-load 'eval-in-repl-slime
  (define-key evil-insert-state-map (kbd "<C-return>") 'eir-eval-in-slime))

;; (frame-char-width)
;; (frame-char-height)
;; (window-total-height)
;; (window-total-width)
;; (window-body-height)
;; (window-body-width)


(setq default-frame-alist '((width . 160)
			    (height . 55)
			    (font . "Menlo-18")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   (quote
    (dracula-theme yasnippet web-mode undo-tree telephone-line sr-speedbar spacemacs-theme slime-company rainbow-delimiters projectile powerline ox-pandoc org-superstar org-journal ob-go magit lsp-mode json-mode js2-mode ivy-prescient imenu-list ido-vertical-mode htmlize helm golint go-eldoc exec-path-from-shell evil-collection eval-in-repl diminish counsel company-go company-anaconda cider beacon auto-complete anzu aggressive-indent ace-jump-mode)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
