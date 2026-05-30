;;; local-conf-body.el --- Per-machine config  -*- lexical-binding: t; -*-

;;----------------- Reference for Per Computer Customization------------------------------

;;--- Windows ---
(when (eq system-type 'windows-nt)
  (setq find-program (home-path "scoop/shims/find.exe"))
  (add-to-list 'exec-path "c:/tools/msys64/usr/bin")
  (add-to-list 'exec-path (home-path "scoop/apps/mpv/current"))
  (setenv "PATH" (concat "C:/tools/tex/tex/texmf-win64/bin;" (getenv "PATH")))
  (setq org-directory (home-path "OneDrive - SAP SE/orgfiles"))
  (setq org-roam-directory "c:/workspace/github/knowledge-n-tools/notes/"))

(when (or (string= (system-name) "w-PF44DJL0")          ;;<--T15g2
          (string= (system-name) "W-8CC3372YJW"))        ;;<--HPG800
  ;;(set-frame-font "Fira Code-12")
  )

(when (string= (system-name) "w-PF44DJL0")              ;;<--T15g2
  ;;  (set-frame-font "Fira Code-11")
  ;;  (text-scale-decrease 1)
  )

;;
;; Create a desktop shortcut to trigger stretchly long break
;; Target: ~/scoop/shims/stretchly.exe long

;;--- Linux/MacOS ---
(when (or (eq system-type 'darwin)
          (eq system-type 'gnu/linux))
  (setq org-roam-directory "~/workspace/github/knowledge-n-tools/notes/")
  (setq org-directory "~/workspace/orgfiles"))
