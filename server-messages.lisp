(in-package :dungeon)

(defgeneric execute-client-message (op connection args)
  (:documentation
   "Each type of message has its own method defined
    below, matching the op"))

(defmethod execute-client-message ((op (eql :move))
                                   connection dir)
  (let* ((entity (entity connection))
         (pos (project-entity-to-dir entity dir)))
    (if (position-blocked *floor* pos)
      "Cannot go that way"
      (entity-move entity pos))))

(defmethod execute-client-message ((op (eql :shoot))
                                   connection dir)
   dir)

(defun handle-client-message (connection msg)
  (let
      ((command (symbol-from-string (car msg))))
    (send-to-connection
     connection
      (list :status (execute-client-message
                     command
                     connection
                     (cadr msg))))))

(defun send-floor (connection)
  (send-to-connection
    connection (list :map
        (2d-array-to-list (map-floor *floor*)))))

(defun send-connections (connection)
  (send-to-connection
   connection (list :connections
                    (get-connections-list))))
