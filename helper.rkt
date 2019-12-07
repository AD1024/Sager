#lang rosette

(provide (all-defined-out))

(define (make-q n (fromMid #f))
  (if fromMid
      (vector (make-vector (* 2 n)) n n)
      (vector (make-vector n) 0 0)))

(define (push-q! q v)
  (match-define (vector vec head tail) q)
  (assert (< tail (vector-length vec)))
  (vector-set! vec tail v)
  (vector-set! q 2 (+ tail 1)))

(define (push-q-front! q v)
  (match-define (vector vec head tail) q)
  (assert (> head 0))
  (vector-set! vec head v)
  (vector-set! q 1 (- head 1)))

(define (pop-q! q)
  (match-define (vector vec head tail) q)
  (and (empty-q? q)
       (begin
         (vector-set! q 1 (+ head 1))
         (vector-ref vec head))))

(define (front-q q)
  (match-define (vector vec head tail) q)
  (and (not (empty-q? q))
       (vector-ref vec head)))

(define (empty-q? q)
  (match-define (vector vec head tail) q)
  (not (eq? (- tail head) 0)))

(define (BV size) (bitvector size))
(define (make-bv value size)
  (bv value (BV size)))
(define SZ 6)
(define bv0 (make-bv 0 SZ))
(define bv1 (make-bv 1 SZ))
(define (max-bv bit) (make-bv -1 SZ))

(define (iter edges procedure (is-adjlist #f))
  (define adj-list 
    (if is-adjlist 
        edges
        (vector-filter (lambda (pi) (bvugt (cdr pi) bv0)) 
                       (for/vector ([v (vector-length edges)])
                         (cons v (vector-ref edges v))))))
  (vector-map procedure adj-list))

(define (write-in-file adj-list filename)
  (with-output-to-file filename #:mode 'text #:exists 'replace
    (λ ()
      (define node-count (vector-length adj-list))
      (define edge-count (apply +
                                (for/list ([v adj-list])
                                  (vector-length v))))
      (printf "~a ~a\n" node-count edge-count)
      (for ([u (vector-length adj-list)])
        (for ([edge (vector-ref adj-list u)])
          ;; u v w
          (printf "~a ~a ~a\n" u (car edge) (cdr edge)))))))