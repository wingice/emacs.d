;;; init-display.el --- Display and UI settings  -*- lexical-binding: t; -*-
;;  ---  Font, Display and General Setttings   ---

(column-number-mode t)
(setq sgml-basic-offset 4)

;;disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq-default truncate-lines t)
(global-set-key [f5] 'revert-buffer)
;; Scroll bars disabled in early-init.el via default-frame-alist
(setq auto-revert-interval 0.5)

(setq Buffer-menu-name-width 30)
(setq Buffer-menu-mode-width 12)

(setq split-width-threshold (- (window-width) 10))
(setq split-height-threshold 36)  ;;https://stackoverflow.com/questions/23207958/how-to-prevent-emacs-dired-from-splitting-frame-into-more-than-two-windows

(defun count-visible-buffers (&optional frame)
  "Count how many buffers are currently being shown. Defaults to selected frame."
  (length (window-list frame)))

(defun do-not-split-more-than-two-windows (window &optional horizontal)
  (if (and horizontal (> (count-visible-buffers) 1))
      nil
    t))

(advice-add 'window-splittable-p :before-while #'do-not-split-more-than-two-windows)


(use-package nimbus-theme
  :ensure t
  :config
  (load-theme 'nimbus t))

(add-hook 'Buffer-menu-mode-hook #'hl-line-mode)
(add-hook 'shell-mode-hook #'compilation-shell-minor-mode)
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

(defun remove-shell-wrong-sequences (string)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\[0G\\|\\]2;" nil t)
      (replace-match "\n"))
    (goto-char (point-min))
    ))

(add-hook 'comint-output-filter-functions #'remove-shell-wrong-sequences)

(defun toggle-fold ()
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))

(global-set-key (kbd "C-M-=") 'hs-toggle-hiding)
(add-hook 'prog-mode-hook #'hs-minor-mode)

(setq ediff-diff-options "-w")
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; (when (require 'so-long nil :noerror)
;;    (global-so-long-mode 1)
;;    (add-hook 'compilation-mode-hook 'so-long-minor-mode)
;;    )

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point-max)))
(add-hook 'compilation-filter-hook #'colorize-compilation-buffer)

(setq text-scale-mode-step 1.1)

(pixel-scroll-precision-mode 1)
(which-key-mode 1)

;; --- Scrolling & redisplay performance ---
;; Skip fontification during rapid input (smoother typing in large files)
(setq redisplay-skip-fontification-on-input t)
;; Faster scrolling over unfontified regions (complements pixel-scroll)
(setq fast-but-imprecise-scrolling t)
;; Reduce UI update frequency (default 0.5s → 1.0s when idle)
(setq idle-update-delay 1.0)

;; --- Emacs 30: Enhanced paren matching ---
;; When opening paren is offscreen, show context in echo area
(setopt show-paren-context-when-offscreen 'overlay
        blink-matching-paren-highlight-offscreen t)

;; --- Outline folding for ASCII-tree profiler logs (+-- / \-- nodes) ---

(defun my-tree-log-outline ()
  "Fold indented `+--'/`\\--' profiler tree logs with `outline-minor-mode'.
Outline depth is taken from each node marker's column, so no fixed
timestamp/prefix width is assumed: the shallowest marker becomes level 1
and every 4-column indent step (\"|   \" or \"    \") is one level deeper."
  (interactive)
  (let* ((marker "[+\\]-- ")         ; a tree node: "+-- " or "\-- "
         (marker-width 4)            ; characters in a marker
         (indent-width 4)            ; columns per outline level
         (column (lambda ()          ; 0-based column of the marker just matched
                   (- (match-end 0) marker-width (line-beginning-position))))
         (base (save-excursion       ; column of the shallowest marker in buffer
                 (goto-char (point-min))
                 (let ((min most-positive-fixnum))
                   (while (re-search-forward marker nil t)
                     (setq min (min min (funcall column))))
                   (if (= min most-positive-fixnum) 0 min)))))
    (setq-local outline-regexp (concat "^.*? " marker)
                outline-level (lambda ()
                                (1+ (/ (- (funcall column) base) indent-width)))))
  (outline-minor-mode 1))

;; Org-style folding for any `outline-minor-mode' buffer (incl. tree logs):
;; C-TAB cycles the node under point, S-TAB cycles the whole buffer.
(use-package bicycle
  :ensure t
  :after outline
  :bind (:map outline-minor-mode-map
              ([C-tab]   . bicycle-cycle)
              ([backtab] . bicycle-cycle-global)))

(provide 'init-display)
