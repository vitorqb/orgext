;;; test-helper.el --- Helpers for orgext-test.el
(require 'org)
(require 'dash)
(require 'dash-functional)
(require 's)
(require 'orgext)

(defmacro orgext--in-buffer-with-content (lst-of-lines &rest body)
  "Evaluates body inside a `with-temp-buffer` after inserting `lst-of-lines`.
`lst-of-lines` must be a list of strings, which will be inserted into the buffer."
  (declare (indent 1))
  `(-let [content (s-join "\n" ,lst-of-lines)]
     (with-temp-buffer
       (insert content)
       ,@body)))

;;; test-helper.el ends here
