;;; ii-utils.el --- helper fns for ii -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Zach Mandeville ii
;;
;; Author: Zach Mandeville <https://github.com/zachmandeville>
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
"To be run inside a git repo: return absolute path combining repo root and given PATH."
  (let ((repo-root (s-trim-right (shell-command-to-string "git rev-parse --show-toplevel"))))
  (concat repo-root"/"path)))

;;;;
;; SSH Tools
;;;;
(defun ii/ssh-find-agent ()
"Look for a running SSH agent on host machine, and set it as SSH_AUTH_SOCK.

This is useful for pushing changes to git repos using your ssh
key, or for tramping in an org file to a remote machine. It assumes you've added
an ssh-agent and, if on a remote machine, forwarded it to that machine.

For more info, see: https://www.ssh.com/ssh/agent

This function is INTERACTIVE."
  (interactive)
  (setenv "SSH_AUTH_SOCK" (shell-command-to-string "find /tmp /run/host/tmp/ \
        -type s -regex '.*/ssh-.*/agent..*$' -printf '%T@ %p\n' 2> /dev/null \
        | sort --numeric-sort | tail -n 1 | awk '{print $2}' | tr -d '\n'"))
  (message (getenv "SSH_AUTH_SOCK")))

;;;;
;; Stephen's weekly time tracker
;;;;

(defun ii/iso-week-to-time (year week day)
"Convert iso YEAR WEEK DAY to include time."
  (pcase-let ((`(,m ,d ,y)
               (calendar-gregorian-from-absolute
                (calendar-iso-to-absolute (list week day year)))))
    (encode-time 0 0 0 d m y)))

(define-skeleton ii/timesheet-skel
  "Prompt the week and year before generating ii timesheet for the user."
  ""
  (text-mode)
  > "#+TITLE: Timesheet: Week " (setq v1 (skeleton-read "Timesheet Week? "))
  ", " (setq v2 (format-time-string "%Y"))
  " (" (getenv "USER") ")" \n
  > "#+AUTHOR: " (getenv "USER") \n
  > " " \n
  > "Please refer to the instructions in ii-timesheet.org as required." \n
  > " " \n
  > "* Week Summary" \n
  > " " _ \n
  > "#+BEGIN: clocktable :scope file :block " (message v2) "-W" (message v1) " :maxlevel 2 :emphasise t :tags t :formula %" \n
  > "#+END" \n
  > " " \n

  > "* " (format-time-string "%B %e, %Y" (ii/iso-week-to-time (string-to-number v2) (string-to-number v1) 1)) \n
  > "** Task X" \n
  > "* " (format-time-string "%B %e, %Y" (ii/iso-week-to-time (string-to-number v2) (string-to-number v1) 2)) \n
  > "** Task X" \n
  > "* " (format-time-string "%B %e, %Y" (ii/iso-week-to-time (string-to-number v2) (string-to-number v1) 3)) \n
  > "** Task X" \n
  > "* " (format-time-string "%B %e, %Y" (ii/iso-week-to-time (string-to-number v2) (string-to-number v1) 4)) \n
  > "** Task X" \n
  > "* " (format-time-string "%B %e, %Y" (ii/iso-week-to-time (string-to-number v2) (string-to-number v1) 5)) \n
  > "** Task X" \n
  > " " \n
  (org-mode)
  (save-buffer))

(defun ii/timesheet ()
"Create a timesheet buffer and insert skel as defined in ii-timesheet-skel.
This function is INTERACTIVE."
  (interactive)
  (require 'cal-iso)
  (switch-to-buffer (get-buffer-create "*ii-timesheet*"))
  (ii/timesheet-skel))


(provide 'ii-utils)
;;; ii-utils.el ends here
