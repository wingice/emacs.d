(when (fboundp 'set-charset-priority)
    (set-charset-priority 'unicode))
  (prefer-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8)
  (setq system-time-locale "C")
  (unless (eq system-type 'windows-nt)
    (set-selection-coding-system 'utf-8))

(setq system-time-locale "en_US")
(setq display-time-24hr-format t)

(setq holiday-christian-holidays nil)
(setq holiday-hebrew-holidays nil)
(setq holiday-islamic-holidays nil)
(setq holiday-solar-holidays nil)
(setq holiday-bahai-holidays nil)

(setq general-holidays '((holiday-fixed 1 1 "元旦")
			 (holiday-fixed 2 14 "情人节")
			 (holiday-fixed 5 1 "劳动节")
			 (holiday-fixed 10 1 "国庆节")))

(provide 'init-locales)
