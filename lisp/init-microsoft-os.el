;;; init-microsoft-os.el --- Windows specific config  -*- lexical-binding: t; -*-

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
  (set-fontset-font (frame-parameter nil 'font)
		    'han '("Microsoft YaHei" . "unicode-bmp"))
  ;; Single unicode fallback for symbols/emoji/box-drawing
  (set-fontset-font (frame-parameter nil 'font)
		    'unicode '("Segoe UI Symbol" . "unicode-bmp") nil 'append)

  ;; Set locale for time display
  (setq system-time-locale "C")

  ;; Window size configuration
  (when window-system (set-frame-size (selected-frame) 132 36))

  ;;  (setq pdf-info-epdfinfo-program "C:/Tools/msys64/mingw64/bin/epdfinfo.exe")


  (defun stretchly-start()
      (interactive)
    (start-process "Reminder" nil
                   (home-path "scoop/apps/stretchly/current/Stretchly.exe")
                   "long" "-w" "25m"))

  (defun powershell-toast(msg)    ;;Requirement: Install-Module -Name BurntToast   [@Powershell Administrator mode]
    (interactive)
    (start-process "remind"  nil "powershell.exe" "-Command" "New-BurntToastNotification" (concat "-Text GTD," "\"" msg "\"")))

  (defun toast-test()
    (interactive)
    (powershell-appt 1 2 "Hello World!"))

  (add-hook 'org-clock-in-hook #'stretchly-start)

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

   (use-package ghostel
     :bind (("C-x m" . ghostel)
            :map ghostel-semi-char-mode-map
            ("C-s"  . consult-line)
            ("C-k"  . my/ghostel-send-C-k-and-kill)
            ;; I'm used to go up/down the shell history with M-n/p from eshell.
            ;; Simulate this behavior in ghostel by sending C-p and C-n.
            ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
            ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
            :map project-prefix-map
            ("m" . ghostel-project)
            ("M" . ghostel-project-list-buffers))
     :config
     (defun my/ghostel-send-C-k-and-kill ()
       "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
       (interactive)
       (kill-ring-save (point) (line-end-position))
       (ghostel-send-key "k" "ctrl"))

     ;; Windows lacks xterm-ghostty terminfo, use xterm-256color.
     (setq ghostel-term "xterm-256color")
     (setq ghostel-module-directory (concat emacs-dir "packages/BinaryFiles"))

     (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
     (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)
     (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))
)
(provide 'init-microsoft-os)
