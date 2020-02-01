emacs setup



## golang setup

```elisp
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


(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))

(defun align-equals (begin end)
    (interactive "r")
    (align-regexp begin end "\\(\\s-*\\)=" 1 1))


(global-set-key (kbd "M-=") 'align-equals)

```


## TODO
- the enviroment variable `$PATH` is not read succesfully
- ibuffer groups display even the groups has 0 member
- 
