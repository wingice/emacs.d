;;; init-linux.el --- Linux specific config  -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  ;; The PGTK/Wayland build (emacs-wayland) follows the compositor's HiDPI
  ;; scale factor itself, so a normal point size is correct here.  The X11
  ;; build renders at 1x on this 2.25x display, which made text look tiny.
  (set-face-attribute 'default nil
                      :family "FiraCode Nerd Font"
                      :height 110)                            ;; English Font, 12pt
  (dolist (charset '(kana han symbol cjk-misc bopomofo))         ;; Chinese Font
    (set-fontset-font (frame-parameter nil 'font)
		      charset (font-spec :family "Noto Sans CJK SC"
					 :size 12)))
  ;; Single unicode fallback for symbols/emoji/box-drawing
  (set-fontset-font (frame-parameter nil 'font)
		    'unicode (font-spec :family "Noto Sans Symbols") nil 'append)

(setq shell-file-name "bash")
(setq shell-command-switch "-c")

  ;; (require 'ibus)
  ;; (add-hook 'after-init-hook 'ibus-mode-on)
)


(provide 'init-linux)
