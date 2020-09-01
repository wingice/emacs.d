﻿(when (eq system-type 'windows-nt)
  (set-language-environment 'chinese-gbk)
  (prefer-coding-system 'utf-8-auto)
;;  (set-frame-font "Courier SWA 14")
  (set-frame-font "Consolas-10")

  (set-fontset-font (frame-parameter nil 'font)    ;;设置中文字体
		    'han '("Microsoft YaHei" . "unicode-bmp"))
  
  (setq system-time-locale "C")

  (when window-system (set-frame-size (selected-frame) 132 36))

  ;;  (setq pdf-info-epdfinfo-program "C:/Tools/msys64/mingw64/bin/epdfinfo.exe")

  (defun powershell-toast(msg)    ;; Install-Module -Name BurntToast   [@Powershell Administrator mode]
    (interactive)
    (start-process "remind"  nil "powershell.exe" "-Command" "New-BurntToastNotification" (concat "-Text GTD," "\"" msg "\"")))
   
  (defun toast-test()
    (interactive)
    (powershell-appt 1 2 "Hello World!"))

  (defun powershell-appt(min-to-app new-time appt-msg)
    (interactive)
    (select-frame-set-input-focus (selected-frame))
    (powershell-toast appt-msg))


  (defun popup-notification(title msg)
    (interactive)
    (powershell-toast msg))
  )

(provide 'init-microsoft-os)
