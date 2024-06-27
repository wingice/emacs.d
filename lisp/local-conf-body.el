;;----------------- Reference for Per Computer Customization------------------------------
;;--- Windows ---
(when (eq system-type 'windows-nt)
  (add-to-list 'exec-path "c:/tools/msys64/usr/bin")
  (setenv "PATH" (concat  "c:/tools/msys64/usr/bin;" (getenv "PATH")))

  (setq org-directory "c:/workspace/orgfiles")
  (setq org-roam-directory "c:/workspace/github/knowledge-n-tools/notes/")

  (setenv "P4CLIENT" "pcode3230")
  (setenv "P4PORT" "perforce3230:3230")
)


(when (or (string= (system-name) "w-PF44DJL0"  )         ;;<--T15g2
	  (string= (system-name) "W-8CC3372YJW"))        ;;<--HPG800
  ;;(set-frame-font "Fira Code-12")
)

(when (string= (system-name) "w-PF44DJL0")         ;;<--T15g2
  ;;  (set-frame-font "Fira Code-11")
  ;;  (text-scale-decrease 1)
)


;;--- Linux/MacOS ---
