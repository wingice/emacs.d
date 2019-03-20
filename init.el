;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-carbon-emacs* (eq window-system 'mac))
(defconst *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))


(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

(setq package-enable-at-startup nil)
(package-initialize)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(require 'init-site-lisp)
(require 'init-ido)
(require 'init-display)
(require 'init-auto-complete)
(require 'init-rails)
(require 'init-misc)
(require 'init-yasnippet)
(require 'init-linux)
(require 'init-osx)
(require 'init-authoring)
(require 'init-locales)
(require 'init-microsoft-os)
(require 'init-cpp)
(require 'local-conf-tpl)

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-selection ((t (:background "DarkGreen"))))
 '(org-date ((t (:foreground "dim gray" :underline t))))
 '(org-special-keyword ((t (:inherit font-lock-keyword-face :foreground "dim gray"))))
 '(outline-3 ((t (:foreground "dark green"))))
 '(outline-4 ((t (:foreground "black")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (nimbus-theme darcula-theme helm-projectile tide json-mode web-mode projectile yasnippet flymake-ruby rinari company flx-ido))))
