#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot

= Weighted Point-Line Query via Dual Space

== Problem Statement

*Input:* A set $P = {p_1, p_2, ..., p_n}$ of $n$ points in $bb(R)^2$, where each point $p_i = (x_i, y_i)$ has an associated weight $w(p_i) in bb(R)$, and a query line $ell$.

*Output:* The point $p^* in P$ with maximum weight among all points lying above the line $ell$.

== Geometric Duality Transform

We use the standard point-line duality to transform the problem into dual space:
- $p_i = (x_p, y_p) --> p_i^* : y = x_p x - y_p$.

- $ell : y = m x + b --> ell^* = (m, -b)$.

We also recall the Duality property that states: A primal point $p$ lies above a primal line $ell$ if and only if the dual point $ell^*$ lies above the dual line $p^*$.

Therefore, the problem transforms to: find the dual line $p_i^*$ with maximum weight $w(p_i)$ such that the dual point $ell^*$ lies above $p_i^*$.

== Useless Intervals

*Definition:* Given two lines $ell_i, ell_j$ with weights $w_i > w_j$, an interval $I subset.eq bb(R)$ is *useless* for line $ell_j$ if $ell_i(x) > ell_j(x)$ for all $x in I$.

*Observation:* If lines are sorted by decreasing weight, any portion of a line $ell_j$ that lies below a higher-weight line $ell_i$ (where $i < j$) can be discarded, as it will never contribute to the maximum weight query.

Consider two intersecting lines $ell_1$ and $ell_2$ with $w(ell_1) > w(ell_2)$ that intersect at point $(x_0, y_0)$. The line $ell_2$ has a useless interval $[-inf, x_0)$ if it lies below $ell_1$ (see @fig:useless-interval).

#figure(
  caption: "Two intersecting lines with useless intervals",
canvas({
  draw.set-style(axes: (
    y: (label: (offset: 1), mark: (end: "stealth", fill: black)),
    x: (mark: (end: "stealth", fill: black)),
  ))
  plot.plot(
    size: (8, 5),
    x-label: $x$,
    y-tick-step: 4,
    x-tick-step: 4,
    x-grid: true,
    y-grid: true,
    legend-style: (stroke: .5pt),
    axis-style: "left",
    {
      // Parameters for the two lines
      let m = 1
      let q = -1
      let x-intersect = 4  // Adjust this to set where the lines cross

      // First intersecting line: y = mx + q (solid before intersection, dotted after)
      plot.add(
        style: (stroke: green + 1.5pt),
        label: "l2",
        domain: (x-intersect, 8),
        x => m * x + q,
      )
      plot.add(
        style: (stroke: (paint: green, thickness: 1.5pt, dash: "dotted")),
        label: "l2 useless",
        domain: (-8, x-intersect),
        x => m * x + q,
      )

      // Second intersecting line: y = -mx + q' (solid throughout)
      // Calculate q' so the lines intersect at x-intersect
      let y-intersect = m * x-intersect + q
      let q-prime = y-intersect + m * x-intersect

      plot.add(
        style: (stroke: purple + 1.5pt),
        domain: (-8, 8),
        label: "l1",
        x => -m * x + q-prime,
      )
    },
  )
})
)<fig:useless-interval>

== Upper Envelope Construction

*Definition:* The *Upper Envelope* $cal(E)$ of a set of lines ${ell_1^*, ell_2^*, ..., ell_n^*}$ is the pointwise maximum function:
$ cal(E)(x) = max_(i=1,...,n) ell_i^*(x) $

After removing useless intervals, the Upper Envelope consists of a sequence of line segments from different lines, forming a piecewise-linear, convex function.

*Proposition:* Given $n$ lines sorted by decreasing weight, the Upper Envelope after removing useless intervals contains $O(n)$ vertices (intersection points).

*Proof sketch:* Each line appears at most once in the Upper Envelope because we process lines in order of decreasing weight. A line $ell_i$ can only dominate (lie above) lines with higher weight. Once a line enters the envelope, it remains until intersected by another line of lower weight. Since each line contributes at most one contiguous segment, there are at most $n-1$ transition points between segments. $square$

== Query Algorithm

*Preprocessing phase:*
1. Sort lines ${ell_1^*, ..., ell_n^*}$ by decreasing weight: $w(ell_1) gt.eq w(ell_2) gt.eq ... gt.eq w(ell_n)$
2. Compute all pairwise intersections between consecutive lines in the sorted order
3. For each intersection, identify and remove useless intervals
4. Construct the Upper Envelope $cal(E)$ from the remaining active segments
5. Build a Binary Space Partition (BSP) tree on the $O(n)$ vertices of $cal(E)$

*Query phase:*
Given a query point $ell^* = (m, -b)$:
1. Use the BSP tree to locate the slab (region) containing $x$-coordinate $m$ in $O(log n)$ time
2. Evaluate which line segment of $cal(E)$ is active at $x = m$
3. Return the weight associated with that line segment

*Complexity:*
- Preprocessing: $O(n log n)$ for sorting, $O(n)$ for envelope construction
- Query: $O(log n)$ per query

#figure(
  caption: "Upper Envelope of multiple lines",
  canvas({
    draw.set-style(axes: (
      y: (label: (offset: 1), mark: (end: "stealth", fill: black)),
      x: (mark: (end: "stealth", fill: black)),
    ))
    plot.plot(
      size: (8, 5),
      x-label: $x$,
      y-tick-step: 2,
      x-tick-step: 2,
      x-grid: true,
      y-grid: true,
      y-max:12,
      y-min:-2,
axis-style: "school-book",
    {
        // Define the 4 points on the Upper Envelope
        let p1 = (0, 8)
        let p2 = (3, 3)
        let p3 = (5, 4)
        let p4 = (7, 8)

        // Calculate line parameters (y = mx + q) for each segment
        // Line 1: through p1 and p2
        let m1 = (p2.at(1) - p1.at(1)) / (p2.at(0) - p1.at(0))
        let q1 = p1.at(1) - m1 * p1.at(0)  // 5 - 1*1 = 4

        let m2 = (p3.at(1) - p2.at(1)) / (p3.at(0) - p2.at(0))
        let q2 = p2.at(1) - m2 * p2.at(0)

        // Line 3: through p3 and p4
        let m3 = (p4.at(1) - p3.at(1)) / (p4.at(0) - p3.at(0))
        let q3 = p3.at(1) - m3 * p3.at(0)
        /* x coordinate of intersection between l1 and l3 */
        let int_blue_green = (q3 - q1) / (m1 - m3)


        // Draw complete lines as dotted (full extent)
        plot.add(
          style: (stroke: (paint: blue, thickness: 1pt, dash: "dotted")),
          domain: (-2, 8),
          label: "l1",
          x => m1 * x + q1,
        )

        plot.add(
          style: (stroke: (paint: red, thickness: 1pt, dash: "dotted")),
          domain: (p2.at(0), 8),
          label: "l2",
          x => m2 * x + q2,
        )

        plot.add(
          style: (stroke: (paint: green, thickness: 1pt, dash: "dotted")),
          domain: (/* intersection of l1 and l3 */
            int_blue_green
        , 8),
          label: "l3",
          x => m3 * x + q3,
        )

        // Draw the Upper Envelope segments as thick solid lines
        // Segment 1: from p1 to p2
        plot.add(
          style: (stroke: blue + 2.5pt),
          domain: (-2, p2.at(0)),
          x => m1 * x + q1,
        )

        // Segment 2: from p2 to p3
        plot.add(
          style: (stroke: red + 2.5pt),
          domain: (p2.at(0), p3.at(0)),
          x => m2 * x + q2,
        )

        // Segment 3: from p3 to p4
        plot.add(
          style: (stroke: green + 2.5pt),
          domain: (p3.at(0), 8),
          x => m3 * x + q3,
        )
      },
    )
  })
)
