= Question
How to find the union of the areas of the $n$ rectangles in $O(n log n)$ time?

== Answer Sweep Line

==== Basic Idea

1. Store rectangles x-intervals into an interval tree.
2. Sweep a vertical line from top to bottom.
3. At each event (left or right edge of a rectangle), update the interval tree based on the opening or closing of rectangles.
4. Calculate the area covered between two consecutive events using the interval tree to find the total height covered by the rectangles at that x-coordinate.
5. Sum the areas calculated between all consecutive events to get the total area of the union of rectangles.

==== Formal definition

Let $R = {R_1, R_2, ... R_n}$ be the set of rectangles, where each rectangle $R_i = [x_1, x_2] times [y_1, y_2]$.

Based on this construction, we can create an interval tree $T$ that stores the x-intervals of the rectangles as elementary intervals. Each node in the tree represents an interval and contains the span and a count of how many rectangles cover that interval.

For our solution, we need to augment the interval tree $T$ to store, for each node, a count of how manu active rectangles cover the interval represented by that node. The purpose of this augmentation is to efficiently calculate the total height covered by the rectangles at any given x-coordinate during the sweep line process. It's easy to see that the augmentation will not affect space complexity as it's only a constant.

Let's remark that the preprocessing time to build the interval takes $O(n log n)$ time while the space complexity is $O(n)$.

Next, we sort all the rectangles in descending order based on their x-coordinates in order to create a list $E = {e_1, e_2, ... e_(2n)}$ of events. At each event $e_i$, we either open or close a rectangle based on whether we encounter the left or right edge of a rectangle, therefore having two possible types of events:
- *Opening*: We query the interval tree $T$ to increase the y-interval of the rectangle being opened, requiring $O(log n)$ time. Normally, this would not be possible as we would need to traverse all the nodes in the tree that sums up to the y-interval of the rectangle being opened. However, the optimization comes from the fact that we can use lazy propagation to update the tree: a node's count is valid only if its count is greater than zero, moreover we don't need to check its children.
- *Closing*: We query the interval tree $T$ to decrease the y-interval of the rectangle being closed, also requiring $O(log n)$ time.

We can calculate the area covered between two consecutive events $e_i$ and $e_(i+1)$ by looking at the total height covered by the rectangles at the root of the interval tree $T$ and multiplying it by the width between the two events 
$ A += "span"(T.root) *  (x_(i+1) - x_i) $.

// TODO: add pseudocode

==== Time Complexity Analysis

The final step is to check that the total time complexity sums up to $O(n log n)$:
1. Sorting the events takes $O(n log n)$ time.
2. Processing the segment tree for each of the $2n$ events takes $O(n log n)$ time.
3. For each event (total of $2n$), we perform an update operation on the interval tree, which takes $O(log n)$ time. Therefore resulting in a total of $O(n log n)$ time for all events.

Thus, the overall time complexity of the algorithm is $O(n log n)$, which meets the requirement.

