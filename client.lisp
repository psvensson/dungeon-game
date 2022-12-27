(in-package #:dungeon)

(defvar *client* nil)
(defvar *screen* nil)
(defparameter *client-entities* (make-hash-table))
(defparameter *items* ())
(defparameter *participants* ())
(defparameter *client-map*
  (make-array '(10 10) :initial-element 0))
(defparameter *status* "")

(defun on-server-message (msg)
  (handle-server-message (decode-message msg)))

(defun get-client ()
 (unless *client*
   (setf *client*
         (wsd:make-client "ws://localhost:12345/echo"))
   (wsd:start-connection *client*)
   (wsd:on :message *client* #'on-server-message)
   (wsd:on :error *client*
           (lambda (&rest args) (print args))))
  *client*)

(defun send-to-server (msg)
  (get-client)
  (wsd:send *client*
            (json:encode-json-to-string msg)))

(defun close-client () (wsd:close-connection *client*))

(defun start-ui ()
  (with-screen
      (scr :input-echoing nil
           :input-blocking nil
           :input-buffering nil
           :enable-colors t)
    (setf *screen* scr)
    (clear scr)
    (move scr 2 0)
    (format scr "Type wasd to move, q to quit.~%~%")
    (render-map)
    ;;(refresh scr)
    (setf (color-pair scr) '(:blue :black)
          (attributes scr)
          '(:bold))
    (get-client)
    (event-case (scr event)
      (#\q (return-from event-case))
      (#\w (send-to-server (list :move :up)))
      (#\s (send-to-server (list :move :down)))
      (#\a (send-to-server (list :move :left)))
      (#\d (send-to-server (list :move :right))))))

(defun add-client-entity (entity)
  ;;(inspect entity)
  (setf
   (gethash (alexandria:assoc-value entity :id)
            *client-entities*)
   entity))

(defun remove-client-entity (entity)
  (remhash *client-entities* entity))

(defun list-to-plist (l)
  (let
      ((rv  '())
       (rl (reverse l)))
    (dotimes (n (length l))
      (push (pop rl) rv)
      (push (symbol-from-string (pop rl)) rv))
    rv))
