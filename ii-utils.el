;;; ii-utils.el --- helper fns for ii -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Zach Mandeville ii
;;
;; Author: Zach Mandeville <https://github.com/workzach>
;; Maintainer: Zach Mandeville <zz@ii.coop>
;; Created: May 19, 2021
;; Modified: May 19, 2021
;; Version: 1
;; Keywords: productivity, convenience, helpers
;; Homepage: https://github.com/ii/ii-utils
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; This package provides some shared functions used by the ii team,
;; conveniently held in one place.
;;
;;
;;; Code:

(defun ii/workdir+ (path)
"To be run inside a git repo.
Returns absolute path combining repo root and given PATH"
  (let ((repo-root (s-trim-right (shell-command-to-string "git rev-parse --show-toplevel"))))
  (concat repo-root"/"path)))


(provide 'ii-utils)
;;; ii-utils.el ends here
