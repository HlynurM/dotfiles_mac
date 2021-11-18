(setq doom-theme 'doom-horizon)
(map! :leader
      :desc "Load a new theme"
      "h t" #'councel-load-theme)

(setq doom-font                 (font-spec :family "Source Code Pro" :size 14)
      doom-variable-pitch-font  (font-spec :family "Source Code Pro" :size 15)
      doom-unicode-font         (font-spec :family "Source Code Pro" :size 14)
      doom-big-font             (font-spec :family "Source Code Pro" :size 24)
      )
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face      :slant italic)
  '(font-lock-keyword-face      :slant italic))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))

(setq +ivy-buffer-preview t)

(when-let (dims (doom-store-get 'last-frame-size))
  (cl-destructuring-bind ((left . top) width height fullscreen) dims
    (setq initial-frame-alist
          (append initial-frame-alist
                  `((left . ,left)
                    (top . ,top)
                    (width . ,width)
                    (height . ,height)
                    (fullscreen . ,fullscreen))))))

(defun save-frame-dimensions ()
  (doom-store-put 'last-frame-size
                  (list (frame-position)
                        (frame-width)
                        (frame-height)
                        (frame-parameter nil 'fullscreen))))

(add-hook 'kill-emacs-hook #'save-frame-dimensions)

(use-package rjsx-mode
  :ensure t
  :mode "\\.js\\'")

(defun setup-tide-mode()
  "Setup function for tide."
  (interactive)
  (tide-setup)
  (flyckeck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)

(add-hook 'js-mode-hook #'setup-tide-mode)

(use-package tide
  :ensure t
  :after (rjsx-mode company flycheck)
  :hook (rjsx-mode . setup-tide-mode))

(use-package prettier-js
  :ensure t
  :after (rjsx-mode)
  :hook (rjsx-mode . prettier-js-mode))


