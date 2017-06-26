(when (eq system-type 'windows-nt)
  (set-language-environment 'chinese-gbk)
  (prefer-coding-system 'utf-8-auto)
  (set-default-font "Courier SWA 14")

  (set-fontset-font (frame-parameter nil 'font)    ;;设置中文字体
		    'han '("Microsoft YaHei" . "unicode-bmp"))
  
  (setq system-time-locale "C")

  (when window-system (set-frame-size (selected-frame) 132 36))

  (setq pdf-info-epdfinfo-program "C:/Tools/msys64/mingw64/bin/epdfinfo.exe")

  
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



  (setq org-timer-default-timer 25)
  ;;Modify the org-clock-in so that a timer is started with the default
  ;;value except if a timer is already started :
  (add-hook 'org-clock-in-hook '(lambda ()
				  (if (not org-timer-current-timer)
				      (org-timer-set-timer '(16)))))
  (add-hook 'org-clock-out-hook '(lambda ()
				   (setq org-mode-line-string nil)
				   (org-timer-cancel-timer)
				   ))

  (add-hook 'org-timer-done-hook '(lambda()
				    (growl-popup "Congratulations! You Finished a Pomodoro Task!")))

  (defun my-after-load-org ()
    (add-to-list 'org-modules 'org-timer))
  (eval-after-load "org" '(my-after-load-org))

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

  ;; update appt each time agenda opened
  (add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)
  (setq appt-disp-window-function (function growl-appt))


  (add-hook 'org-mode-hook
	    (lambda()
	      (add-hook 'before-save-hook 'org-agenda-to-appt t t)
	      ))

  ;; Resume clocking tasks when emacs is restarted
  (org-clock-persistence-insinuate)
  ;; Do not prompt to resume an active clock
  (setq org-clock-persist-query-resume nil)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)

  
  )

(provide 'init-microsoft-os)
