# Sager
A Demonic Graph Synthesizer for Worst Case Performance. For more information, plase see our report, slides, and `demo.sh`

# Project Structure
- `sager.rkt` contains the pipeline procedure from synthesizing to scaling and the concrete calls we make to generate data.
- `core.rkt` contains procedures use incremental solving to synthesize graphs
- `scaler.rkt` contains utilities for scaling a gadget to a larger graph
- `graphgen.rkt` contains graph representation and symmetry breaking techniques
- `helper.rkt` contains some helper function and auxiliary symbolic data structure
- `algorithms/` contains concrete implementations of target algorithms (SPFAs)

## Comparison Data Generators
Dependency:
```bash
python3 -m pip install cyaron
```
- `shortest_path_tree_hack.py` generates data that utilize Shortest Path Tree based graphs
- `random_graph.py` generates graphs based on randomization; it guarantees that all nodes are connected and reachable from each other
- `dag.py` generates the graph that utilize the property of a DAG (linked list approach)
- `cyaron_hack.py` uses cyaron to generates graph that can hack SPFA based on empirical experiments.

# Synthesize a Graph
- Configure the gadget size and the final size of the graph, the prefix of name of data file to store.

Example:

```racket
;;; Sample Calls
;;; Generate 4 files in data directory: 
;;; - test-sager-demo-spfa-vis-10000-A
;;; - test-sager-demo-spfa-vis-10000-B
;;; - test-sager-demo-spfa-vis-100000-A
;;; - test-sager-demo-spfa-vis-100000-B
;;; where A / B stands for the Connect by Entry Nodes and Connect by Exit Nodes
;;; the target algorithm to hack is SPFA with out heuristics
;;; the scaled graph contain 10000 nodes and 100000 nodes
(let ([prefix (make-string-prefix "data/test-sager-demo-spfa-vis-")])
  (sager 
        (map prefix (list "10000" "100000"))   ;; Name of files
        spfa-vis                               ;; Target Algorithm
        (list '() '())                         ;; Manually constructed Gadgets (with human insights)
        (list 10000 100000)                    ;; Size of scaled graphs 
        4 30))                                 ;; Size of Synthesized Gadget and Searching Bound
```
See more example in `sager.rkt`
- run `racket sager.rkt`

# Run Tests for Algorithms
## Compile Programs
Place the cpp implementation in `./algorithms` the run
```bash
make <filename>
```

## Run Tests
```bash
make test pattern=<pattern> program=<program>
```
The pattern is a regular expression. For all files whose name can be matched by the regex, the script will feed them to the selected program once a time.

Example:
```bash
make test pattern="*sager*spfa-vis*" program="spfa-vis"
```
will run `spfa-vis` with all the pre-generated data that target at SPFA with no heuristics.

## Implemented Algorithms
- SPFA
- SPFA+SLF
- SPFA+LLL
- SPFA+SLF+LLL
- Dijkstra
