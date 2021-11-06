;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((sh-script-mode . ((sh-shell . bash)))
 (nil . ((eval . (when-let ((name (buffer-file-name)))
                   (when (string-match-p
                           (rx (? ".") "config.sh")
                           name)
                     (setq sh-shell 'bash)))))))
