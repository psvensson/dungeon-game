(in-package #:dungeon)

;; (ql:quickload :websocket-driver-client)

(defvar *client* (wsd:make-client "ws://localhost:12345/echo"))

(defun start-wsd-client ()
  (wsd:start-connection *client*)
  (wsd:on :message *client*
          (lambda (message)
            (format t "~&Got: ~A~%" message)))
  (wsd:send *client* "Hi")
  (wsd:close-connection *client*))
