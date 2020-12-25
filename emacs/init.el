(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (boundp 'use-package-version)
  (package-install 'use-package))

(require 'use-package)

(setq xdg-data-home			"~/.local/share"
      xdg-config-home			"~/.config"
      xdg-cache-home			"~/.cache"
      xdg-download-dir			"~/downloads")

(setq custom-file			(concat user-emacs-directory "custom.el")
      config-org-file			(concat user-emacs-directory "readme.org"))

(setq local-confs/font-height		105		; 10 = 1pt
      local-confs/tool-bar		-1		; -1 for desabling
      local-confs/column-nums		t		; number of current column
      local-confs/line-nums		t		; number of current line
      )

;; (setenv "PATH"
;; 	(concat xdg-data-home	"/cargo/bin"	":"
;; 		xdg-data-home	"/bin"		":"
;; 		(getenv "PATH")))

(defun tangle-file ()
  "Tangle file if name equals to `config-org-file`"
  (when (string= buffer-file-name
		 config-org-file)
    (org-babel-tangle-file buffer-file-name)))
(add-hook 'after-save-hook 'tangle-file)

(use-package spacemacs-theme
  :ensure t :defer t
  :hook (after-init . load-spacemacs-theme)
  :init
  (defun load-spacemacs-theme ()
    "Load spacemacs dark theme"
    (load-theme 'spacemacs-dark t)))

(tool-bar-mode -1)
(column-number-mode t)

(set-face-attribute 'default nil :height local-confs/font-height)



(use-package which-key
  :ensure t
  :custom
  (which-key-idle-delay 0)
  (which-key-idle-secondary-delay 0.05)
  :config
  (which-key-mode))

(use-package reverse-im
  :ensure t
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))

(use-package helm
  :ensure t
  :bind (:map helm-command-map
	 ("C-c h" . helm-execute-persistent-action)))

(use-package tree-sitter
  :ensure t
  :hook ((after-init . global-tree-sitter-mode)
	 ((sh-mode
	   c-mode c++mode rust-mode
	   java-mode python-mode
	   js2-mode json-mode html-mode) . tree-sitter-hl-mode))
  :config
  (add-to-list 'tree-sitter-load-path
	       (concat xdg-data-home "/tree-sitter/bin")))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

(use-package lsp-mode
  :ensure t
  :hook ((prog-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package rust-mode
  :ensure t
  :after tree-sitter
  :init
  (tree-sitter-load 'rust)
  (tree-sitter-require 'rust))

(defun sudo-reopen ()
  "Open curent file with sudo"
  ;; (interactive "p")
  (find-file (concat "/sudo::" buffer-file-name)))
