;;----------------- Reference for Per Computer Customization------------------------------
;;--- Windows ---
(when (string= (system-name) "w-PF44DJL0")     ;;T15G2
  (set-frame-font "Fira Code-12")

  (add-to-list 'exec-path "c:/tools/msys64/usr/bin")
  (setenv "PATH" (concat  "c:/tools/msys64/usr/bin;" (getenv "PATH")))

  (setq org-directory "c:/workspace/orgfiles")
  (setq org-roam-directory "c:/workspace/github/knowledge-n-tools/notes/")

  (setenv "P4CLIENT" "pcode3230")
  (setenv "P4PORT" "perforce3230:3230")
  )
