(let ((personal-settings "~/.emacs.d/lisp/local-conf-body.el"))
 (when (file-exists-p personal-settings)
   (load-file personal-settings))
)

(setq org-default-notes-file (concat org-directory "/remember.org"))
(setq org-agenda-files (list (concat org-directory "/planning.org")
			     (concat org-directory "/tracking.org")
			     (concat org-directory "/remember.org")))

(provide 'local-conf-tpl)

;;----------------- Reference for Per Computer Customization------------------------------
;;--- Windows ---
;; (add-to-list 'exec-path "c:/tools/msys64/usr/bin")
;; (setenv "PATH" (concat  "c:/tools/msys64/usr/bin;" (getenv "PATH")))

;; No need if fd.exe installed
;;(setq find-program "c:\\Users\\i348151\\scoop\\shims\\find.exe")
;;(setq find-ls-option '("-print0 | xargs -0 ls -alhd" . ""))

;;  (setq org-agenda-files '("c:/workspace/orgagenda/agenda.org" "c:/workspace/orgagenda/remember_notes.org"))
;;  (setq org-default-notes-file "c:/workspace/orgagenda/remember_notes.org")

;;  (setq org-directory "~/workspace/orgfiles")
;;  (setq org-default-notes-file (concat org-directory "remember.org"))

;; (setq org-roam-directory "~/workspace/github/knowledge-n-tools/notes/")
