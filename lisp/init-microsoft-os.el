(when (eq system-type 'windows-nt)
  ;; Enable UTF-8 support for Chinese filenames and content
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (setq default-file-name-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8)
  
  ;; Font configuration
  (set-frame-font "Fira Code Retina-10.5")
  (set-fontset-font (frame-parameter nil 'font)    ;;设置中文字体
		    'han '("Microsoft YaHei" . "unicode-bmp"))

  ;; Set locale for time display
  (setq system-time-locale "C")
  
  ;; Window size configuration
  (when window-system (set-frame-size (selected-frame) 132 36))

  ;;  (setq pdf-info-epdfinfo-program "C:/Tools/msys64/mingw64/bin/epdfinfo.exe")

  (defun stretchly-start()
      (interactive)
    (start-process "Reminder" nil "stretchly" "long" "-w" "25m"))

  (defun powershell-toast(msg)    ;;Requirement: Install-Module -Name BurntToast   [@Powershell Administrator mode]
    (interactive)
    (start-process "remind"  nil "powershell.exe" "-Command" "New-BurntToastNotification" (concat "-Text GTD," "\"" msg "\"")))

  (defun toast-test()
    (interactive)
    (powershell-appt 1 2 "Hello World!"))

  (defun start-screen-timer()
    (interactive)
    (stretchly-start)
  )
  ;;(toast-test)
  ;;(stretchly-start)

  (defun powershell-appt(min-to-app new-time appt-msg)
    (interactive)
    (select-frame-set-input-focus (selected-frame))
    (powershell-toast appt-msg))

  (defun popup-notification(title msg)
    (interactive)
    (powershell-toast msg)
    ;;(stretchly-start)
  )

;;   (setq projectile-enable-caching t)
   (setq default-directory "c:\\workspace")
  )
(provide 'init-microsoft-os)
