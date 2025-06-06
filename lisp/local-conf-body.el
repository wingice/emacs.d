;;----------------- Reference for Per Computer Customization------------------------------
;;--- Windows ---
(when (eq system-type 'windows-nt)
  (setq find-program "C:\\Users\\i348151\\scoop\\shims\\find.exe")
  (add-to-list 'exec-path "c:/tools/msys64/usr/bin")
  (setenv "PATH" (concat  "c:/tools/msys64/usr/bin;" (getenv "PATH")))

  (setq org-directory "C:\\Users\\I348151\\OneDrive - SAP SE\\orgfiles")
  (setq org-roam-directory "c:/workspace/github/knowledge-n-tools/notes/")

  (setenv "P4CLIENT" "pcode3230")
  (setenv "P4PORT" "perforce3230:3230")
)


(when (or (string= (system-name) "w-PF44DJL0"  )         ;;<--T15g2
	  (string= (system-name) "W-8CC3372YJW"))        ;;<--HPG800
  (setq find-program "C:/tools/msys64/usr/bin/find.exe")
  ;;(set-frame-font "Fira Code-12")
)

(when (string= (system-name) "w-PF44DJL0")         ;;<--T15g2
  ;;  (set-frame-font "Fira Code-11")
  ;;  (text-scale-decrease 1)
  )

;;
;; Create a desktop shortcut to trigger stretchly long break
;; Target: C:\Users\I348151\scoop\shims\stretchly.exe long

;;--- Linux/MacOS ---
