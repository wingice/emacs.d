;;; early-init.el --- Early initialization  -*- lexical-binding: t; -*-

;; Runs before init.el, before package and UI initialization.

;; --- Performance: high GC threshold during init, restore after ---
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold 16000000)))

;; --- Disable UI elements before frame draws (prevents flash) ---
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; --- Package initialization is handled manually in init.el ---
(setq package-enable-at-startup nil)

;; --- Native compilation settings ---
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent))

(provide 'early-init)
;;; early-init.el ends here
