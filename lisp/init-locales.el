(defun locale-is-utf8-p ()
  "Return t iff the \"locale\" command or environment variables prefer UTF-8."
  (flet ((is-utf8 (v) (and v (string-match "UTF-8" v))))
    (or (is-utf8 (and (executable-find "locale") (shell-command-to-string "locale")))
        (is-utf8 (getenv "LC_ALL"))
        (is-utf8 (getenv "LC_CTYPE"))
        (is-utf8 (getenv "LANG")))))

(when (or window-system (locale-is-utf8-p))
  (setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
  (set-language-environment 'utf-8)
  (when *is-carbon-emacs*
    (set-keyboard-coding-system 'utf-8-mac))
  (setq locale-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (unless (eq system-type 'windows-nt)
   (set-selection-coding-system 'utf-8))
  (prefer-coding-system 'utf-8))

(setq system-time-locale "en_US")
(set-coding-system-priority 'utf-8 'chinese-gb18030)
(setq display-time-24hr-format t)

(setq hebrew-holidays nil)
(setq islamic-holidays nil)

(setq general-holidays '((holiday-fixed 1 1 "元旦")
			 (holiday-fixed 2 14 "情人节")
			 (holiday-fixed 5 1 "劳动节")
			 (holiday-fixed 10 1 "国庆节")))

(provide 'init-locales)
