(asdf:defsystem :util.package.seed
  :serial t
  :components ((:file "util.package.seed"))
  :depends-on (#:alexandria
               #:trivial-package-local-nicknames
               #:capitalized-export))
