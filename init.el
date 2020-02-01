;; add melpa
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives
	'("melpa" . "http://melpa.org/packages/"))

(setq exec-path (append '("/usr/local/bin"
			  "/usr/bin"
			  "/usr/local/go/bin"
			  "/Users/huajiezhang/go/bin") exec-path))

(setenv "PATH" (concat "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/Users/huajiezhang/go/bin:"
		       (getenv "PATH")))

;; (add-to-list 'load-path (concat (getenv "GOPATH")  "/src/golang.org/x/lint/misc/emacs/"))

(defun my-go-mode-hook ()
    ;; prefer goimports, if present
    (if (executable-find "goimports")
    (setq gofmt-command "goimports"))

    ;; Format code when we save
    (add-hook 'before-save-hook 'gofmt-before-save)

    ;; esc-space to jump to definition
    (local-set-key (kbd "M-SPC") 'godef-jump)
    ;; escp-b to jump (b)ack
    (local-set-key (kbd "M-b") 'pop-tag-mark))

(add-hook 'go-mode-hook 'my-go-mode-hook 'go-eldoc-setup)

(defun align-equals (begin end)
    (interactive "r")
    (align-regexp begin end "\\(\\s-*\\)=" 1 1))


(global-set-key (kbd "M-=") 'align-equals)


(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))

(add-hook 'html-mode-hook 'web-mode)
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(require 'rx)

;; (eval-after-load "company"
;;  '(add-to-list 'company-backends 'company-anaconda))

(eval-after-load "company"
 '(add-to-list 'company-backends '(company-anaconda :with company-capf)))

;; (setq-default tab-width 4)

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode t)
        (setq tab-width 4)
        (setq python-indent-offset 4)))

(define-key global-map "\C-cc" 'org-capture)

(require 'ob-go)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((go . t)))

(setq show-paren-mode t)
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(add-hook 'go-mode-hook 'go-eldoc-setup)

(setq org-babel-python-command "/Library/Frameworks/Python.framework/Versions/3.8/bin/python3")

(setq org-confirm-babel-evaluate 'nil)

(setq ibuffer-saved-filter-groups
      '(("home"
	 ("Org" (or (mode . org-mode)
		    (filename . "OrgMode")))
	 ("py" (mode . python-mode))
	 ("md" (filename . "md"))
	 ("go" (filename . "go"))
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
    ))

(setq blink-cursor-mode nil)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

(setq default-frame-alist '((font . "Menlo-26")))

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

(menu-bar-mode 1)

;; don't show tool bar
(tool-bar-mode -1)

;; display line numbers
(global-linum-mode t)
(evil-mode 1)

(ivy-mode 1)
(setq ivy-height 15)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(global-set-key "\C-x\ \C-b" 'ibuffer)

(add-to-list 'load-path "~/.emacs.d/hz-mode")

(require 'hz-mode)

(defun my/shell-set-hook ()
  (when (file-remote-p (buffer-file-name))
    (setq shell-file-name "/bin/bash")))
(add-hook 'find-file-hook #'my/shell-set-hook)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)
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

(setq linum-format "%4d \u2502")

(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (setq ido-use-filename-at-point 'guess)
(setq ido-vertical-show-count t)

(require 'recentf)
(recentf-mode 1)
;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)
(setq recentf-max-saved-items 50)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file]] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent files: "recentf-list))
      (message "Opening file ...")
    (message "Abortingn...")))

(global-set-key "\C-x\ \C-r" 'ido-recentf-open)

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

(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

(require 'diminish)
(diminish 'company-mode)
(diminish 'hz-mode)
(diminish 'undo-tree-mode)
(diminish 'eldoc-mode)
(diminish 'ivy-mode)
(diminish 'projectile-mode)

(add-hook 'org-mode-hook '(lambda () (setq fill-column 80)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)


(setq org-agenda-files (list "/Users/huajiezhang/test/notes/org_mode.org"))

(load-theme 'wombat)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("/Users/huajiezhang/test/notes/org_mode.org")))
 '(package-selected-packages
   (quote
    (golint go-eldoc company-anaconda anaconda-mode web-mode company-go go-mode magit ox-pandoc js2-mode markdown-mode telephone-line sr-speedbar spacemacs-theme rainbow-delimiters projectile powerline ido-vertical-mode htmlize evil diminish counsel company auto-complete ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
