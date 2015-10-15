(when (eq system-type 'gnu/linux)
  (set-default-font "-*-Courier 10 Pitch-normal-normal-normal-*-19-*-*-*-m-0-*-*")
  (set-face-attribute 'default nil :font "Courier 10 Pitch 14")  ;; Setting English Font
  (dolist (charset '(kana han symbol cjk-misc bopomofo))         ;; Chinese Font
    (set-fontset-font (frame-parameter nil 'font)
		      charset (font-spec :family "Microsoft Yahei"
					 :size 18)))

(setq shell-file-name "bash")
(setq shell-command-switch "-c")
  
  ;; (require 'ibus) 
  ;; (add-hook 'after-init-hook 'ibus-mode-on) 
)


(provide 'init-linux)
