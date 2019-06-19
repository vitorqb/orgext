;;; orgext-test.el --- Tests for orgext
(ert-deftest test-orgext-copy-block-from-above ()

  ;; Case - without anything raises error
  (orgext--in-buffer-with-content
      '("This is a file"
        ""
        "In this file there is no org block.")
    (goto-char (point-max))
    (should-error (orgext-copy-block-from-above)))
  
  ;; Case - with a block above
  (-let [org-block-content (s-join "\n" '("#+begin_example"
                                          "SOMETHING INSIDE THE BLOCK"
                                          "#+end_example"))]
    (orgext--in-buffer-with-content
        `("Something here"
          ,org-block-content
          "Something else here"
          "\n")
      (goto-char (point-max))
      ;; We should be in the last line with an \n
      (should (string-equal (thing-at-point 'line) "\n"))
      ;; We call the function
      (orgext-copy-block-from-above)
      ;; And we should see the block ahead of us
      (should (string-equal (buffer-substring-no-properties (point) (point-max))
                            (concat org-block-content "\n"))))))

(ert-deftest test-orgexp-mark-block ()

  ;; Case - when you are not in a block
  (orgext--in-buffer-with-content
      '("some text"
        "but no org block"
        "\n"
        "foo bar")
    (goto-char (point-max))
    (forward-line -2)
    (should-error (orgext-mark-block)))

  ;; Case - when you are at a block
  (-let* ((block-contents "Some\nThings\nwith space\n here!\n\n")
          (the-block (concat  "#+begin_example\n" block-contents "#+end_example")))
    (orgext--in-buffer-with-content
        `("some text"
          "and then a block:"
          ,the-block
          "Foo Bar\n"
          "Baz")
      (goto-char (point-max))
      (forward-line -3)
      (orgext-mark-block)
      (should (string-equal (buffer-substring (region-beginning) (region-end))
                            block-contents)))))

;;; orgext-test.el ends here
