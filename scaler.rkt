#lang rosette

(provide scale gadget)

(require data/queue)

(struct vertex (edges is-vis? is-marked? num) #:mutable #:transparent)
(struct gadget (weight graph start end) #:transparent)
(define (make-vertex edges [is-vis? #f] [is-marked? #f] [num -1])
  (vertex edges is-vis? is-marked? num))

;; scale a graph as large as possible to have size ≤ max-nodes
;; gadgets is a list of gadget (p, graph, start, end), where
;; weight denotes the probability of being chosen (standard being 1000, as a convention),
;; start and end dentoes the entry and exit nodes for the graph
;; accept an adj matrix, return an adj list
(define (scale gadgets max-nodes)
  (define cores (map
                 (λ (g) (struct-copy gadget g
                                     [graph (vector-map (λ (edges)
                                                          (vector-map bitvector->natural edges))
                                                        (gadget-graph g))]))
                 gadgets))
  (define graph+ (let ([graph (gadget-graph (pick cores max-nodes))])
                   (for/vector ([edges graph]) ;; transform graph into adj-list
                     (define edges+ (for/vector ([v (range (vector-length graph))]
                                                 [w edges]
                                                 #:when (> w 0))
                                      (mcons v w)))
                     (make-vertex edges+ #f))))
  (define current-size (vector-length graph+))
  (define (trans v) ;; transform adj-list into the linked list version (using vertex struct)
    (let ([vtx (vector-ref graph+ v)])
      (unless (vertex-is-vis? vtx)
        (set-vertex-is-vis?! vtx #t)
        (for/vector ([v-w (vertex-edges vtx)])
          (set-mcar! v-w (trans (mcar v-w)))))
      vtx))
  (define (dfs-expand! vertex)
    (if (not (vertex-is-marked? vertex))
        (let ([g (pick cores (- max-nodes current-size -1))])
          (if g ;(<= (+ current-size core-len -1) max-nodes)
              (begin
                (define core (gadget-graph g))
                (define core-len (vector-length core))
                (define start (gadget-start g))
                (define end (gadget-end g))
                (set! current-size (+ current-size core-len -1))
                (define newvertices (make-vector core-len))
                (for ([i core-len])
                  (vector-set! newvertices i
                               (if (= i start)
                                   vertex
                                   (make-vertex #f))))
                (define outgoing-edges (vertex-edges vertex))
                (for ([i core-len])
                  (define edges (vector-ref core i))
                  (define u (vector-ref newvertices i))
                  (define edges+ (for/vector ([j core-len]
                                              #:when (not (= (vector-ref edges j) 0)))
                                   (mcons (vector-ref newvertices j) (vector-ref edges j)))) ;; v-w
                  (set-vertex-edges! u
                                     (if (not (= i end))
                                         edges+
                                         (vector-append edges+ outgoing-edges))))
                (let iterate-and-expand ([idx 0])
                  (if (< idx (vector-length outgoing-edges))
                      (if (dfs-expand! (mcar (vector-ref outgoing-edges idx)))
                          (iterate-and-expand (add1 idx))
                          #f)
                      #t))) ;; try to iterate and expand over connected vertices
              #f)) ;; has already allocated everything
        #t)) ;; current has been marked
  (define num-cnt 0)
  (define (numbering! v)
    (define q (make-queue))
    (enqueue! q v)
    (let bfs ()
      (when (non-empty-queue? q)
        (define v (dequeue! q))
        (when (= (vertex-num v) -1)
          (set-vertex-num! v num-cnt)
          (set! num-cnt (+ num-cnt 1))
          (for ([v-w (vertex-edges v)])
            (enqueue! q (mcar v-w))))
        (bfs))))
  (define (to-adj v)
    (define result (make-vector  num-cnt))
    (define visited? (make-vector num-cnt #f))
    (let dfs ([v v])
      (define num (vertex-num v))
      (when (not (vector-ref visited? num))
        (vector-set! visited? num #t)
        (vector-set! result num (for/vector ([v-w (vertex-edges v)])
                                  (cons (vertex-num (mcar v-w)) (mcdr v-w))))
        (for/vector ([v-w (vertex-edges v)])
          (dfs (mcar v-w)))))
    result)
          
  (define res-graph (trans 0)) ;; transform into a linked list version of graph
  (let while ()
    (when (dfs-expand! res-graph) ;; try to expand graph
      (while)))
  (numbering! res-graph) ;; number the graph
  (to-adj res-graph))

(define (pick gadgets limit)
  (define gadgets+ (filter (λ (g) (<= (vector-length (gadget-graph g)) limit)) gadgets))
  (if (empty? gadgets+)
      #f
      (let* ([tot (apply + (map gadget-weight gadgets+))]
             [choice (random tot)])
        (let find ([choice choice]
                   [gadgets gadgets+])
          (let* ([g (car gadgets)]
                 [weight (gadget-weight g)])
            (if (< choice weight)
                g
                (find (- choice weight) (cdr gadgets))))))))


