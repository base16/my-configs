(add-to-list 'load-path "~/emacs")
(add-to-list 'load-path "~/emacs/scala-emacs")


;(load "php-mode")
;(load "redspace")
;(load "java-complete")
(load "scala-mode")

;(require 'scala-mode-auto)

(add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.scala\\'" . scala-mode))

(add-hook 'java-mode-hook (lambda () (local-set-key (kbd "C-<tab>") 'java-complete)))

(fset 'align-eql-macro
      "\C-[xalign regexp\C-m = \C-m")

(global-set-key (kbd "C-M-y") 'align-eql-macro)

(setq php-mode-force-pear t)

(setq inhibit-splash-screen t)

    (defun command-line-diff (switch)
      (let ((file1 (pop command-line-args-left))
            (file2 (pop command-line-args-left)))
        (ediff file1 file2)))

    (add-to-list 'command-switch-alist '("diff" . command-line-diff))

    ;; Usage: emacs -diff file1 file2

;(add-hook 'before-save-hook 'delete-trailing-whitespace)

;(global-set-key [delete] 'delete-char)
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key [M-delete] 'kill-word)

(defconst su-c-style
  '((c-tab-always-indent . t)
    (indent-tabs-mode    . nil)
    (tab-width           . 4)
    (c-basic-offset      . 4)
    (c-offsets-alist     . ((substatement-open . 0)))
    (substatement-open   . 0))
  "StumbleUpon Programming Style")

(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (c-add-style "SU" su-c-style t))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(defun stumble (tab)
  (c-set-style "bsd")
  (setq c-basic-offset tab)
  (setq indent-tabs-mode nil)
  (setq tab-width tab))

;;(setq c-offsets-alist
;;      '((substatement-open . 0)))
;;(setq c-basic-offset 4)
;;(setq indent-tabs-mode t)
;;(setq tab-width 4)

;;(setq-default c-basic-offset 4)
;;(setq-default indent-tabs-mode t)
;;(setq-default tab-width 4)
;;(setq-default substatement-open 0)
