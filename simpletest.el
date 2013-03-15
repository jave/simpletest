;; simple math tutorial test for kids
;; joakim verona
;; gplv3

(require 'widget)

;;(defvar mtn-exercise-answer)
(defvar mtn-current-exercise)


(defun mtn-format-exercise (a opstr b)
  (format "%10s = " (format "%d %s %d " a opstr b ))  )

(defun mtn-make-exercise ()
  (let ( (x (random 4)))
    (cond 
     ((= x 0) (mtn-make-exercise-/))
     ((= x 1) (mtn-make-exercise-+))
     ((= x 2) (mtn-make-exercise--))
     ((= x 3) (mtn-make-exercise-*))
     )))

(defun mtn-make-exercise-/ ()
  (let* ( (a (+ 1 (random 10)))
          (b (random 11))
          (c ( * a b)))
    (list b (mtn-format-exercise   c "/" a ))))


(defun mtn-make-exercise-* ()
  (let ( (a (random 11))
         (b (random 11)))
    (list (*  a b)  (mtn-format-exercise  a "*" b ))))

(defun mtn-make-exercise-+ ()
  (let ( (a (random 21))
         (b (random 21)))
    (list (+  a b) (mtn-format-exercise  a "+" b ))))

(defun mtn-make-exercise-- ()
  (let* ( (a (random 21))
          (b (random (+ a 1))))
    (list (-  a b) (mtn-format-exercise  a "-" b ))))


(defun mtn-insert-exercise ()
  (let ((ex (mtn-make-exercise)))
    (widget-insert
     (propertize  (format "%02d: " mtn-current-exercise )  'face font-lock-keyword-face)
     (propertize     (cadr ex)  'face font-lock-string-face)
     " "
     )
    (let ((w (widget-create 'editable-field
                            :size 5
                            ""
                            )))
      (widget-put w :action 'mtn-correct-reply)
      (widget-put w :exercise-number mtn-current-exercise)
      (widget-put w :answer (car ex))))
  (widget-insert "    ")
  (widget-setup);;
  (widget-backward 1)
  )

(defun mtn-field-edited (widget &rest ignore)
  (message "field: %s" widget))

(defun mtn-start-exercise ()
  (interactive)
  (switch-to-buffer (get-buffer-create "*simpletest*"))
  (mtn-mode)
  (let ( (inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (use-local-map widget-keymap)
  (insert "\n");;this is a workaround for thing-at-point
  (goto-char (point-min))
  (setq mtn-current-exercise 1)
  (mtn-insert-exercise)
  )

(defun mtn-correct-reply (&rest args)
  (interactive)
  (let ((ok (= (widget-get (widget-at) :answer) (string-to-number (widget-value (widget-at)))))
        (exercise-number (widget-get (widget-at) :exercise-number)))
    (move-end-of-line 1)

    (let ((inhibit-read-only t)
	(inhibit-modification-hooks t))
    (delete-backward-char 3))
  
    (widget-insert 
     (if  ok
         (propertize      " R "  'face font-lock-builtin-face)
       (propertize      " F "  'face font-lock-keyword-face) )
     )
    ;;(widget-setup);;
    (if (= exercise-number mtn-current-exercise)
        (progn 
          (setq mtn-current-exercise (+ mtn-current-exercise 1))
          (widget-insert "\n")
          (mtn-insert-exercise))
      (widget-forward 1))))

(define-derived-mode mtn-mode text-mode "simple math test mode")

(define-key mtn-mode-map
  "\r" 'mtn-correct-reply)
(define-key mtn-mode-map
  " " 'mtn-correct-reply)

;;;;;;;;;;;;;;;;;;;
;;stuff for generating pen and paper exercises

(defun mtn-paper-gen ()
  (interactive)
  (erase-buffer)
(insert "\\documentclass{amsart}
\\begin{document}
\\setlength{\\tabcolsep}{25pt}
\\begin{tabular}{rr|llll}
")  
  (loop for i from 1 to 30 do
        (let ((ex (mtn-make-exercise)))
          (insert (cadr ex))
          (insert "&          &")
          (insert (number-to-string (car ex)))
          (insert "\\\\\n")

          ))
(insert "\\end{tabular}
\\end{document}
")

  )
