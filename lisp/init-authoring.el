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
;;(setq org-clock-into-drawer 1)
(setq org-clock-clocktable-default-properties '(:maxlevel 5 :scope file :block today :indent t :link t))
;;(setq org-clocktable-defaults '(:maxlevel 5 :scope file :block today :indent t ))

;; appt and reminder
(require 'appt)
(setq org-agenda-include-diary t)
(setq appt-time-msg-list nil)
(setq org-startup-indented t)

;; the appointment notification facility
(setq
  appt-message-warning-time 3
  appt-display-mode-line t ;; show in the modeline
)

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
         ((agenda "")
          (tags-todo "NA"                                         ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
		 (org-deadline-warning-days 5)
                 (org-agenda-overriding-header "TODO & NA:")))

	  (todo "TODO" ((org-agenda-overriding-header "Todo:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (todo "HOLD" ((org-agenda-overriding-header "Hold and Waiting:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (todo "DELEGATED" ((org-agenda-overriding-header "Delegated:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (tags "NA" ((org-agenda-overriding-header "Next Action:")))
	  ))
        ))

(setq org-todo-keywords
  '((sequence "TODO" "HOLD" "|" "DONE" "DELEGATED")))

(setq org-capture-templates
 '(("t" "Todo" entry (file+headline "" "Tasks")
        "* TODO %?\n  %i\n  %a")
   ("b" "Bookmark" entry (file+datetree "")
        "* %?\nEntered on %U\n  %i\n  %a")))



(provide 'init-authoring)


