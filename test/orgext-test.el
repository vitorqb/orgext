;;; orgext-test.el --- Tests for orgext

(ert-deftest test-me ()
  (should (equal 1 1)))

(ert-deftest test-orgext-copy-block-from-above ()

  ;; Case - without anything raises error
  (-let [content (s-join "\n" '("This is a file"
                                ""
                                "In this file there is no org block."))]
    (with-temp-buffer
      (insert content)
      (goto-char (point-max))
      (should-error
       (orgext-copy-block-from-above))))
  
  ;; Case - with a block above
  (-let* ((org-block-content (s-join "\n" '("#+begin_example"
                                            "SOMETHING INSIDE THE BLOCK"
                                            "#+end_example"
                                            )))
          (content (s-join "\n" `("Something here"
                                  ,org-block-content
                                  "Something else here"
                                  "\n"))))
    (with-temp-buffer
      (insert content)
      (goto-char (point-max))
      ;; We should be in the last line with an \n
      (should (string-equal (thing-at-point 'line) "\n"))
      ;; We call the function
      (orgext-copy-block-from-above)
      ;; And we should see the block ahead of us
      (should (string-equal (buffer-substring-no-properties (point) (point-max))
                            (concat org-block-content "\n"))))))

;;; orgext-test.el ends here
