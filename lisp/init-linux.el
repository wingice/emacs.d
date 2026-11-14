;;; init-linux.el --- Linux specific config  -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (set-frame-font "-*-FiraCode Nerd Font-normal-normal-normal-*-24-*-*-*-m-0-*-*")
  (set-face-attribute 'default nil :font "FiraCode Nerd Font")  ;; Setting English Font
  (dolist (charset '(kana han symbol cjk-misc bopomofo))         ;; Chinese Font
    (set-fontset-font (frame-parameter nil 'font)
		      charset (font-spec :family "Microsoft Yahei"
					 :size 18)))
  ;; Single unicode fallback for symbols/emoji/box-drawing
  (set-fontset-font (frame-parameter nil 'font)
		    'unicode (font-spec :family "Noto Sans Symbols") nil 'append)

(setq shell-file-name "bash")
(setq shell-command-switch "-c")
  
  ;; (require 'ibus) 
  ;; (add-hook 'after-init-hook 'ibus-mode-on) 
)


(provide 'init-linux)
