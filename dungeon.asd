;;;; dungeon.asd

(asdf:defsystem #:dungeon
  :description "Describe dungeon here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:clack
               #:alexandria
               #:websocket-driver
               #:cl-json
               #:croatoan)
  :components
                ((:file "package")
                 (:file "server-map")
                 (:file "dungeon")
                 (:file "client")
                 (:file "client-messages")
                 (:file "server")
                 (:file "server-messages")
                 (:file "connection")
                 (:file "entity")
                 (:file "ui")))
