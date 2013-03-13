;; simple math tutorial test for kids
;; joakim verona
;; gplv3


(defvar mtn-exercise-answer)
(defvar mtn-current-exercise)


(defun mtn-make-exercise-nodiv ()
  (let ( (a (random 11))
         (b (random 11))
         (op (nth (random 3) '((+ "+") (* "*") (- "-")))))
    (setq mtn-exercise-answer (apply (car op) (list  a b)))
    (format "%d %s %d = " a (cadr  op) b )))

(defun mtn-make-exercise ()
  (let ( (x (random 10)))
    (cond 
     ((= x 0) (mtn-make-exercise-div))
     (t (mtn-make-exercise-nodiv)))))

(defun mtn-make-exercise-div ()
  (let* ( (a (+ 1 (random 10)))
         (b (random 11))
         (c ( * a b)))
    
    (setq mtn-exercise-answer b)
    (format "%d %s %d = " c "/" a )))


(defun mtn-insert-exercise ()
  (insert  (propertize (format "%02d: " mtn-current-exercise) 
                       'font-lock-face '(:foreground "grey")
                       )
           (propertize  (mtn-make-exercise)
                       'font-lock-face '(:foreground "yellow")
                       )))

(defun mtn-start-exercise ()
  (interactive)
  (setq mtn-current-exercise 1)
  (mtn-insert-exercise)
  )

(defun mtn-correct-reply ()
  (interactive)
  (if  (= mtn-exercise-answer (thing-at-point 'number))
      (insert            (propertize " R \n"
                       'font-lock-face '(:foreground "green")))
          (insert            (propertize " F \n"
                       'font-lock-face '(:foreground "red"))))
  (setq mtn-current-exercise (+ mtn-current-exercise 1))
  (mtn-insert-exercise))

(define-derived-mode mtn-mode text-mode "simple math test mode")

(define-key mtn-mode-map
  "\r" 'mtn-correct-reply)
