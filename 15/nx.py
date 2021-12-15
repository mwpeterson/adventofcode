import networkx as nx
import numpy as np
from timeit import default_timer as timer
from datetime import timedelta

t_start = timer()

def find_path(data):
    n = len(data)
    G = nx.grid_2d_graph(n, n, create_using=nx.DiGraph)

    for (u,v) in G.edges:
            G[u][v]["weight"] = data[v[1]][v[0]]

    return(nx.shortest_path_length(G, (0,0), (n-1,n-1), "weight"))

data = np.genfromtxt('input', delimiter=1, dtype=int)

large = data.copy()
new = data.copy()
for _ in range(0,4):
    new += 1
    new[new == 10] = 1
    large = np.hstack((large, new.copy()))
new = large.copy()  
for _ in range(0,4):
    new += 1
    new[new == 10] = 1
    large = np.vstack((large, new.copy()))
    
t_load = timer()

print(find_path(data))

t_one = timer()

print(find_path(large))

t_end = timer()

print("load: {} ms".format(round(timedelta(seconds=t_load - t_start).total_seconds()*1000, 2)))
print("part1: {} s".format(round(timedelta(seconds=t_one - t_load).total_seconds(), 2)))
print("part2: {} s".format(round(timedelta(seconds=t_end - t_load).total_seconds(), 2)))
print("overall: {} s".format(round(timedelta(seconds=t_end - t_start).total_seconds(), 2)))