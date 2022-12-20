(in-package :dungeon)

(defgeneric server-message (op args)
  (:documentation "handles incoming messages from the
server, which are keyed on the op symbol"))

(defmethod server-message ((op (eql :status)) args)
  (set-status (car args)))

(defmethod server-message ((op (eql :map)) args)
  (set-map (list-to-array (car args) 2)))

(defmethod server-message ((op (eql :entity)) args)
  ;;(inspect args)
  (add-client-entity (car args)))

(defmethod server-message ((op (eql :connections)) args)
  (inspect args)
  (setf *participants* (car args)))


(defun handle-server-message (msg)
  (clear *screen*)
  (server-message
      (symbol-from-string (car msg)) (cdr msg))
  (render-ui))
