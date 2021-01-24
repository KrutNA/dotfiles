(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq xdg-data-home                     "~/.local/share"
      xdg-config-home                   "~/.config"
      xdg-cache-home                    "~/.cache"
      xdg-download-dir                  "~/downloads")

(setq custom-file                       (concat user-emacs-directory "custom.el")
      config-org-file                   (concat user-emacs-directory "readme.org")
      backup-directory-alist            `(("." . ,(concat user-emacs-directory "backups"))))

(setq local/font-height                 105             ; 10 = 1pt
      local/tool-bar                    -1              ; -1 for desabling
      local/column-num                  t               ; number of current column
      local/line-num                    t               ; number of current line

      ;; LaTeX
      local/latex-compiler              "xelatex"       ; default latex compiller

      ;; programming
      local/electric-pair-mode          t               ; double parenthesis
      local/paren-mode                  t               ; show matching pars

      ;; which-key
      ;; Zero value of delay may cause issues
      local/wk-delay                    0.01            ; delay to which-key after keypress 
      local/wk-s-delay                  0.05            ; delay to rerender

      ;; path to `tree-sitter` binaries
      local/tree-sitter-bins            (concat xdg-data-home "/tree-sitter/bin")
      )

(setenv "PATH"
        (concat xdg-data-home   "/cargo/bin"    ":"
                xdg-data-home   "/bin"          ":"
                (getenv "PATH")))

(use-package reverse-im
  :ensure t
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))

(use-package spacemacs-theme
  :ensure t :defer t
  :hook (after-init . load-spacemacs-theme)
  :init
  (defun load-spacemacs-theme ()
    "Load spacemacs dark theme"
    (load-theme 'spacemacs-dark t)))

(tool-bar-mode                          local/tool-bar)
(column-number-mode                     local/column-num)
(line-number-mode                       local/line-num)

(set-face-attribute 'default nil :height local/font-height)

(use-package delight
  :ensure t
  :init
  (delight '((java-mode   "ℑ")
	     (c-mode      "c")
	     (c++-mode    "cxx")
	     (python-mode "🐍")
	     (lisp-interaction-mode "LispI")
	     (emacs-lisp-mode "EL")
	     (eldoc-mode nil eldoc)
	     (abbrev-mode nil abbrev))))

(use-package helm
  :ensure t
  :bind (:map helm-command-map ("C-c h" . helm-execute-persistent-action)))

(use-package which-key
  :ensure t
  :delight
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay local/wk-delay)
  (which-key-idle-secondary-delay local/wk-s-delay))

(use-package emojify
  :ensure t
  :hook (after-init . global-emojify-mode))

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package auctex
  :ensure t :defer t)

(use-package org
  :after ox-latex :defer t
  ;; :hook (org-mode . turn-on-org-cdlatex)
  :custom
  (org-src-fontify-natively t)
  (org-confirm-babel-evaluate nil)
  (org-latex-compiler local/latex-compiler)
  (org-babel-inline-result-wrap "%s")
  (org-babel-load-languages '((emacs-lisp      . t)
                              (shell           . t)
                              (awk             . t)
                              ;; (rust            . t)
                              (C               . t)
                              ;; (cpp             . t)
                              (python          . t)))
  (org-latex-packages-alist `((,(concat "a4paper,left=3cm,top=2cm,right=1.5cm,bottom=2cm,"
                                        "marginparsep=7pt,marginparwidth=.6in") "geometry" t)
                              ;; ("" "cmap" t)
                              ("" "xcolor" t)
                              ;; ("" "listings" t)
                              ("AUTO" "polyglossia" t ("xelatex")))))

(use-package emacs
  :custom 
  (show-paren-mode local/paren-mode)
  (electric-pair-mode local/paren-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode org-mode) . rainbow-delimiters-mode))

(use-package tree-sitter
  :ensure t
  :hook ((tree-sitter-after-on . tree-sitter-hl-mode))
  :custom
  (global-tree-sitter-mode t)
  :config
  (add-to-list 'tree-sitter-load-path local/tree-sitter-bins))


(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

(use-package lsp-mode
  :ensure t
  :hook (((sh-mode
	   c-mode c++-mode
	   ) . lsp)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package company
  :ensure t
  :delight
  :hook (after-init . global-company-mode))

(use-package company-box
  :ensure t
  :delight
  :hook (company-mode . company-box-mode))

(use-package yasnippet
  :ensure t
  :delight yas-minor-mode
  :hook ((prog-mode org-mode) . yas-minor-mode))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(use-package projectile
  :ensure t
  :delight '(:eval (if (not (string= (projectile-project-name) "-"))
		       (concat " [" (projectile-project-name) "]")
		     ""))
  :hook (after-init . projectile-mode)
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package dap-mode
  :ensure t
  :after lsp
  :config
  (dap-mode t)
  (dap-ui-mode t)
  :init
  (dap-register-debug-template "Rust::GDB Run Configuration"
                               (list :type "gdb"
                                     :request "launch"
                                     :name "GDB::Run"
                                     :gdbpath "rust-gdb"
                                     :target nil
                                     :cwd nil)))
(use-package dap-java
  :after lsp-java)

(use-package rust-mode
  :ensure t :defer t
  :hook (rust-mode . lsp)
  :delight "ℝ")





(use-package lsp-java
  :ensure t :defer t)

(use-package kotlin-mode
  :ensure t :defer t
  :delight "Kt"
  :hook (kotlin-mode . lsp))

(use-package groovy-mode
  :ensure t :defer t
  :hook (groovy-mode . lsp))



(use-package csharp-mode
  :ensure t :defer t
  :delight "C#"
  :hook (csharp-mode . lsp)
  :config
  (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode)))

(use-package js2-mode
  :ensure t :defer t
  :delight "JS"
  :hook (js2-mode . lsp))

(use-package typescript-mode
  :ensure t :defer t
  :delight "TS"
  :mode ("\\.ts$" "\\.tsx$")
  :hook (typescript-mode . lsp))

(use-package web-mode
  :ensure t :defer t
  :hook (typescript-mode . web-mode)
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-style-padding 2)
  (web-mode-script-padding 2))

(use-package rjsx-mode
  :ensure t :defer t
  :mode ("\\.jsx$" . rjsx-mode))

(use-package json-mode
  :defer t :defer t
  :delight "JSON"
  :hook (json-mode . lsp))

(use-package yaml-mode
  :ensure t :defer t)

(use-package smtpmail
  :defer t
  :custom
  (message-send-mail-function         'smtpmail-send-it)
  (message-send-mail-function         'message-send-mail-with-sendmail)
  (sendmail-coding-system             'utf-8))

(use-package mu4e
  :load-path "/usr/share/emacs/site-lisp/mu4e/"
  :commands (mu4e)
  :after smtpmail
  :bind (("C-x m" . mu4e)
	 :map mu4e-headers-mode-map
	 ("v"     . mu4e-headers-view-message))
  :custom
  (mu4e-maildir-shortcuts              t)
  (mu4e-change-filenames-when-moving   t)
  (mu4e-view-prefer-html               t)
  (mu4e-show-images                    t)
  (mu4e-view-image-max-width         800)
  (mu4e-enable-async-operations        t)
  (message-kill-buffer-on-exit         t)
  (mu4e-enable-mode-line               t)
  (mu4e-index-cleanup                nil) 
  (mu4e-index-lazy-check               t)
  (mu4e-use-fancy-chars              nil)
  (mu4e-enable-notifications           t)
  (mu4e-html2text-command              "/usr/local/bin/w3m -T text/html")
  (mu4e-get-mail-command               "mbsync -c ~/.config/mail/mbsyncrc mailru.main")
  :config
  (defun mu4e/check-msg-contact (msg)
    ""
    (when msg
      (mu4e-message-contact-field-matches msg :from-or-to user-mail-address)))
  (defun mu4e/switch-msg (name)
    "Message on switch"
    (mu4e-message "Switch to %s" name))
  (setq local/msmtp-config (concat xdg-config-home "/mail/msmtprc"))
  (setq mu4e-contexts
	`( ,(make-mu4e-context
	       :name       "mailru.main"
	       :enter-func (lambda () (mu4e/switch-msg "MailRu Main"))
	       :match-func 'mu4e/check-msg-contact
	       :vars      '((user-mail-address             . "krutko_n_a@mail.ru")
			    (user-full-name                . "Krutko Nikita")
			    (mu4e-drafts-folder            . "/mailru.main/Черновики")
			    (mu4e-trash-folder             . "/mailru.main/Корзина")
			    (mu4e-sent-folder              . "/mailru.main/Отправленные")
			    (mu4e-refile-folder            . "/mailru.main/Архив")
			    (mu4e-compose-signature        . "\nBest regards,\nKrutko Nikita")
			    (smtpmail-smtp-server          . "smtp.mail.ru")
			    (smtpmail-smtp-service         . 465)
			    (starttls-use-gnutls           . t)
			    (smtpmail-starttls-credentials . '(("smtp.mail.ru" 465 nil nil)))
			    (smtpmail-auth-credentials     . '(("smtp.mail.ru" 465
								"krutko_n_a@mail.ru" nil)))
			    (smtpmail-smtp-user            . "krutko_n_a@mail.ru"))))))

(defun sudo-reopen ()
  "Open curent file with sudo"
  (interactive)
  (find-file (concat "/sudo::" buffer-file-name)))

(defun tangle-file ()
  "Tangle file if name equals to `config-org-file`"
  (when (string= buffer-file-name
                 config-org-file)
    (org-babel-tangle-file buffer-file-name)))
(add-hook 'after-save-hook 'tangle-file)
