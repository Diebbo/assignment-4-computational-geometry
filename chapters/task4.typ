#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/ctheorems:1.1.3": thmrules, thmbox
#import "@preview/lovelace:0.3.0": *

#import "figures/redundant-interval.typ": *

#show: thmrules.with(qed-symbol: $square$)
#set heading(numbering: "1.1.")

#let definition = thmbox("definition", "Definition", inset: (x: 0em, top: 0em), base_level: 1)
#let lemma = thmbox("lemma", "Lemma", inset: (x: 0em, top: 0em), base_level: 1)

= Weighted Point-Line Query via Dual Space

== Problem Statement

*Input:* A query line $ell$, and a set $P = {p_1, p_2, ..., p_n}$ of $n$ points in $bb(R)^2$,
where each point $p_i = (x_i, y_i)$ has an associated weight $w(p_i) in bb(R)$.

*Output:* The point $p^* in P$ with maximum weight among all points lying above the line $ell$.

== Reduction to a _point location_ problem

We use the standard point-line duality to transform the problem into dual space:
- $p_i = (x_p, y_p) |-> p_i^* : y = x_p x - y_p$.
- $ell : y = m x + b |-> ell^* = (m, -b)$.

Recall the Duality property, which states that a primal point $p$
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
  caption: "Two intersecting lines with redundant intervals.",
  redundant-interval,
)<fig:redundant-interval>

== Solution of the point location problem

There exist various solutions to the point location problem
for finite planar subdivisions that use $O(log n)$ time and $O(n)$ space.
Since it seemed to us like the simplest,
we chose to use the _triangulation refinement_ algorithm @kirkpatrick83.
Before describing the algorithm, we need the following lemma.

#lemma[
  For every planar graph with $n >= 3$ vertices it is possible
  to find at least $n slash 24$ independent vertices in polynomial time. \
  *Proof*:
  It is a well-known fact that a planar graph with $n$
  vertices has at most $3 n - 6$ edges.
  This means that the average vertex degree is 6,
  which in turn means fewer than half of the vertices have
  a degree that is higher than 11.
  It is then possible to build in linear time the set of vertices
  with degree not exceeding 11.
  Then, a simple algorithm can remove all of the vertices
  that are adjacent to another vertex already in the set.
  $square$
] <lemma:find-independent>

Now we can start with the description of the algorithm.
The first step is to run a polygon
triangulation algorithm for each of the regions.
Let $S_0$ be the resulting graph.

Find a set of $V$ independent vertices of $S_i$
using the steps outlined by @lemma:find-independent.
Remove each $v_(i,j) in V_i$ that is not a boundary point from $S_i$.
Each hole can then be re-triangulated with the introduction of $deg(v_(i,j)) - 3$ edges.
Annotate each of the added triangles with pointers to the triangles it replaced.
Lastly, let $S_(i+1)$ be the resulting graph.
Repeat the previous steps until the only vertices left in $S_i$
are the four vertices on the boundary of the region.

Notice how, after each removal step, there are at most $23 / 24 |S_i|$ vertices left.
From this fact it trivially follows that the number of steps
will be at most $h(n) = log_(24 slash 23) |S_0| = log_(24 slash 23) n$.
Additionally, the total storage space is bounded by the following geometric series:
$
  sum_(i=0)^h(n) |S_i| <
  sum_(i=0)^h(n) (23/24)^i |S_0| =
  |S_0| sum_(i=0)^h(n) (23/24)^i
$
which converges to $O(n)$.

A simple algorithm for querying point $p$ in the resulting structure
(in $O(log(n))$ time) would be the following:

#align(center, pseudocode-list(title: [Algorithm QueryPoint(p)], booktabs: true)[
  + $"Candidates"_h(n) <- "regions of" S_h(n)$
  + $R <- "region in Candidates"_h(n) "containing" p$
  + $i <- h(n) - 1$
  + *while* $i > 0$
    + $"Candidates"_i <- "parents"(R)$
    + $R <- "region in Candidates"_i "containing" p$
    + $i <- i-1$
  + *return* R
])
