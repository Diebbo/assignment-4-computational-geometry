= Rectangle Stabbing Counting

Using the segment tree paradigm we need to construct a data structure capable of answering efficiently the number of rectangles a point $q$ lies in. The DS must use $O(n log n)$ space and $O(log^2 n)$ in time complexity.

Let's denote $R$ the set of $n$ rectangles in the plane, where each rectangle is composed of the x-segment and the y-segment (i.e., $r = [x_1, x_2] times [y_1, y_2]$).

To solve the problem, we start by defining all the different elementary intervals induced by the x-coordinates of the rectangle edges. This can be achieved by sorting all the rectangles based on their x-coordinates and then creating disjoint intervals between consecutive coordinates (see @segment-tree).

#figure(
  caption: ["Elementary intervals induced by the x-coordinates of rectangle edges"],
  image("../assets/segment-tree.png"),
)<segment-tree>

We denote *elementary intervals* the intervals created between two consecutive x-coordinates of rectangle edges. There are at most $2n$ such coordinates so the number of elementary intervals is $O(n)$.

Next, we define a segment tree $T$ over these elementary intervals and the concept of canonical subsets. Moreover, for each node $v$ in the tree, the canonical set $S(v)$ contains all the rectangles that completely cover the interval associated with node $v$ but not contained in the interval of the parent of $v$.

This is not sufficient to answer the query, so we also create for each node a secondary DS $T_v$ that is a segment tree built on the y-projections of the rectangles in $S(v)$.

Let's remark that the number of nodes in the primary segment tree is $O(n)$, thus the number of canonical sets is also $O(n)$. The total size of all canonical sets is $O(n log n)$, we can verify that by thinking that each rectangle is stored in $O(log n)$ nodes of the primary segment tree.

If we assume each of those $O(n log n)$ nodes has a full $O(n)$-sized secondary tree, the total space becomes $O(n^2 log n)$, which is not acceptable. To solve this problem, we can use a persistent segment tree for the secondary trees.

Let's describe how to build the Persistent Segment Trees (PST) for each node of the primary segment tree using a sweep line algorithm:
+ Iterate through the sorted x-coordinates. Maintain a single Segment Tree $T_Y$ over the y-coordinates.
+ When an event is a left edge of a rectangle, perform a range update on $T_Y$ to add the rectangle's y-interval.
+ Since we need all past states for queries, we use *Path Copying* to make $T_Y$ a Persistent Segment Tree. A range update modifies $O(log N)$ nodes, creating a new root pointer and $O(log N)$ new nodes in space.
+ After the update at $x_k$, we store the new root of $T_Y$ as $"Root"_k$.

Summing up, the total space is bounded by $O(n log n)$ because there're $O(n)$ events and each event creates $O(log n)$ new nodes in the PST, same as before.

*Time*: Query time is the height of the primary segment tree $O(log n)$ times the query time of the secondary segment tree $O(log n)$, resulting in a total query time of $O(log^2 n)$.
