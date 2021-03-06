; Exercises and examples from Yet Another Scheme Tutorial
; Copyright (C) 2016 NewForester
; Available under MIT Licence

;;; Abbreviation for call-with-current-continuation
(define call/cc call-with-current-continuation)

;;; This function is re-assigned in `choose' and `fail' itself.
(define fail #f)

;;; Nondeterminism macro operator
(define-syntax amb
  (syntax-rules ()
    ((_) (fail))
    ((_ a) a)
    ((_ a b ...)
      (let ((fail0 fail))
        (call/cc
          (lambda (cc)
            (set! fail
              (lambda ()
                (set! fail fail0)
                (cc (amb b ...))))
            (cc a)))))))

;;; write following at the end of file
;;; initial value for fail
(call/cc
  (lambda (cc)
    (set! fail
      (lambda ()
        (cc 'no-choice)))))

;-- The Pythagorean triangle example

;;; Return square of x
(define (sq x)
  (* x x))

;;; Pythagorean triples
(define (pythag a b c)
  (if (= (+ (sq a) (sq b)) (sq c))
    (list a b c)
    (amb)))

;;; Return the first Pythagorean triple from a list of possible solutions
(pythag (amb 1 2 3) (amb 3 4 5) (amb 4 5 6))

; EOF
