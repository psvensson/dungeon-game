(in-package :dungeon)

(defparameter *status-pos* (list 'x 40 'y 2))
(defparameter *map-pos* (list 'x 3 'y 15))
(defparameter *participants-pos* (list 'x 20 'y 2))
(defparameter *debug-pos* (list 'x 43 'y 45))

(defparameter *map-cell-representation*
  #(#\  #\#))

(defun get-cell-representation (value)
  (elt *map-cell-representation* value))

(defun move-to (pos)
  (move *screen* (getf pos 'x) (getf pos 'y)))

(defun put-char-at (ch pos)
  (move-to pos)
  (princ ch *screen*))

(defun put-char-at-offset (ch pos offset)
  (let ((px (getf pos 'x))
        (py (getf pos 'y))
        (ox (getf offset 'x))
        (oy (getf offset 'y)))
    (put-char-at
      ch
      (list
       'x (+ px ox)
       'y (+ py oy)))))


(defun render-status ()
  (move-to *status-pos*)
  (princ *status* *screen*))

(defun get-entity-representation (entity)
  ;; Maybe have different colors per player, or chars. Hmm..
  (alexandria:assoc-value entity :id))

(defun render-map ()
  (loop for y below 10
        do (loop for x below 10
            do (put-char-at-offset
                (get-cell-representation
                 (aref *client-map* x y))
                (list 'x x 'y y)
                *map-pos*))))

(defun render-entity (entity)
  (let ((x (alexandria:assoc-value entity :x))
        (y (alexandria:assoc-value entity :y)))
    (put-char-at-offset (get-entity-representation entity)
                        (list 'x x 'y y)
                        *map-pos*)))

(defun render-entites ()
  (loop for entity being the hash-values
          of *client-entities*
          do (render-entity entity)))

(defun render-items ())

(defun render-score ())

(defun render-participant (participant count)
  ;;(move-to *debug-pos*)
  ;;(format t "Participant: ~S" participant)
  (move-to (list
            'x (+ count (getf *participants-pos* 'x))
            'y (getf *participants-pos* 'y)))
  (format *screen* "~S  ~S"
          (getf participant :id)
          (getf participant :nick)))
  ;;(format *screen* "~S" participant))

(defun render-participant-list ()
  (loop for participant in *participants*
        for count from 0
        do (render-participant
            (list-to-plist participant)
            count)))


(defun render-ui ()
  (render-map)
  (render-entites)
  (render-score)
  (render-items)
  (render-participant-list)
  (render-status))

(defun set-map (map)
  (loop for my below 10
        do (loop for mx below 10
                 do (setf
                     (aref *client-map* mx my)
                     (aref map mx my)))))

(defun set-status (status)
  (setf *status* status))

(defun symbol-from-string (str)
  (intern (string-upcase str) :keyword))

(defun decode-message  (str)
  (json:decode-json-from-string str))
