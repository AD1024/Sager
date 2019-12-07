from cyaron import *
import random
import os

os.chdir(os.path.dirname(__file__))
if not os.path.exists('../data'):
    os.mkdir('../data')

with open("../data/test-cyaron-10000", "w") as f:
    g = Graph.hack_spfa(10000, weight_limit = 20)
    f.write("10000 30000\n")
    edges = [e for e in g.iterate_edges()]
    random.shuffle(edges)
    for e in edges:
        f.write("%d %d %d\n" % (e.start - 1, e.end - 1, e.weight))
        f.write("%d %d %d\n" % (e.end - 1, e.start - 1, e.weight))

with open("../data/test-cyaron-100000", "w") as f:
    g = Graph.hack_spfa(100000, weight_limit = 20)
    f.write("100000 300000\n")
    for e in g.iterate_edges():
        f.write("%d %d %d\n" % (e.start - 1, e.end - 1, e.weight))
        f.write("%d %d %d\n" % (e.end - 1, e.start - 1, e.weight))

        