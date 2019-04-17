
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (solarized-light)))
 '(custom-safe-themes
   (quote
	("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(ido-use-virtual-buffers t)
 '(package-selected-packages
   (quote
	(smex solarized-theme telephone-line company racket-mode flycheck php-mode haskell-mode magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; c++ sane tab defaults
(setq-default indent-tabs-mode t)
(setq-default tab-width 4) ; Assuming you want your tabs to be four spaces wide
(defvaralias 'c-basic-offset 'tab-width)


;; This hack fixes indentation for C++11's "enum class" in Emacs.
;; http://stackoverflow.com/questions/6497374/emacs-cc-mode-indentation-problem-with-c0x-enum-class/6550361#6550361

(defun inside-class-enum-p (pos)
  "Checks if POS is within the braces of a C++ \"enum class\"."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (up-list -1)
      (backward-sexp 1)
	  (looking-back "enum[ \t]+class[ \t]+[^}]*"))))
;;	  (or (looking-back "enum\\s-+class\\s-+")
;;          (looking-back "enum\\s-+class\\s-+\\S-+\\s-*:\\s-*"))

(defun align-enum-class (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      0
    (c-lineup-topmost-intro-cont langelem)))

(defun align-enum-class-closing-brace (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      '-
    '+))

(defun fix-enum-class ()
  "Setup `c++-mode' to better handle \"class enum\"."
  (add-to-list 'c-offsets-alist '(topmost-intro-cont . align-enum-class))
  (add-to-list 'c-offsets-alist
               '(statement-cont . align-enum-class-closing-brace)))

(add-hook 'c++-mode-hook 'fix-enum-class)



;; org mode -- automatically change to done when all children are done
;; very cool
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
	(org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)


;; make parentheses show
(show-paren-mode 1)
(put 'dired-find-alternate-file 'disabled nil)

;; Needed to install Magit: Melpa repository
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Magit: open Magit status
(global-set-key (kbd "C-x g") 'magit-status)

(require 'org)
(setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n,\"")

;; toggle word wrap in org-mode
(add-hook 'org-mode-hook #'toggle-word-wrap)

;; fix truncating lines
(setq org-startup-truncated nil)

;; function to insert zero length space
(global-set-key (kbd "C-x 8 s") (lambda () (interactive) (insert "​")))

;; unbind Ctrl-Z
(global-unset-key (kbd "C-z"))

;; (setq python-shell-interpreter "python3")

;; flycheck
(require 'flycheck)

;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; (setq-local flycheck-python-pylint-executable "python3")

;; (add-hook 'flycheck-mode-hook #'flycheck-virtualenv-setup)

;; delete selected text
(delete-selection-mode 1)

;; disable ding
(setq visible-bell 1)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

;; telephone-line
(require 'telephone-line)
(setq telephone-line-primary-left-separator 'telephone-line-cubed-left
      telephone-line-secondary-left-separator 'telephone-line-cubed-hollow-left
      telephone-line-primary-right-separator 'telephone-line-cubed-right
      telephone-line-secondary-right-separator 'telephone-line-cubed-hollow-right)
(setq telephone-line-height 24
      telephone-line-evil-use-short-tag t)
;; configuration must end before here
(telephone-line-mode 1)

;; disable toolbar
(tool-bar-mode -1)

;; ido
(require 'ido)
(ido-mode t)

;; smex rebind keys
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "<menu>") 'smex)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
