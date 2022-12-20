(in-package :dungeon)

(defparameter *floor* (make-instance 'server-map))

(defun project-pos-to-dir (pos dir)
  (let
      ((x (getf pos 'x))
      (y (getf pos 'y)))
    (case (symbol-from-string dir)
      (:up  (list 'x x 'y (decf y)))
      (:down (list 'x x 'y (incf y)))
      (:right (list 'x (incf x) 'y y))
      (:left (list 'x (decf x) 'y y)))))

(defun in-bounds (pos arr)
  (let ((x (getf pos 'x))
        (y (getf pos 'y)))
    (and
     (and (> x -1) (> y -1))
     (and
      (< x (array-dimension arr 0))
      (< y (array-dimension arr 1))))))


(defun make-floor-square (pos)
  (loop for x below 3
        do (loop for y below 3
                 do
                    (set-floor *floor*
                               (list
                                'x (+ (getf pos 'x) x)
                                'y (+ (getf pos 'y) y))
                               *floor-blocked*))))

(defun generate-floor ()
  (loop for i below 4
        do (make-floor-square
            (list
             'x (random 7)
             'y (random 7)))))

(defun generate-test-pattern ()
  (mapc (lambda (pos)
           (set-floor *floor*
                      pos
                      *floor-blocked*))
        (list
         (list 'x 5 'y 0)
         (list 'x 0 'y 9)
         (list 'x 9 'y 9))))

(defun 2d-array-to-list (array)
  (loop for i below (array-dimension array 0)
        collect (loop for j below (array-dimension array 1)
                      collect (aref array i j))))

(defun list-dimensions (list depth)
  (loop repeat depth
        collect (length list)
        do (setf list (car list))))

(defun list-to-array (list depth)
  (make-array (list-dimensions list depth)
              :initial-contents list))

(defun get-pos (arr pos)
  (aref arr (getf pos 'y) (getf pos 'x)))

(defun set-pos (arr pos val)
  (setf (aref arr
              (getf pos 'y)
              (getf pos 'x))
        val))
