clean:
	rm -rf benchmarks
	find . -name "compiled" | xargs rm -rf

clean-algo:
	rm -rf targets

create-cyaron :
	python3 data-generators/cyaron-hack.py

create-spt :
	python3 data-generators/shortest_path_tree_hack.py

create-grid :
	python3 data-generators/grid_graph_hack.py

create-random-1w :
	python3 data-generators/random-graph.py --node_count=10000 --edge_count=30000

create-random-10w :
	python3 data-generators/random-graph.py --node_count=100000 --edge_count=300000

create-sager :
	racket sager.rkt

test :
	find data -name "$(pattern)" | sort | xargs -I {} sh -c "echo {}; cat {} | ./targets/$(program)"

create-data : create-cyaron create-spt create-sager create-grid

% : algorithms/%.cpp
	if ! [ -d targets ] ; then mkdir targets; fi;
	g++ -o targets/$@ $< -std=c++14 -Ofast
