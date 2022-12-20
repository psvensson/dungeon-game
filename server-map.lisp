(in-package :dungeon)

(defparameter *floor-open* 0)
(defparameter *floor-blocked* 1)

(defclass server-map ()
  ((map-floor
    :initarg :map-floor
    :accessor map-floor
    :initform (make-array '(10 10) :initial-element 0))
   (entities
    :initarg :entities
    :accessor entities
    :initform (make-array '(10 10) :initial-element nil))
   (items
    :initarg :items
    :accessor items
    :initform (make-array '(10 10) :initial-element nil))
   ))

(defmethod add-entity ((map server-map) entity)
  (with-slots (entities) map
    (set-pos
        entities
        (list 'x (x entity) 'y (y entity))
        entity)))

(defmethod remove-entity ((map server-map) ent)
  (with-slots (entities) map
      (set-pos
        entities
        (list 'x (x ent) 'y (y ent))
        nil)))

(defmethod entity-blocking ((map server-map) pos)
   (with-slots (entities) map
          (not (eq (get-pos entities pos) nil))))

(defmethod set-floor ((map server-map) pos what)
  (with-slots (map-floor) map
      (set-pos map-floor pos what)))

(defmethod floor-blocking ((map server-map) pos)
  (with-slots (map-floor) map
      (if (in-bounds pos map-floor)
          (equal *floor-blocked* (get-pos map-floor pos))
          T)))

(defmethod position-blocked ((map server-map) pos)
  (or
   (floor-blocking map pos)
   (entity-blocking map pos)))

(defmethod get-random-pos ((map server-map))
  (with-slots (map-floor) map
      (let
          ((x (random (array-dimension map-floor 0)))
           (y (random (array-dimension map-floor 1))))
        (list 'x x 'y y))))
