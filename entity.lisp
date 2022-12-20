(in-package :dungeon)

(defparameter *next-entity-id* 0)
(defparameter *default-entity-hp* 10)

(defclass entity ()
  ((x :initarg :x :initform 0 :accessor x)
   (y :initarg :y :initform 0 :accessor y)
   (id  :initform (incf *next-entity-id*) :accessor :id)
   (hp :initarg :hp :initform *default-entity-hp*)))

(defmethod go-to-free-spot ((ent entity)
                            &key floor
                            (count 0))
  (if (> count 10)
      (format t "failed to find free position. giving up~%")
      (let ((pos (get-random-pos floor)))
        (if (position-blocked floor pos)
            (go-to-free-spot
                ent
                :floor floor
                :count (incf count))
            (entity-move ent pos)))))

(defmethod entity-move ((ent entity) pos)
  (remove-entity *floor* ent)
  (setf (x ent) (getf pos 'x))
  (setf (y ent) (getf pos 'y))
  (add-entity *floor* ent)
  (format t "entity moved to ~S,~S~%" (x ent) (y ent))
  (send-to-all (list :entity ent))
  (format nil "moved to ~S,~S~%" (x ent) (y ent)))

(defmethod project-entity-to-dir ((ent entity) dir)
  (project-pos-to-dir
    (list
     'x (x ent)
     'y (y ent))
    dir))

(defmethod entity-in-position ((ent entity) pos)
  (let ((x (getf pos 'x))
        (y (getf pos 'y)))
    (and
     (equal x (x ent))
     (equal y (y ent)))))
