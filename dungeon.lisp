;;;; dungeon.lisp

(in-package #:dungeon)

;; Testing stuff
(defun test1 ()
  (with-screen (scr :input-echoing nil
                    :input-blocking t
                    :enable-colors t)
               (clear scr)
               (move scr 2 0)
               (format scr "Type chars. Type q to quit.~%~%")
               (refresh scr)
               (setf (color-pair scr) '(:yellow :red)
                     (attributes scr)
                     '(:bold))
               (event-case (scr event)
                           (#\q
                            (return-from event-case))
                           (otherwise (princ event scr)
                                      (refresh scr)))))
