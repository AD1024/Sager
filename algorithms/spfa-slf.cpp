#include "utils.h"
using namespace std;

inline void spfa(int s, Graph& g) {
    long long score = 0;
    vector<bool> vis(g.size(), false);
    vector<int> dist(g.size(), 0x3f3f3f3f);
    dist[s] = 0;
    deque<int> q;
    q.push_back(s);
    while(not q.empty()) {
        score += 1;
        int k = q.front();
        q.pop_front();
        for(Edge& e : g[k]) {
            score += 1;
            int v = e.fi;
            int w = e.se;
            if (dist[v] > dist[k] + w) {
                dist[v] = dist[k] + w;
                if (not vis[v]) {
                    if (not q.empty() and dist[v] < dist[q.front()]) {
                        q.push_front(v);
                    } else {
                        q.push_back(v);
                    }
                }
            }
        }
    }
    cout << "Score: " << score << endl;
    cout << "Answer: " << dist[dist.size() - 1] << endl;
}

int main() {
    Graph g = readGraph();
    spfa(0, g);
    return 0;
}