(eval-when (:compile-toplevel :load-toplevel :execute)
  (ignore-errors (make-package :util.package.seed :use '(:cl)))
  (in-package :util.package.seed)
  (setf *readtable* (capitalized-export:make-capitalized-export-readtable)))

(defun Unexport-all (&optional (package *package*))
  (let (exported-symbols)
    (do-external-symbols (sym package)
      (push sym exported-symbols))
    (unexport exported-symbols package)))

(defmacro Nickname (nickname package-name &rest more)
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     ,@(loop :for (nick pkg) :on (append (list nickname package-name) more)
             :by #'cddr
             :while pkg
             :collect `(trivial-package-local-nicknames:add-package-local-nickname
                        ',nick ',pkg))))

(defmacro Do-resident-symbols ((symbol &optional (package *package*)) &body body)
  "Iterate over all symbols whose home package is PACKAGE."
  (alexandria:once-only (package)
    `(loop :for ,symbol :being :each :present-symbol :of ,package
           :when (eql ,package (symbol-package ,symbol))
             :do (progn ,@body))))

(defun Package-imported-symbols (package &aux result)
  "Returns a list of symbols that have been imported into PACKAGE."
  (do-symbols (sym package (remove-duplicates result))
    (multiple-value-bind (s status)
        (find-symbol (string sym) package)
      (declare (ignore s))
      (when (and (not (eq status :inherited))
                 (not (eq (symbol-package sym) package)))
        (push sym result)))))

(defun Package-foreign-shadowing-symbols (package)
  "Returns a list of symbols that have been shadowing-imported into
PACKAGE."
  (setf package (find-package package))
  (loop :for s :in (package-shadowing-symbols package)
        :unless (eql (symbol-package s) package)
          :collect s))
