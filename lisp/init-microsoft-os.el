(when (eq system-type 'windows-nt)
  (set-language-environment 'chinese-gbk)
  (prefer-coding-system 'utf-8-auto)
  (set-default-font "Courier SWA 14")

  (set-fontset-font (frame-parameter nil 'font)    ;;设置中文字体
		    'han '("Microsoft YaHei" . "unicode-bmp"))
  
  (setq system-time-locale "C")

  (when window-system (set-frame-size (selected-frame) 132 36))

  ;;  (setq pdf-info-epdfinfo-program "C:/Tools/msys64/mingw64/bin/epdfinfo.exe")
  ;;------------org-mode and appt settings
  (setq org-agenda-files '("c:/workspace/orgagenda/agenda.org" "c:/workspace/orgagenda/remember_notes.org"))
  (setq org-default-notes-file "c:/workspace/orgagenda/remember_notes.org")
  (setq default-directory "C:/workspace/working/")

  (defun growl-popup(msg)
    (interactive)
    (start-process "remind" nil "C:/workspace/working/SmartReminders/SmartReminder/ReminderClient/bin/Debug/ReminderClient.exe" msg))

  (defun growltest()
    (interactive)
    (growl-appt 1 2 "Hello, Test successfully!")
    )

  (defun growl-appt(min-to-app new-time appt-msg)
    (interactive)
    (select-frame-set-input-focus (selected-frame))
    (growl-popup appt-msg)
    )
  )

(provide 'init-microsoft-os)
