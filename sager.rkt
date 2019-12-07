#lang rosette

(require "algorithms.rkt"
         "graphgen.rkt"
         "solver.rkt"
         "scaler.rkt"
         "helper.rkt"
         "core.rkt")
(provide (all-from-out
          "algorithms.rkt"
          "graphgen.rkt"
          "solver.rkt"
          "helper.rkt"
          "scaler.rkt"
          "core.rkt"))

(define solve-graph solve-graph++) ;; this uses incremental solving, which is faster compared with other solving strategies using binary search
(define graphgen adj-matrix-sorted) ;; this works slightly better on larger cases

;; - filename is the name of file where the data will go
;; - algo is the algorithm that one may want to hack
;; - gadget g is some extra constructs users can mix into the graph if they have prior knowledge of the algorithm
;; - n is the number of nodes
;; - m is the number of edges constrained TODO: not yet implemented
;; - scale-factor is the size of gadget we want to synthesis, normally size 5 is acceptable,
;; while size 4 can be used for in-time conjecture verification
;; - size-limit is the maximum depth of the algorithm; for spfa algorithm, it's the number of times a node enter the queue;
;; by default it's the upper bound of entry time, but to set it small enough (say 50 for size 4) will gain users a huge speedup.
(define (sager filename algo g n scale-factor size-limit)
  (define small-raw-graph (solve-graph graphgen algo scale-factor size-limit)) ;; this is a adjacent matrix
  (define running-info (cdr (algo small-raw-graph 0 (expt scale-factor 3) #t)))
  ;; to make sager able to generate multiple files at once, here g/n/filename is actually list of g/n/filename
  (for ([g g]
        [n n]
        [filename filename])
    
    ;(define small-graph (gadget 1000 small-raw-graph (first running-info) (last running-info)))
    (for ([small-graph (list (gadget 1000 small-raw-graph (first running-info) (last running-info))
                             (gadget 1000 small-raw-graph (first running-info) (first running-info)))]
          [filename (list (string-append filename "-A")
                          (string-append filename "-B"))])
      (define large-graph (scale (append g (list small-graph)) n))
      (write-in-file large-graph filename))))

(define star-graph (for/vector ([i 100])
                     (for/vector ([j 100])
                       (if (and (= i 0) (not (= j 0)))
                           (make-bv 1 SZ)
                           (make-bv 0 SZ)))))
(define star-graph-gadget (gadget 100 star-graph 0 9))
(define huge-weight (for/vector ([i 2])
                      (for/vector ([j 2])
                        (if (and (= i 0) (= j 1))
                            (make-bv -1 SZ)
                            (make-bv 0 SZ)))))
(define huge-weight-gadget (gadget 50 huge-weight 0 1))

(define gadgets (list star-graph-gadget huge-weight-gadget))

(define (make-string-prefix prefix)
  (curry string-append prefix))

;; Sample Calls
;(let ([prefix (make-string-prefix "data/test-sager-demo-spfa-vis-")])
;  (sager (map prefix (list "10000" "100000"))
;         spfa-vis
;         (list '() '())
;         (list 10000 100000)
;        4 30))

;(let ([prefix (make-string-prefix "data/test-sager-5-spfa-vis-")])
;  (sager (map prefix (list "10000" "100000" "gadgets-10000" "gadgets-100000"))
;         spfa-vis
;         (list '() '() gadgets gadgets)
;         (list 10000 100000 10000 100000)
;         5 50))
;
;(let ([prefix (make-string-prefix "data/test-sager-4-spfa-slf-")])
;  (sager (map prefix (list "10000" "100000" "gadgets-10000" "gadgets-100000"))
;         spfa-slf
;         (list '() '() gadgets gadgets)
;         (list 10000 100000 10000 100000)
;         4 30))
;
;(let ([prefix (make-string-prefix "data/test-sager-5-spfa-slf-")])
;  (sager (map prefix (list "10000" "100000" "gadgets-10000" "gadgets-100000"))
;         spfa-slf
;         (list '() '() gadgets gadgets)
;         (list 10000 100000 10000 100000)
;         5 50))

;(let ([prefix (make-string-prefix "data/test-sager-4-spfa-lll-")])
;  (sager (map prefix (list "10000" "100000" "gadgets-10000" "gadgets-100000"))
;         spfa-lll
;         (list '() '() gadgets gadgets)
;         (list 10000 100000 10000 100000)
;         4 30))

;(let ([prefix (make-string-prefix "data/test-sager-5-spfa-lll-")])
; (sager (map prefix (list "10000" "100000" "gadgets-10000" "gadgets-100000"))
;        spfa-lll
 ;;       (list '() '() gadgets gadgets)
;        (list 10000 100000 10000 100000)
;        5 50))