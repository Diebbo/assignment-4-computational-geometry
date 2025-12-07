= Area computation
How to find the union of the areas of the $n$ rectangles in $O(n log n)$ time?

== Sweep Line

=== Basic Idea

1. Store rectangles y-intervals into a segment tree.
2. Sweep a vertical line from left to right.
3. At each event (left or right edge of a rectangle), update the segment tree based on the opening or closing of rectangles.
4. Calculate the area covered between two consecutive events using the segment tree to find the total height covered by the rectangles at that x-coordinate.
5. Sum the areas calculated between all consecutive events to get the total area of the union of rectangles.

=== Formal definition

==== Propagation Segment Tree

Given a segment tree $T$, we can augment it to support propagation for range updates. If a range update operation adds a tag on a node to denote that it's been opened, we can assume that the propagation affects the children of the node as well (see @fig:propagation-segment-tree-update).

#figure(
  caption: [Propagation Segment Tree Update],
    image("../assets/propagation-segment-tree-update.png", width:10cm)
)<fig:propagation-segment-tree-update>

Let's analyze how to implement the propagation for our segment tree (see @lst:propagation-segment-tree for the pseudocode):
- Given a node $v$ in the segment tree, we can store an addition tag that indicates how many rectangles are active in the interval represented by $v$
- When inserting rectangles, we can update the addition tag of the nodes that fully cover the y-interval of the rectangle being opened.
- We also need to propagate total span size to the parent nodes when updating the children nodes.

#figure(
  caption: [Segment Tree with Propagation],
```
function activateNode(segmentTree node, interval delta):
  check node is not a leaf

  if n.span fully covers delta:
    // increment the count of active rectangles
    if node.count == 0:
      node.count += 1
      node.span = node.intervalLength
      return node.span
    else:
      node.count += 1
      return 0 // no need to update span as it's already fully opened
  else:
    // check the children
    if delta to the left of node
      node.span += activateNode(node.leftChild, delta)
    if delta to the right of node
      node.span += activateNode(node.rightChild, delta)
    return node.span
```)<lst:propagation-segment-tree>

Of course, we can implement a symmetric function `deactivateNode` to close rectangles in the segment tree.

==== Main Algorithm

Let $R = {R_1, R_2, ... R_n}$ be the set of rectangles, where each rectangle $R_i = [x_1, x_2] times [y_1, y_2]$.

Based on this construction, we can create a segment tree $T$ that stores the y-intervals of the rectangles as elementary intervals. Each node in the tree represents an interval and contains the span and a count of how many rectangles cover that interval (see @fig:segment-tree-augmented).
#figure(
  caption: [Segment Tree for Rectangle Union],
  rotate(-90deg, image("../assets/segment-tree-augmented.png", width:8cm), reflow: true)
)<fig:segment-tree-augmented>

For our solution, we need to augment the segment tree $T$ to store, for each node, a count for how many active rectangles cover the interval represented by that node (children included) and their span. The purpose of this augmentation is to efficiently calculate the total height covered by the rectangles at any given x-coordinate during the sweep line process in $O(1)$ while maintaining $O(log n)$ time for updates. It's easy to see that the augmentation will not affect space complexity as it's only a constant.

Let's remark that the preprocessing time to build the interval takes $O(n log n)$ time while the space complexity is $O(n)$.

Firstly, we sort all the rectangles in ascending order based on their x-coordinates in order to create a list $E = {e_1, e_2, ... e_(2n)}$ of events. At each event $e_i$, we either open or close a rectangle based on whether we encounter the left or right edge of a rectangle, therefore having two possible types of events:
- *Opening*: We query the segment tree $T$ to increase the y-interval of the rectangle being opened: starting from the root, we traverse down the tree to update the count of each node whose interval is included in the y-interval of the rectangle being opened. From this operation, we can have 3 different cases:
  1. The interval node is already fully opened by other rectangles (i.e. its span is equal to its interval length). In this case, we can only increase the count of the node and stop traversing down the tree.
  2. The interval node has only one child opened (count = 1). In this case, we increase the count of the node and update its span to match the total span of the interval.
  3. The node is not opened at all (count = 0). As before, we increase the count of the node and update the span.
  Another case is when the y-interval of the rectangle being opened is split across multiple nodes in the tree. In this case, we recursively traverse down both children of the node until we reach the leaves that fully cover the y-interval of the rectangle being opened, updating their counts and spans accordingly to the cases presented above.

  We finally conclude the opening operation with a cascade update of the spans back up to the root of the tree.

  Let's analyze the worst case time complexity of the opening operation. In the worst case, the maximum number of nodes we need to traverse down is bounded by the biggest subtree that covers the y-interval (see @fig:worst-case-segment-tree) in other words, the whole tree without the leftmost and rightmost paths. Moreover, from the proof of construction of the segment tree, we know that a segment can either cover an entire node or be split across its children. Thus, going down a level, the number of nodes visited is halved, as if the interval was split, one of the two children won't be visited resulting in a maximum of $4$ nodes being visited at each level.

// set figure width to 10cm
#figure(
  caption: [Worst Case Segment Tree Traversal],
    image("../assets/worst-case-segment-tree.png", width:10cm)
  )<fig:worst-case-segment-tree>

  Therefore, the whole exploration of this is bounded by $O(4 log n)$.

  Normally, this would not be possible as we would need to traverse all the nodes in the tree that sum up to the y-interval of the rectangle being opened. However, the optimization comes from the fact that we can use propagation to update the tree: a node's count is valid only if its count is greater than zero, moreover we don't need to check its children.
- *Closing*: Operation symmetric to the Opening, also requiring $O(log n)$ time.

We can calculate the area covered between two consecutive events $e_i$ and $e_(i+1)$ by looking at the total height covered by the rectangles at the root of the segment tree $T$ and multiplying it by the width between the two events
$ A += "span"(T.root) dot (x_(i+1) - x_i) $.

For the algorithm see @lst:sweep-line-area-computation.

#figure(
  caption: [Sweep Line Area Computation],
```pseudocode
function computeAreaSweep(rectangles R):
  let events E = []
  for each rectangle r in R:
    E.append((r.x1, OPEN, r.y1, r.y2))
    E.append((r.x2, CLOSE, r.y1, r.y2))

  sort E by x-coordinate

  let segmentTree T = buildSegmentTree(y-intervals of R)

  let totalArea = 0
  for i from 0 to length(E) - 2:
    let (x, type, y1, y2) = E[i]
    if type == OPEN:
      activateNode(T.root, [y1, y2])
    else if type == CLOSE:
      deactivateNode(T.root, [y1, y2])

    let nextX = E[i + 1].x
    let width = nextX - x
    let height = T.root.span
    totalArea += height * width

  return totalArea

```)<lst:sweep-line-area-computation>

=== Time Complexity Analysis

The final step is to check that the total time complexity sums up to $O(n log n)$:
1. Sorting the events takes $O(n log n)$ time.
2. Processing the segment tree for each of the $2n$ events takes $O(n log n)$ time.
3. For each event (total of $2n$), we perform an update operation on the segment tree, which takes $O(log n)$ time. Therefore resulting in a total of $O(n log n)$ time for all events.

Thus, the overall time complexity of the algorithm is $O(n log n)$, which meets the requirement.

== Divide and Conquer

The divide and conquer approach for computing the union of areas of $n$ rectangles involves a similar approach to the sweep line algorithm but uses recursion to break down the problem instead of iterating through the events. As we will see, this method achieves the same time and space complexity as it uses the same data structures and basic idea behind it.

=== Basic Idea

The main idea is to recursively divide the set of rectangles based on the median points of their x-coordinates, find the rectangles stabbed by the median line, open or close them respectively in the interval tree, and then recursively compute the area for the left and right sets with the invariant that the intervals (and areas) defined by rectangles stabbed by the median line are already considered.

#figure(
  caption: [Divide and Conquer Area Computation Overview],
  image("../assets/divide-and-conquer-overview.png", width: 10cm)
)<fig:divide-and-conquer-overview>

=== Formal definition

To implement this algorithm, we will use two data structures: an interval tree and a segment tree with propagation.

The interval tree $T$ will store the number of rectangles stabbed by a vertical line at a given x-coordinate. The purpose of this tree is to efficiently find all rectangles that are stabbed by the median line at each recursive step. We will assume that the query returns in $O(log n + k)$ time the rectangles stabbed by the vertical line in ascending or descending order based on the closing or opening x-coordinates.

For the y-intervals, we will use a segment tree $S$ augmented that also uses propagation as before. The augmentation needs to take account of the following propagation:
- How many rectangles are currently opened in the interval represented by the node.
- The total span covered by the rectangles in the interval represented by the node.
- The rightmost and leftmost coordinates of the x-interval of the last rectangle we used to update the node. This is needed to correctly add the extra area covered by a new rectangle being opened that extends beyond the previous one.


Let's now break down the algorithm (see @lst:divide-and-conquer-area-computation for pseudocode):
The implementation is a recursive function `computeArea(R)` that takes as input the set of rectangles.

If there are any rectangles in the set, we find the median x-coordinate $x_m$ and query the interval tree $T$ to find all rectangles stabbed by the vertical line $x = x_m$. The query will return the result in both ascending and descending order based on the closing and opening x-coordinates respectively (accessed by `stabbed` and `stabbed.reversed` in the pseudocode).

The key observation is that once we compute the area contributed by the rectangles stabbed by the median line, we can safely remove them from the set of rectangles and consider their boundary as the new boundaries for the left and right recursive calls.

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
    adjustSegmentTree(S, r, OPEN)
  area += extraAreaAdded(S, r, OPEN, xm)

  let Rl = {rectangles in R with x2 < xm}
  area += computeArea(Rl)

  for each rectangle r in stabbed.reversed:
    adjustSegmentTree(S, r, CLOSE)

  let Rr = {rectangles in R with x1 > xm}
  area += computeArea(Rr)

  return area
```
)<lst:divide-and-conquer-area-computation>

Let's discuss the `adjustSegmentTree(S, r)` function used to open/close rectangles in the segment tree $S$ and update the area accordingly (see @fig:divide-and-conquer-segment-tree-adjustment) as it is the core of the algorithm and the least trivial part.

When opening a rectangle $r = [x_1, x_2] times [y_1, y_2]$, we need to traverse the segment tree $S$ to update the nodes whose intervals are included in the y-interval of the rectangle being opened. As before, because of propagation, we can avoid traversing the whole tree while updating the propagation value to the top nodes.

#figure(
  caption: [Adjusting Segment Tree for Rectangle Opening],
    image("../assets/recursion-example.png", width:10cm)
)<fig:divide-and-conquer-segment-tree-adjustment>

Finally, let's briefly explain the `extraAreaAdded` function used to calculate the extra area added by a rectangle being opened or closed (see @fig:divide-and-conquer-extra-area-analysis). The idea is to traverse the segment tree $S$ to find the nodes whose intervals are fully covered by the y-interval of the rectangle being opened/closed. For each of these nodes, we calculate the extra area added by the rectangle based on its x-interval and the boundaries stored in the node.

#figure(
  caption: [Analyzing Extra Area Added by Rectangle],
```pseudocode
function extraAreaAdded(segmentTree S, rectangle r, enum {OPEN, CLOSE} contributingType, xm):
  let (x1, x2) = (r.x1, r.x2)
  let (y1, y2) = (r.y1, r.y2)

  let extraArea = 0
  // Traverse the segment tree to calculate the extra area added
  for each node n in S that overlaps with [y1, y2]:
    if n is fully covered by [y1, y2]:
      let span = n.span
      // we introduce the boundary of the x median line xm as it's the invariant of the algorithm
      let leftBoundary = n.leftmostX if contributingType == CLOSE else min(n.leftmostX, xm)
      let rightBoundary = n.rightmostX if contributingType == CLOSE else max(n.rightmostX, xm)

      // we want to take the rectangle part that extends beyond the previous one
      x1 = max(x1, rightBoundary) if contributingType == OPEN else min(x1, leftBoundary)
      x2 = max(x2, rightBoundary) if contributingType == OPEN else min(x2, leftBoundary)
      extraArea += span * (x2 - x1)

  return extraArea
```
)<fig:divide-and-conquer-extra-area-analysis>

=== Time Complexity Analysis

The time complexity analysis of the divide and conquer algorithm is as follows:
1. The initial sorting of rectangles takes $O(n log n)$ time.
2. Each recursive call processes a subset of rectangles, and at each level of recursion, we perform the following operations:
    - Querying the interval tree to find stabbed rectangles takes $O(log n + k)$ time, where $k$ is the number of stabbed rectangles.
    - Adjusting the segment tree for each stabbed rectangle takes $O(k log n)$ time in total.
    - Calculating the extra area added by each stabbed rectangle also takes $O(k log n)$ time in total.
3. The depth of the recursion is $O(log n)$, as we estimate to divide the set of rectangles in half at each step.

Following the formula for the total time complexity $T(n)$:
$
T(n) = 2T(n/2) + O(k_i log c)
$
Where $k_i$ is the number of rectangles stabbed at the $i$-th level of recursion, $k_i >= 1$ and $sum_i k_i = 2n$.


$
sum_(i=0)^(log n) O(k_i log n) = O(log n) dot sum_(i=0)^(log n) O(k_i) \
= O(log n) dot O(n) = O(n log n)
$

Combining these factors, the overall time complexity of the divide and conquer algorithm is $O(n log n)$, which meets the requirement.

*Space*: The space complexity is dominated by the segment tree, which uses $O(n log n)$. Also the recursion stack uses $O(log n)$ space a segment (stabbed rectangles are not stored as we process them immediately). Thus, the overall space complexity is still bounded to $O(n log n)$.
