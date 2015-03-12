(when (eq system-type 'windows-nt)
  (set-language-environment 'UTF-8)
  (set-locale-environment "UTF-8")
  (prefer-coding-system 'utf-8)
  (prefer-coding-system 'gb18030)
  (setq file-name-coding-system 'gb18030)    ;;文件名编码
  (set-w32-system-coding-system 'gb18030)    ;;Windows下系统编码
  (set-selection-coding-system 'gb18030)    ;;选择块编码
  (set-default-font "Lucida Sans Typewriter 13")

  (set-fontset-font (frame-parameter nil 'font)    ;;设置中文字体
		    'han '("Microsoft YaHei" . "unicode-bmp"))
  
  (setq system-time-locale "C")

  (when window-system (set-frame-size (selected-frame) 132 36))

  ;;------------org-mode and appt settings
  (setq org-agenda-files '("c:/workspace/orgagenda/agenda.org" "c:/workspace/orgagenda/rem.notes.org"))

  (setq org-default-notes-file "c:\workspace/orgagenda/rem.notes.org")
  (setq default-directory "C:/workspace/working/")
  ;;  (setq org-agenda-clockreport-parameter-plist
  ;;      (quote (:maxlevel 5 :indent t :scope file)))

  (setq org-agenda-clockreport-parameter-plist '(:maxlevel 5 :indent t :scope file))

  ;; appt and reminder
  (require 'appt)
  (setq org-agenda-include-diary t)
  (setq appt-time-msg-list nil)

  ;; the appointment notification facility
  (setq
   appt-message-warning-time 3
   appt-display-mode-line t ;; show in the modeline
   appt-display-format 'window) ;; use our func
  (appt-activate 1) ;; active appt (appointment notification)
  (display-time) ;; time display is required for this...
  
  (require 'color-theme)
  (eval-after-load "color-theme"
    '(progn
       (color-theme-initialize)
       (color-theme-robin-hood)))
)

(provide 'init-microsoft-os)
