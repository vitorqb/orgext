;;; orgext.el --- Vitor's utilities -*- lexical-binding: t -*-

;; Copyright (C) 2019 Vitor Quintanilha Barbosa

;; Author: Vitor <vitorqb@gmail.com>
;; Version: 0.0.1
;; Maintainer: Vitor <vitorqb@gmail.com>
;; Created: 2019-06-18
;; Keywords: elisp org-mode
;; Homepage: https://github.com/vitorqb/orgext/blob/development/

;; This file is not part of GNU Emacs.
     
;; Do whatever you want. No warranties.

;;; code

;; Prepare error codes
(defun orgext-mark-block ()
  "Marks the context of the block at point"
  (interactive)
  (-if-let (el (org-element-context))
      (when (-any? (-partial #'equal (car el))
                   '(example-block src-block verse-block quote-block comment-block))
        (-let* ((block-begin (plist-get (car (cdr el)) :begin))
                (block-end (plist-get (car (cdr el)) :end))
                (post-blank (plist-get (car (cdr el)) :post-blank))
                ;; we want 1 line after begin and 2 before end
                (begin (save-excursion
                         (goto-char block-begin)
                         (next-line)
                         (beginning-of-line)
                         (point)))
                (end (save-excursion
                       (goto-char block-end)
                       (previous-line
                        (+ 1 post-blank (s-count-matches "\n" (thing-at-point 'line t))))
                       (when (string-match "^\\#\\+end_" (thing-at-point 'line t))
                         (previous-line))
                       (if (< (point) begin)
                           (goto-char begin))
                       (end-of-line)
                       (+ 1 (point)))))
          (goto-char begin)
          (set-mark end)))))

(defun orgext-copy-block-from-above ()
  (interactive)
  (-let [point-at-entry (point)]
    (save-excursion
      (org-previous-block 1)
      (orgext-mark-block)
      ;; We need to expand 1 line in each direction to capture the whole block
      (forward-line -1)
      (set-mark (save-excursion
                  (goto-char (region-end))
                  (forward-line)
                  (point)))
      (copy-region-as-kill nil nil t))
    (yank)
    (goto-char point-at-entry)))

(provide 'orgext)
;;; orgext.el ends here
