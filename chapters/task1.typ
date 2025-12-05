= Rectangle Stabbing Counting

Using the segment tree paradigm we need to construct a data structure capable of answering efficiently the number of rectangles a point $q$ lays in. The DS must use $O(n log n)$ space and $O(log^2 n)$ in time complexity.

Let's denote $S$ the set of $n$ rectangles in the plane, where each rectangle is composed of the x-segment and the y-segment (i.e., $r = [x_1, x_2] times [y_1, y_2]$).

// To solve the problem, we can start by constructing a segment tree $T$ on the x-projections of the rectangles in $S$. We start by finding the extremes on the x-projection, and than by constructing the root of the tree that lays on the median. On the same node we store the numbers of rectangles that completely covers the median.
//
// We can then recursively construct the left and right subtrees, by considering the rectangles that lays completely on the left or right of the median respectively. The children nodes will be constructed on half of the distance of the parent node with the extremes.
//
// For each canonical set associated with a node $v$ of the segment tree $T$, we build a Tree structure $T_v$ on the y-projections of the rectangles contained in $v$. 
//
// *Query*: To answer the query for a point $q = (q_x, q_y)$, we would recurring from the root having multiple cases:
// - If $q_x$ is in the interval of the current node, we would proceed the same way but on the secondary DS $T_v$ to count the number of y-projections containing $q_y$. 
// - If $q_x$ is less than the interval of the current node, we would proceed to the left child, on the right child otherwise.

To solve the problem, we start by defining all the different elementary intervals induced by the x-coordinates of the rectangle edges. This can be achieved by sorting all the rectangles based on their x-coordinates and then creating disjoint intervals between consecutive coordinates (see @segment-tree).

#figure(
  caption: ["Elementary intervals induced by the x-coordinates of rectangle edges"],
  image("../assets/segment-tree.png"),
)<segment-tree>

Next, we define a segment tree $T$ over these elementary intervals and the concept of canonical subsets. Moreover, for each node $v$ in the tree, the canonical set $S(v)$ contains all the rectangles that completely cover the interval associated with node $v$. This is not sufficient to answer the query, so we also create for each node a secondary DS $T_v$ that is a segment tree built on the y-projections of the rectangles in $S(v)$.

*TOCHECK*
*Space*: The total space complexity of this data structure is
$
  sum_(s in S) |T(s)| = sum_(s in S) O(|S|) = O(n log n)
$

Where $T(s)$ is the set of nodes in the primary segment tree whose canonical sets contain the rectangle $s$. Each rectangle is stored in $O(log n)$ nodes of the primary segment tree, and each secondary segment tree $T_v$ uses $O(|S(v)|)$ space. Therefore, the overall space complexity is $O(n log n)$.

*Time*: Query time is the hight of the primary segment tree $O(log n)$ times the query time of the secondary segment tree $O(log n)$, resulting in a total query time of $O(log^2 n)$.
