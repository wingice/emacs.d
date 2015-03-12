;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(add-hook 'markdown-mode-hook (lambda () (visual-line-mode)))

;; OrgMode
(define-key global-map "\C-cr" 'org-remember)
(add-to-list 'auto-mode-alist '("\\.\\(org\\ |org_archive\\|txt\\)$" . org-mode))
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)

(add-hook 'org-mode-hook
	  (lambda()
	    (add-hook 'before-save-hook 'org-agenda-to-appt t t)
	    ))
(setq org-clock-into-drawer 1)
(setq org-agenda-clockreport-parameter-plist
      (quote(:maxlevel 5 :scope file :block today)))
(setq org-clock-clocktable-default-properties '(:maxlevel 4 :scope file))

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

(defun my-org-clocktable-indent-string (level)
  (if (= level 1)
      ""
    (let ((str "\\"))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "___")))
      (concat str "_ "))))

(advice-add 'org-clocktable-indent-string :override #'my-org-clocktable-indent-string)


(setq org-agenda-custom-commands
      '(("d" "Daily Planner"
         ((agenda "" ((org-agenda-ndays 7)                      ;; overview of appointments
                      (org-agenda-repeating-timestamp-show-all t)
                      (org-agenda-entry-types '(:timestamp :sexp))
	              (org-agenda-overriding-header "[Weekly Tasks:]")))

          (todo "TODO"                                          ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
                 (org-agenda-overriding-header "Next Actions:")))

	  (todo "TODO" ((org-agenda-overriding-header "All Todos:")))
	  (tags "NA" ((org-agenda-overriding-header "All Next Actions:")))

	  (agenda "" ((org-agenda-ndays 1)                      ;; daily agenda
                      (org-deadline-warning-days 7)             ;; 7 day advanced warning for deadlines
                      (org-agenda-todo-keyword-format "[ ]")
                      (org-agenda-scheduled-leaders '("" ""))
                      (org-agenda-prefix-format "%t%s")
	              (org-agenda-overriding-header "Daily Tasks:")))


	  ))
        ))

(provide 'init-authoring)
