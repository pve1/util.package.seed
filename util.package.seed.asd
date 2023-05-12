(asdf:defsystem :util.package.seed
  :description "Package utilities"
  :author "Peter von Etter"
  :license "LGPL-3.0"
  :version "0.0.1"
  :serial t
  :components ((:file "util.package.seed"))
  :depends-on (#:alexandria
               #:trivial-package-local-nicknames
               #:capitalized-export
               #:package.seed))
