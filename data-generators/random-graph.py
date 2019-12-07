from cyaron import Graph
import argparse
import sys
import random
import os

os.chdir(os.path.dirname(__file__))
if not os.path.exists('../data'):
    os.mkdir('../data')
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Random Graph Generator')
    parser.add_argument('--node_count', type=int, required=True)
    parser.add_argument('--edge_count', type=int, required=True)

    arg = parser.parse_args(sys.argv[1:])
    g = Graph.UDAG(arg.node_count, arg.edge_count, weight_limit=(1, 100))
    with open('../data/test-cyaron-random-graph-{}'.format(arg.node_count), 'w') as fp:
        fp.write(f'{arg.node_count} {arg.edge_count}\n')
        edges = list(g.iterate_edges())
        random.shuffle(edges)
        for e in edges:
            fp.write(f'{e.start - 1} {e.end - 1} {e.weight}\n')
