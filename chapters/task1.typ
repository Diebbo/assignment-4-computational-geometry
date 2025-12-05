= Rectangle Stabbing Counting

Using the segment tree paradigm we need to construct a data structure capable of answering efficiently the number of rectangles a point $q$ lays in. The DS must use $O(n log n)$ space and $O(log^2 n)$ in time complexity.

Let's denote $R$ the set of $n$ rectangles in the plane, where each rectangle is composed of the x-segment and the y-segment (i.e., $r = [x_1, x_2] times [y_1, y_2]$).

To solve the problem, we start by defining all the different elementary intervals induced by the x-coordinates of the rectangle edges. This can be achieved by sorting all the rectangles based on their x-coordinates and then creating disjoint intervals between consecutive coordinates (see @segment-tree).

#figure(
  caption: ["Elementary intervals induced by the x-coordinates of rectangle edges"],
  image("../assets/segment-tree.png"),
)<segment-tree>

We denote *elementary intervals* the intervals created between two consecutive x-coordinates of rectangle edges. There's at most $2n$ such coordinates so the number of elementary intervals is $O(n)$.

Next, we define a segment tree $T$ over these elementary intervals and the concept of canonical subsets. Moreover, for each node $v$ in the tree, the canonical set $S(v)$ contains all the rectangles that completely cover the interval associated with node $v$. This is not sufficient to answer the query, so we also create for each node a secondary DS $T_v$ that is a segment tree built on the y-projections of the rectangles in $S(v)$.

*Space*: 
Let's remark that the number of nodes in the primary segment tree is $O(n)$, thus the number of canonical sets is also $O(n)$. The total size of all canonical sets is $O(n log n)$, we can verify that by thinking that each rectangle is stored in $O(log n)$ nodes of the primary segment tree.

The total space complexity of this data structure is
$
  sum_(v in T) |S(v)| = O(n log n)
$

Each rectangle is stored in $O(log n)$ nodes of the primary segment tree, and since the y-coordinates also need to be sorted and structured, each secondary segment tree $T_v$ uses $O(|S(v)|)$ space. Therefore, the overall space complexity is $O(n log n)$.

*Time*: Query time is the height of the primary segment tree $O(log n)$ times the query time of the secondary segment tree $O(log n)$, resulting in a total query time of $O(log^2 n)$.
