(in-package #:dungeon)

(defvar *server-handler* nil)
(defvar *connections* (make-hash-table))

(defun make-connection (con entity)
  (make-instance 'connection
                 :ws-connection con
                 :entity entity))

(defun handle-new-connection (con)
  (format t "server got connection~%")
  (let* ((new-entity (make-instance 'entity))
         (new-connection
           (make-connection con new-entity)))
    (setf (gethash con *connections*) new-connection)
    (go-to-free-spot new-entity :floor *floor*)
    (add-entity *floor* new-entity)
    (send-floor new-connection)
    (send-connections new-connection)))

(defun send-to-connection (con message)
  (websocket-driver:send
    (wscon con)
    (json:encode-json-to-string message)))

(defun send-to-all (message)
  (loop :for con
        :being :the :hash-value :of *connections*
        :do (send-to-connection con message)))

(defun handle-close-connection (con)
  (let ((message (format nil" .... ~a has left.~%"
                 (nick (gethash con *connections*)))))
    (remhash con *connections*)
    (send-to-all (list :status message))))

(defun on-client-message (ws msg)
  (handle-client-message
   (gethash ws *connections*)
   (decode-message msg)))

(defun chat-server (env)
  (let ((ws (websocket-driver:make-server env)))
    (websocket-driver:on
     :open ws (lambda () (handle-new-connection ws)))
    (websocket-driver:on
     :message ws (lambda (msg)
                (format t "Received: ~S~%" msg)
                (on-client-message ws msg)))
    (websocket-driver:on
     :close ws (lambda (&key code reason)
                (declare (ignore code reason))
                (handle-close-connection ws)))
    (websocket-driver:on
     :error ws (lambda (&rest args) (print args)))
    (lambda (responder)
      (declare (ignore responder))
      (websocket-driver:start-connection ws))))
;;--------------------------------------------------

(defun start-wsd-server ()
  ;;(generate-floor)
  (generate-test-pattern)
  (setf *server-handler*
        (clack:clackup #'chat-server :port 12345)))

(defun stop-wsd-server ()
  (clack:stop *server-handler*))
