
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;;         use package
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(eval-when-compile
  (require 'use-package))

(use-package org-superstar
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(use-package exec-path-from-shell
  :diminish
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package go-mode
  :init
  (defun my-go-mode-hook ()
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save)
    (local-set-key (kbd "M-SPC") 'godef-jump)
    (local-set-key (kbd "C-c C-g") 'golint)
    (local-set-key (kbd "M-b") 'pop-tag-mark))
  :config
  (flymake-mode -1)
  (add-hook 'go-mode-hook 'my-go-mode-hook))

(use-package eldoc
  :diminish)

(use-package lsp-mode
  :diminish
  :config
  (add-hook 'go-mode-hook #'lsp-deferred))


(use-package company
  :diminish
  :init
  (setq company-text-icons-add-background t
	company-tooltip-idle-delay 10
	company-tooltip-minimum 4
	company-tooltip-minimum-width 40
	company-idle-delay .3
	company-show-numbers t
	company-echo-delay 0
	company-format-margin-function #'company-text-icons-margin)
  :config
  (global-company-mode)
  (define-key company-active-map (kbd "C-n") (lambda () (interactive) (company-complete-common-or-cycle 1)))
  (define-key company-active-map (kbd "C-p") (lambda () (interactive) (company-complete-common-or-cycle -1))))

(use-package yasnippet
  :diminish
  :config
  (yas-global-mode)
  (define-key yas-minor-mode-map [(tab)]        nil)
  (define-key yas-minor-mode-map (kbd "TAB")    nil)
  (define-key yas-minor-mode-map (kbd "<tab>")  nil))

(use-package aggressive-indent
  :diminish
  :config
  (add-hook 'lisp-mode-hook #'aggressive-indent-mode))


(use-package ob-go
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((go . t))))

(use-package rainbow-delimiters
  :diminish
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


(use-package evil
  :diminish
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree)
  (define-key evil-normal-state-map (kbd "SPC") 'avy-goto-char-2))


(use-package undo-tree
  :diminish
  :init
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  :config
  (global-undo-tree-mode))

(use-package ivy
  :diminish
  :init
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-height 15)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  :config
  (global-set-key (kbd "C-h f") 'counsel-describe-function)
  (global-set-key (kbd "C-h v") 'counsel-describe-variable)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file))

(use-package swiper
  :diminish
  :config
  (global-set-key "\C-s" 'swiper))

(use-package counsel
  :diminish
  :config
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))


(use-package helm
  :diminish
  :init
  (setq helm-recentf-fuzzy-match t)
  (setq helm-buffers-fuzzy-matching t)
  :config
  (global-set-key (kbd "C-x C-r") 'helm-recentf)
  (global-set-key (kbd "C-x r l") 'helm-bookmark)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action))

(use-package projectile
  :diminish
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package telephone-line
  :diminish
  :init
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

  :config
  (telephone-line-evil-config))

(use-package avy
  :diminish
  :init
  (setq avy-background t)
  (setq avy-orders-alist
	'((avy-goto-char . avy-order-closest)
	  (avy-goto-word-0 . avy-order-closest))))


(use-package anzu
  :diminish
  :config
  (global-anzu-mode +1))

(use-package diminish
  :config
  (diminish 'yas-minor-mode)
  (diminish 'hz-mode "hz"))


(use-package eval-in-repl-slime
  :config
  (add-hook 'lisp-mode-hook
	    '(lambda ()
	       (local-set-key (kbd "<C-return>") 'eir-eval-in-slime)))
  (define-key evil-insert-state-map (kbd "<C-return>") 'eir-eval-in-slime))


(use-package slime
  :init
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  (setq slime-contribs '(slime-fancy)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;;         end use package
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package recentf
  :init
  (setq recentf-max-saved-items 150)
  :config
  (recentf-mode 1)
  (run-at-time nil (* 25 60) 'recentf-save-list))


(use-package tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (add-to-list 'tramp-remote-path "~/go/bin"))


(use-package emacs
  :config
  (setq backup-directory-alist `(("." . "~/.saves")))
  (setq delete-old-versions t
	kept-new-version 4
	kept-old-version 2
	version-control t)
  (setq auto-save-default nil)
  (setq auto-save-interval 10000)
  (setq case-fold-search t)
  (setq visible-bell nil)
  (setq ring-bell-function 'ignore)
  (setq inhibit-splash-screen t)
  (set-background-color "#FFFDE9")
  (setq scroll-conservatively 101)
  (setq org-confirm-babel-evaluate 'nil)
  (setq fill-column 80)
  (setq default-frame-alist '((width . 160)
			      (height . 55)
			      (font . "Menlo-18")))
  :config

  (blink-cursor-mode -1)
  (global-hl-line-mode)
  (show-paren-mode t)
  (electric-pair-mode 1)
  (menu-bar-mode t)
  (tool-bar-mode -1)
  (add-hook 'org-mode-hook 'turn-on-auto-fill)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (global-display-line-numbers-mode t)
  (global-auto-revert-mode 1))


;;;;;; ibuffer

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

(global-set-key (kbd "C-x C-b") 'ibuffer)
;; ==================== org mode ==========================

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . nil)
   (R . t)
   (python . t)
   (shell . t)
   (lisp . t)))

(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files (quote ("~/Dropbox/notes"
			       "~/Dropbox/notes/archive/")))
(setq org-archive-location "~/Dropbox/notes/archive/archive.org::")
(setq org-default-notes-file "~/Dropbox/notes/org_capture.org")
(setq org-directory "~/Dropbox/notes/")
(setq org-capture-templates
      '(("n" "Note" entry (file org-default-notes-file) "* %? %i\n%U\tFile:%F" :empty-lines 1)
	("t" "TODO" entry (file org-default-notes-file) "* TODO %? %i\n%U\tFile:%F" :empty-lines 1)))

;; ==================== org mode ==========================


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;;         use funcs
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/hz-mode")
(use-package hz-mode
  :diminish "hz")


(defun my/shell-set-hook ()
  (when (file-remote-p (buffer-file-name))
    (setq shell-file-name "/bin/bash")))

(add-hook 'find-file-hook #'my/shell-set-hook)

;; (defun my-display-something ()
;;   (when (file-remote-p default-directory)
;;     (setq default)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(global-display-line-numbers-mode t)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



(defun increment-number-at-point ()
    (interactive)
    (skip-chars-backward "0-9")
    (or (looking-at "[0-9]+")
	(error "No number at point"))
    (replace-match (number-to-string (- (string-to-number (match-string 0)) 2))))
(global-set-key (kbd "C-c +") 'increment-number-at-point)
