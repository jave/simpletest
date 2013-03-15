;; simple math tutorial test for kids
;; joakim verona
;; gplv3

(require 'widget)

(defvar mtn-exercise-answer)
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
    (setq mtn-exercise-answer b)
        (mtn-format-exercise   c "/" a )))


(defun mtn-make-exercise-* ()
  (let ( (a (random 11))
         (b (random 11)))
    (setq mtn-exercise-answer  (*  a b))
    (mtn-format-exercise  a "*" b )))

(defun mtn-make-exercise-+ ()
  (let ( (a (random 21))
         (b (random 21)))
    (setq mtn-exercise-answer  (+  a b))
    (mtn-format-exercise  a "+" b )))

(defun mtn-make-exercise-- ()
  (let* ( (a (random 21))
         (b (random (+ a 1))))
    (setq mtn-exercise-answer  (-  a b))
    (mtn-format-exercise  a "-" b )))

;;this was excessively clever:
;; (defun mtn-make-exercise-nodiv ()
;;   (let ( (a (random 11))
;;          (b (random 11))
;;          (op (nth (random 3) '((+ "+") (* "*") (- "-")))))
;;     (setq mtn-exercise-answer (apply (car op) (list  a b)))
;;     (mtn-format-exercise  a (cadr  op) b )))


(defun mtn-insert-exercise ()
  (widget-insert
   (propertize  (format "%02d: " mtn-current-exercise )  'face font-lock-keyword-face)
   (propertize     (mtn-make-exercise)  'face font-lock-string-face)
   " "
   )
  (let ((w (widget-create 'editable-field
                                          :size 5
                                          ;;                 :format "val: %v " ; Text after the field!
                                          ""

                                          
                                          )))
    (widget-put w
                :action 'mtn-correct-reply)
    (widget-put  w
                           :answer mtn-exercise-answer))
  (widget-insert " ")
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
  (let ((ok (= (widget-get (widget-at) :answer) (string-to-number (widget-value (widget-at))))))
    (move-end-of-line 1)
    ;;(indent-to-column 30)
    (widget-insert 
                   (if  ok
                       (propertize      " R \n"  'face font-lock-builtin-face)
                     (propertize      " F \n"  'face font-lock-keyword-face) )
                   )
      (widget-setup);;
  (setq mtn-current-exercise (+ mtn-current-exercise 1))
  (mtn-insert-exercise)))

(define-derived-mode mtn-mode text-mode "simple math test mode")

(define-key mtn-mode-map
  "\r" 'mtn-correct-reply)
