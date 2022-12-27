(in-package :dungeon)
(defparameter *next-connection-id* 0)

(defclass connection ()
  ((ws-connection
    :initarg :ws-connection
    :accessor wscon)
   (nick
    :initarg :nick
    :initform "anonymous spelunker"
    :accessor nick)
   (id
    :initform (incf *next-connection-id*)
    :accessor id)
   (entity
    :initarg :entity
    :accessor entity)))
