
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Needed to install Magit: Melpa repository
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(modus-vivendi))
 '(custom-safe-themes
   '("7ea491e912d419e6d4be9a339876293fff5c8d13f6e84e9f75388063b5f794d6" "96c56bd2aab87fd92f2795df76c3582d762a88da5c0e54d30c71562b7bf9c605" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))
 '(ido-use-virtual-buffers t)
 '(package-selected-packages
   '(key-chord evil helm company-go mode-line-bell modus-vivendi-theme modus-operandi-theme fill-column-indicator restart-emacs telephone-line company magit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq default-directory "~/")

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


;; c++ sane tab defaults
(defvaralias 'c-basic-offset 'tab-width)
(defun c++-tab-defaults ()
  (setq-default indent-tabs-mode t)
  (setq-default tab-width 4)) ; Assuming you want your tabs to be four spaces wide
(add-hook 'c++-mode-hook 'c++-tab-defaults)


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

;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; (setq-local flycheck-python-pylint-executable "python3")

;; (add-hook 'flycheck-mode-hook #'flycheck-virtualenv-setup)

;; delete selected text
(delete-selection-mode 1)

;; disable ding
(setq visible-bell 1)


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

;; when in wrap-text-mode, wrap at 80
(setq-default fill-column 80)


;; Workaround for error received when copying from VNC
;; (see bug report: http://emacs.1067599.n8.nabble.com/bug-23681-25-1-50-gui-get-selection-error-when-paste-from-windows-to-Emacs-25-through-vnc-td399376.html)
(setq x-select-request-type 'STRING) 

;; faster tramp default
(setq tramp-default-method "ssh")

;; hacky indentation editing macros
(defun tabs-to-spaces ()
  (interactive)
  (while (re-search-forward "	" nil t)
    (replace-match "    "))
  t)
(fset 'add-two-spaces
   [?\C-a ?\C-2 ?  ?\C-a ?\C-n])

(mode-line-bell-mode)

;; needed for my mac's emacs.app
(setq default-directory "~/")
(setq command-line-default-directory "~/")

(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(helm-mode 1)

;; Enable Evil
(require 'evil)
(evil-mode 1)

;; Exit insert mode by pressing j and then j quickly
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)
