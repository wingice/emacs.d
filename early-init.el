;;; early-init.el --- Early initialization  -*- lexical-binding: t; -*-

;; Runs before init.el, before package and UI initialization.

;; --- Performance: high GC threshold during init, restore after ---
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold 16000000)))

;; --- Suppress file-name-handler-alist during startup (restore after) ---
;; Every file operation checks this list via regex; nil = faster init.
(defvar my--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       my--file-name-handler-alist)))))

;; --- Skip case-insensitive second pass over auto-mode-alist ---
(setq auto-mode-case-fold nil)

;; --- Disable UI elements before frame draws (prevents flash) ---
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; --- Prevent expensive frame resizing when loading fonts/UI ---
(setq frame-inhibit-implied-resize t)

;; --- Package initialization is handled manually in init.el ---
(setq package-enable-at-startup nil)

;; --- Native compilation settings ---
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent)
  (setq native-comp-speed 2))

(provide 'early-init)
;;; early-init.el ends here
