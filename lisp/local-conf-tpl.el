(let ((personal-settings "~/.emacs.d/lisp/local-conf-body.el"))
 (when (file-exists-p personal-settings)
   (load-file personal-settings))
)

(setq org-default-notes-file (concat org-directory "/remember.org"))
(setq org-agenda-files (list (concat org-directory "/planning.org")
			     (concat org-directory "/tracking2024.org")
			     (concat org-directory "/tracking2025.org")
			     (mobile-gtd-tmp-file)
			     (concat org-directory "/remember.org")))

(setq org-roam-index-file (concat org-roam-directory "/NoteIndex.org"))

(defun li-general-note-file ()
    (interactive)
    (find-file (concat org-roam-directory "/general/general_reference_note_2022-20220627092617.org")))
(defun li-capture-file ()
  (interactive)
  (find-file (concat org-directory "/remember.org")))

(global-set-key [f12] 'recompile)
(global-set-key (kbd"S-<f2>") 'li-capture-file)


(provide 'local-conf-tpl)

;;----------------- Reference for Per Computer Customization------------------------------
;;--- Windows ---
;; (add-to-list 'exec-path "c:/tools/msys64/usr/bin")
;; (setenv "PATH" (concat  "c:/tools/msys64/usr/bin;" (getenv "PATH")))

;; (setq org-directory "~/workspace/orgfiles")
;; (setq org-roam-directory "~/workspace/github/knowledge-n-tools/notes/")

;; (setenv "P4CLIENT" "pcode3230")
;; (setenv "P4PORT" "perforce3230:3230")
