= Area computation
How to find the union of the areas of the $n$ rectangles in $O(n log n)$ time?

== Sweep Line

=== Basic Idea

1. Store rectangles x-intervals into an interval tree.
2. Sweep a vertical line from top to bottom.
3. At each event (left or right edge of a rectangle), update the interval tree based on the opening or closing of rectangles.
4. Calculate the area covered between two consecutive events using the interval tree to find the total height covered by the rectangles at that x-coordinate.
5. Sum the areas calculated between all consecutive events to get the total area of the union of rectangles.

=== Formal definition

Let $R = {R_1, R_2, ... R_n}$ be the set of rectangles, where each rectangle $R_i = [x_1, x_2] times [y_1, y_2]$.

Based on this construction, we can create a segment tree $T$ that stores the x-intervals of the rectangles as elementary intervals. Each node in the tree represents an interval and contains the span and a count of how many rectangles cover that interval.

#figure(
  caption: [Segment Tree for Rectangle Union],
  image("../assets/segment-tree-augmented.png")
)<segment-tree-augmented>

For our solution, we need to augment the interval tree $T$ to store, for each node, a count for how many active rectangles cover the interval represented by that node (children included) and their span. The purpose of this augmentation is to efficiently calculate the total height covered by the rectangles at any given x-coordinate during the sweep line process in $O(1)$ while maintaining a $O(log n)$time for updates. It's easy to see that the augmentation will not affect space complexity as it's only a constant.

Let's remark that the preprocessing time to build the interval takes $O(n log n)$ time while the space complexity is $O(n)$.

Firstly, we sort all the rectangles in descending order based on their x-coordinates in order to create a list $E = {e_1, e_2, ... e_(2n)}$ of events. At each event $e_i$, we either open or close a rectangle based on whether we encounter the left or right edge of a rectangle, therefore having two possible types of events:
- *Opening*: We query the segment tree $T$ to increase the y-interval of the rectangle being opened: starting from the root, we traverse down the tree to update the count of each node whose interval is included in the y-interval of the rectangle being opened. From this operation, we can have 3 different cases:
  1. The interval node is already fully opened by other rectangels (i.e. its span is equal to its interval length). In this case, we can only increase the count of the node and stop traversing down the tree.
  2. The interval node has only one child opened (count = 1). In this case, we increase the count of the node and update its span to match the total span of the interval.
  3. The node is not opened at all (count = 0). As before, we increase the count of the node and update the span.
  Another case is when the y-interval of the rectangle being opened is splitted across multiple nodes in the tree. In this case, we recursively traverse down both children of the node until we reach the leaves that fully cover the y-interval of the rectangle being opened, updating their counts and spans accordingly to the cases presented above.

  We finally conclude the opening operation with a cascade update of the spans back up to the root of the tree.

  Let's analyze the worst case time complexity of the opening operation. In the worst case, the maximum number of nodes we need to traverse down is bounded by the biggest subtree that covers the y-interval (see @fig:worst-case-segment-tree) in other words, the whole tree without the leftmost and rightmost paths. Moreover, from the proof of construction of the segment tree, we know that a segment can either cover and entire node or be splitted across its children. Thus, going down a level, the number of nodes visited is halved, as if the interval was splitted, one of the two children won't be visited resulting in a maximum of $4$ nodes being visited at each level.

#figure(
  caption: [Worst Case Interval Tree Traversal],
    image("../assets/worst-case-segment-tree.svg", width:4cm)
  )<fig:worst-case-segment-tree>

  Therefore, the whole exploration of this is bounded by $O(4 log n)$.

  Normally, this would not be possible as we would need to traverse all the nodes in the tree that sums up to the y-interval of the rectangle being opened. However, the optimization comes from the fact that we can use lazy propagation to update the tree: a node's count is valid only if its count is greater than zero, moreover we don't need to check its children.
- *Closing*: Operation symmetric to the Opening, also requiring $O(log n)$ time.

We can calculate the area covered between two consecutive events $e_i$ and $e_(i+1)$ by looking at the total height covered by the rectangles at the root of the interval tree $T$ and multiplying it by the width between the two events
$ A += "span"(T.root) dot (x_(i+1) - x_i) $.

// TODO: add pseudocode

=== Time Complexity Analysis

The final step is to check that the total time complexity sums up to $O(n log n)$:
1. Sorting the events takes $O(n log n)$ time.
2. Processing the segment tree for each of the $2n$ events takes $O(n log n)$ time.
3. For each event (total of $2n$), we perform an update operation on the interval tree, which takes $O(log n)$ time. Therefore resulting in a total of $O(n log n)$ time for all events.

Thus, the overall time complexity of the algorithm is $O(n log n)$, which meets the requirement.

== Divide and Conquer

The divide and conquer approach for computing the union of areas of $n$ rectangles involves a similar approach to the sweep line algorithm but uses recursion to break down the problem instead of iterating through the events. As we will see, this method achieves the same time and space complexity as it use the same data structures and basic idea behind it.

=== Basic Idea

The main idea is to recusrively divide the set of rectangles based on the median points of their x-coordinates, find the rectangles stabbed by the median line, open and close them in an interval tree, and then recursively compute the area for the left and right ones with the invariant that the intervals (and areas) defined by rectangles stabbed by the median line are already considered.

#figure(
  caption: [Divide and Conquer Area Computation Overview],
  image("../assets/divide-and-conquer-overview.png")
)<fig:divide-and-conquer-overview>

=== Formal definition

As before, we need to introduce an interval tree $T$ that stores the x-intervals of the rectangles in order to efficiently access them given a query point.

For the y-intervals, we will use a segment tree $S$ augmented that also uses lazy propagation as before. The augmentation needs to take account of the following propagation:
- How many rectangles are currently opened in the interval represented by the node.
- The total span covered by the rectangles in the interval represented by the node.
- The rightmost and leftmost coordinates of the x-interval of the last rectangle we used to update the node. This is needed to correctly add the extra area covered by a new rectangle being opened that extends beyond the previous one.


Let's now brake down the algorithm (see @lst:divide-and-conquer-area-computation for pseudocode):
The implementation is a recursive function `computeArea(R)` that takes as the set of rectangles. We will assume that the rectangles are sortedas it will not influence our computation time and that you can find the boundary in time $O(1)$ as the rectangles are sorted by their x-coordinates.

#figure(
caption: [Divide and Conquer Area Computation],
```pseudocode
// assume rectangles are sorted by x-coordinates
function computeArea(rectangles R):
  if R is empty:
    return 0
  
  let xm be the median x-coordinate of R
  
  let stabbed = query(T, xm) // rectangles stabbed by the vertical line x = xm

  let area = 0
  for each rectangle r in stabbed:
    adjustSegmentTree(S, r) // open/close rectangles in S and update area accordingly
    area += extraAreaAdded(S, r, OPEN)
  
    let L = {rectangles in R with x2 < xm}
    area += computeArea(L)

    adjustSegmentTree(S, r, CLOSE) // close rectangle r in S
    let R = {rectangles in R with x1 > xm}
    area += computeArea(R)
  return area
```
)<lst:divide-and-conquer-area-computation>

Let's discuss the `adjustSegmentTree(S, r)` function used to open/close rectangles in the segment tree $S$ and update the area accordingly (see @fig:divide-and-conquer-segment-tree-adjustment) as it is the core of the algorithm and the less trivial part.

When opening a rectangle $r = [x_1, x_2] times [y_1, y_2]$, we need to traverse the segment tree $S$ to update the nodes whose intervals are included in the y-interval of the rectangle being opened. As before, because of lazy propagation, we can avoid traversing the whole tree while updating the propagation value to the top nodes.

#figure(
  caption: [Adjusting Segment Tree for Rectangle Opening],
    image("../assets/recursion-example.png")
)<fig:divide-and-conquer-segment-tree-adjustment>


#figure(
  caption: [Analyzing Extra Area Added by Rectangle],
```pseudocode
function extraAreaAdded(segmentTree S, rectangle r, enum {OPEN, CLOSE} contributingType):
  let (x1, x2) = (r.x1, r.x2)
  let (y1, y2) = (r.y1, r.y2)
  
  let extraArea = 0
  // Traverse the segment tree to calculate the extra area added
  for each node n in S that overlaps with [y1, y2]:
    if n is fully covered by [y1, y2]:
      let span = n.span
      let leftBoundary = n.leftmostX
      let rightBoundary = n.rightmostX
      
      // we want to take the rectangle part that extends beyond the previous one
      x1 = max(x1, rightBoundary) if contributingType == OPEN else min(x1, leftBoundary)
      x2 = max(x2, rightBoundary) if contributingType == OPEN else min(x2, leftBoundary)
      extraArea += span * (x2 - x1)
  
  return extraArea
```
)<fig:divide-and-conquer-extra-area-analysis>
