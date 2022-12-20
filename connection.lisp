(in-package :dungeon)

(defclass connection ()
  ((ws-connection
    :initarg :ws-connection
    :accessor wscon)
   (nick
    :initarg :nick
    :initform "anonymous"
    :accessor nick)
   (entity
    :initarg :entity
    :accessor entity)))
