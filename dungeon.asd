;;;; dungeon.asd

(asdf:defsystem #:dungeon
  :description "Describe dungeon here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:clack
               #:websocket-driver
               #:croatoan)
  :components
                ((:file "package")
                 (:file "client")
                 (:file "server")
                 (:file "dungeon")))
