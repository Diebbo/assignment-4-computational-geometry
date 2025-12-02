= Questions
Given a set $P$ of $n$ points in the plane, each associated with a weight ($w(p_i))$), and a line $ell$, find the point with the maximum weight above the line.

Idea:
- map to the dual space. $p_i : (x_p, y_p) -> p* : y = x_p x - y_p$ and $ell : y = m x + b -> ell* : (m, -b)$
- in the dual space, the problem becomes finding the line with the maximum weight below the point $ell*$

Precomputing phase (time unbounded):
- sort the lines $p*$ by slope
- build a data structure for planar point location on the arrangement of lines $p*$, where each line $p*$ has an associated weight $w(p_i)$
- at each face of the arrangement, store the maximum weight of the lines bounding that face


Query phase (must be in $O(log n)$ time):
- given the line $ell$, compute its dual point $ell*$
- perform a point location query in the arrangement to find the face containing $ell*$
- return the maximum weight stored at that face


Space complexity bounded to $O(n)$ space.


How to build the data structure in the precomputing phase using only $O(n)$ space:
