;;; init-osx.el --- macOS specific config  -*- lexical-binding: t; -*-

;;(when *is-a-mac*
;;  (setq mac-command-modifier 'meta)
;;  (setq mac-option-modifier 'none)
;;  (setq default-input-method "MacOSX")
;;  ;; Make mouse wheel / trackpad scrolling less jerky
;;  (setq mouse-wheel-scroll-amount '(0.001))
;;  (when *is-cocoa-emacs*
;;    ;; Woohoo!!
;;    (global-set-key (kbd "M-`") 'ns-next-frame)
;;    (global-set-key (kbd "M-h") 'ns-do-hide-emacs)
;;    (eval-after-load 'nxml-mode
;;      '(define-key nxml-mode-map (kbd "M-h") nil))
;;    (global-set-key (kbd "M-ˍ") 'ns-do-hide-others) ;; what describe-key reports for cmd-option-h
;;    (global-set-key (kbd "M-c") 'ns-copy-including-secondary)
;;    (global-set-key (kbd "M-v") 'ns-paste-secondary)))


(when *is-a-mac*
  (when (display-graphic-p)
    ;; JetBrains Mono NL (No Ligatures) at Regular weight.
    ;; NL variant guarantees no ligature substitution regardless of
    ;; prettify-symbols-mode or composition tables.
    (set-face-attribute 'default        nil :family "JetBrains Mono NL" :weight 'regular :height 150)
    (set-face-attribute 'fixed-pitch    nil :family "JetBrains Mono NL" :weight 'regular :height 150)
    (set-face-attribute 'variable-pitch nil :family "JetBrains Mono NL" :weight 'regular :height 150)
    ;; Fix Chinese italic display — set Han font for the current fontset
    (set-fontset-font
     (frame-parameter nil 'font)
     'han
     (font-spec :family "Hiragino Sans GB"))
    ;; Single unicode fallback for symbols/emoji/box-drawing
    (set-fontset-font
     (frame-parameter nil 'font)
     'unicode
     (font-spec :family "Apple Symbols") nil 'append))
  (global-set-key (kbd "<f9>") 'consult-buffer)
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))

  (defun popup-notification(title msg)
    (interactive)
    (ns-do-applescript (concat "display notification \"" msg "\" with title \"" title "\" sound name \"Glass\""))
  )

  (defun test-osx-notification()
    (interactive)
    (popup-notification "test-mac-notification" "Hello World!"))

  (defun lock-screen ()
    "Lock the screen immediately (macOS): sends ⌃⌘Q."
    (interactive)
    (ns-do-applescript
     "tell application \"System Events\" to keystroke \"q\" using {control down, command down}"))

  (add-hook 'org-timer-done-hook #'lock-screen)

  (global-set-key (kbd "s-p") 'consult-projectile)

  ;; The Lenovo Traditional USB Keyboard's <menu>/<apps> key is delivered
  ;; by macOS as an NSEvent whose characters field is 0x10 (DLE) with no
  ;; modifier flag, which Emacs then interprets as `C-p' — colliding with
  ;; `previous-line'.  Hammerspoon (~/.hammerspoon/init.lua) intercepts
  ;; the CGEvent when Emacs is frontmost and rewrites it to <f13>, so
  ;; Finder etc. still see a normal Menu-key event elsewhere.  The <f13>
  ;; binding itself lives in init-misc.el alongside <menu>/<apps>.
  )
(provide 'init-osx)
