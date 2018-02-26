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
  (set-default-font "-*-Courier-*-normal-normal-*-19-*-*-*-m-0-*-*")
  (global-set-key (kbd "<f9>") 'buffer-menu)
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin")) ;;to support homebrew Path
  (setq exec-path (append exec-path '("/usr/local/bin")))
  ;;在Emacs中显示斜体中文时，无法正常显示，只显示方块的问题。原因是因为Emacs没有为斜体设置中文字体
  ;;when showing Italic Chinese characters, only rectangle block shown
  (set-fontset-font
   (frame-parameter nil 'font)
   'han
   (font-spec :family "Hiragino Sans GB" ))

  (defun popup-notification(title msg)
    (interactive)
    (ns-do-applescript (concatenate 'string "display notification \"" msg "\" with title \"" title "\""))
    
    )
)


(provide 'init-osx)
