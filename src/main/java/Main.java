/* 
    Summer 24 
    COP 3503C Assignment 3 
    This program is written by: Izaac Plambeck
*/

import java.util.*;

public class Main {
    static class DisjointSet {
        int[] parent, rank, size;
        
        public DisjointSet(int n) {
            parent = new int[n + 1];
            rank = new int[n + 1];
            size = new int[n + 1];
            for (int i = 1; i <= n; i++) {
                parent[i] = i;
                size[i] = 1;
            }
        }
        
        public int find(int x) {
            if (parent[x] != x) {
                parent[x] = find(parent[x]);
            }
            return parent[x];
        }
        
        public void union(int x, int y) {
            int rootX = find(x);
            int rootY = find(y);
            
            if (rootX != rootY) {
                if (rank[rootX] > rank[rootY]) {
                    parent[rootY] = rootX;
                    size[rootX] += size[rootY];
                } else if (rank[rootX] < rank[rootY]) {
                    parent[rootX] = rootY;
                    size[rootY] += size[rootX];
                } else {
                    parent[rootY] = rootX;
                    size[rootX] += size[rootY];
                    rank[rootX]++;
                }
            }
        }
        
        public int getSize(int x) {
            return size[find(x)];
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        int n = sc.nextInt();
        int m = sc.nextInt();
        int d = sc.nextInt();

        int[][] connections = new int[m][2];
        for (int i = 0; i < m; i++) {
            connections[i][0] = sc.nextInt();
            connections[i][1] = sc.nextInt();
        }

        int[] destroyedConnections = new int[d];
        for (int i = 0; i < d; i++) {
            destroyedConnections[i] = sc.nextInt() - 1;
        }

        // Initialize the disjoint set
        DisjointSet ds = new DisjointSet(n);

        // Array to mark which edges are active
        boolean[] active = new boolean[m];
        Arrays.fill(active, true);

        for (int i : destroyedConnections) {
            active[i] = false;
        }

        // Initially connect all non-destroyed edges
        for (int i = 0; i < m; i++) {
            if (active[i]) {
                ds.union(connections[i][0], connections[i][1]);
            }
        }

        // Calculate initial connectivity
        long initialConnectivity = 0;
        for (int i = 1; i <= n; i++) {
            if (ds.find(i) == i) {
                int size = ds.getSize(i);
                initialConnectivity += (long) size * size;
            }
        }

        List<Long> results = new ArrayList<>();
        results.add(initialConnectivity);

        // Reverse destruction process
        for (int i = d - 1; i >= 0; i--) {
            int[] edge = connections[destroyedConnections[i]];
            int u = edge[0];
            int v = edge[1];

            // Recalculate sizes before union
            int rootU = ds.find(u);
            int rootV = ds.find(v);

            if (rootU != rootV) {
                int sizeU = ds.size[rootU];
                int sizeV = ds.size[rootV];

                ds.union(u, v);

                // New size of the set after union
                int newSize = ds.getSize(u);

                initialConnectivity -= (long) sizeU * sizeU + (long) sizeV * sizeV;
                initialConnectivity += (long) newSize * newSize;
            }

            results.add(initialConnectivity);
        }

        // Print results in reverse order
        Collections.reverse(results);
        for (long result : results) {
            System.out.println(result);
        }

        sc.close();
    }
}
