#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/ctheorems:1.1.3": *

#import "figures/redundant-interval.typ": *

#show: thmrules.with(qed-symbol: $square$)
#set heading(numbering: "1.1.")

#let definition = thmbox("definition", "Definition", inset: (x: 0em, top: 0em), base_level: 1)

= Weighted Point-Line Query via Dual Space

== Problem Statement

*Input:* A query line $ell$, and a set $P = {p_1, p_2, ..., p_n}$ of $n$ points in $bb(R)^2$,
where each point $p_i = (x_i, y_i)$ has an associated weight $w(p_i) in bb(R)$.

*Output:* The point $p^* in P$ with maximum weight among all points lying above the line $ell$.

== Reduction to a _point location_ problem

We use the standard point-line duality to transform the problem into dual space:
- $p_i = (x_p, y_p) |-> p_i^* : y = x_p x - y_p$.
- $ell : y = m x + b |-> ell^* = (m, -b)$.

Recall the Duality property, that states that a primal point $p$
lies above a primal line $ell$ if and only if
the dual point $ell^*$ lies above the dual line $p^*$.
Therefore, the problem becomes to find the dual line $p_i^*$
with maximum weight $w(p_i)$ such that the dual point $ell^*$ lies above $p_i^*$.

Notice how, if lines are sorted by decreasing weight,
any portion of a line $ell_j$ that lies below a higher-weight line $ell_i$ (where $i < j$)
can be discarded, as it will never contribute to the maximum weight query.
Consider, for example, two intersecting lines $ell_1$ and $ell_2$
with $w(ell_1) > w(ell_2)$ that intersect at point $(x_0, y_0)$.
The line $ell_2$ has a redundant interval $[-inf, x_0)$
if it has higher slope than $ell_1$,
or $[x_0, inf)$ otherwise (see @fig:redundant-interval).
Let us formalize this concept:

#definition[
  Given two lines $ell_i, ell_j$ with weights $w_i > w_j$,
  an interval $I subset.eq bb(R)$ is _redundant_ for line $ell_j$
  if $ell_i (x) > ell_j (x)$ for all $x in I$.
]

We can, without loss of generality, assume that all queries
will be located in a finite region of the space $[r_x, r_y] times [R_x, R_y]$.
Within this finite region, the non-redundant part of the lines $ell^*$
will form a _finite planar subdivision_.
Furthermore, each of the regions of the plane will be adjacent to the
segment with the highest weight that is above said region
(this is by construction, since we used only the non-redundant parts of the lines).
Thus, we can label each region with the highest weight
of the lines that lie above it.

Thus, we have reduced the given problem to the problem
of locating a point on a planar graph.

#figure(
  caption: "Two intersecting lines with redundant intervals. TODO: Improve",
  redundant-interval,
)<fig:redundant-interval>

== Solution of the point location problem

TODO
