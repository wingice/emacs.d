(when (eq system-type 'windows-nt)
  (set-language-environment 'chinese-gbk)
  (prefer-coding-system 'utf-8-auto)
  (set-default-font "Courier SWA 14")

  (set-fontset-font (frame-parameter nil 'font)    ;;设置中文字体
		    'han '("Microsoft YaHei" . "unicode-bmp"))
  
  (setq system-time-locale "C")

  (when window-system (set-frame-size (selected-frame) 132 36))

  ;;------------org-mode and appt settings
  (setq org-agenda-files '("c:/workspace/orgagenda/agenda.org" "c:/workspace/orgagenda/remember_notes.org"))

  (setq org-default-notes-file "c:/workspace/orgagenda/remember_notes.org")
  (setq default-directory "C:/workspace/working/")

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
  
;;  (require 'color-theme)
;;  (eval-after-load "color-theme"
;;    '(progn
;;       (color-theme-initialize)
;;       (color-theme-robin-hood)))
)

(provide 'init-microsoft-os)
