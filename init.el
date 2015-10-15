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
(package-initialize)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(require 'init-site-lisp)
(require 'init-ido)
(require 'init-windows)
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

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))
