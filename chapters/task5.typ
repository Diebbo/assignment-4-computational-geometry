#import "@preview/cetz:0.4.2"

#let Conv="Conv"

= Minkowski Sum
#let pc = $plus.o$
Let $A pc B$ the Minkowski sum of two sets $A, B in RR^2$, defined as $A pc B := {a + b | a in A, b in B }$.

==

If $P$ is a simple polygon then $P xor Conv(P)$ is convex, where $Conv(P)$ is the convex hull of $P$.

*Solution*

Let's denote $q in Q$. Therefore, we want to show that $q = lambda p' + (1 - lambda) p''$ for some $p', p'' in P$ and $lambda in [0, 1]$.

We will denote $p' in P := a + A$ (a linear combination of a vertex of $P$ and $Q$; the upper case denotes the more stronger clause of being convex) and $p'' in P := b + B$.

By plugging in the definitions we have:
$
q = lambda (a + A) + (1 - lambda) (b + B) = \ lambda a + (1 - lambda) b + lambda A + (1 - lambda) B = \ u + w
$

From the definition of convex hull of a concave polygon, we know that $lambda a + (1 - lambda) b in Conv(P)$ as well, but is not always true for the other case. In order to overcome this problem, we observe that we can rewrite the equation above, considering the middle point between $u$ and $w$:
$
q = u + w = 2 v, quad v = (u + w)/2
$

Therefore, the problem reduces to show that $v in P pc Conv(P)$.

Now we encounter our first problem: the tow points may be separated by an edge of the polygon. // (see <fig:concavity-separation>).
#import "@preview/cetz:0.4.2": canvas, draw, tree

#import "@preview/cetz:0.4.2": canvas, draw

= Proof Diagrams

#figure(
  caption: "Two points u and w separated by a concave edge of the polygon.",
  canvas(length: 1cm, {
    import draw: *

    // Draw the concave polygon
    line((0, 0), (4, 0), stroke: (thickness: 1.5pt, paint: blue))
    line((4, 0), (5, 1.5), stroke: (thickness: 1.5pt, paint: blue))
    line((5, 1.5), (4.5, 3), stroke: (thickness: 1.5pt, paint: blue))
    line((4.5, 3), (3, 2.5), stroke: (thickness: 1.5pt, paint: red)) // concave edge
    line((3, 2.5), (1.5, 3), stroke: (thickness: 1.5pt, paint: blue))
    line((1.5, 3), (0, 2), stroke: (thickness: 1.5pt, paint: blue))
    line((0, 2), (0, 0), stroke: (thickness: 1.5pt, paint: blue))

    // Mark points u and w
    circle((1, 1.2), radius: 0.08, fill: green, stroke: green)
    content((1, 1.2), anchor: "south", padding: 0.15, text(fill: green)[*u*])

    circle((3.5, 1.8), radius: 0.08, fill: green, stroke: green)
    content((3.5, 1.8), anchor: "south", padding: 0.15, text(fill: green)[*w*])

    // Draw dashed line connecting them through the concave region
    line((1, 1.2), (3.5, 1.8), stroke: (dash: "dashed", paint: gray))

    // Mark the midpoint v
    circle((2.25, 1.5), radius: 0.08, fill: purple, stroke: purple)
    content((2.25, 1.5), anchor: "north", padding: 0.15, text(fill: purple)[*v*])

    // Highlight the concave edge
    content((3.75, 2.7), text(fill: red, size: 9pt)[concave edge])

    // Add label for polygon
    content((2.5, 0.3), text(size: 10pt)[Polygon P])
  })
)<fig:concavity-separation>

#figure(
  caption: "The line segment s intersecting the polygon, showing the shift from (u,w) to (u',w').",
  canvas(length: 1cm, {
    import draw: *

    // Draw the same concave polygon
    line((0, 0), (4, 0), stroke: (thickness: 1.5pt, paint: blue))
    line((4, 0), (5, 1.5), stroke: (thickness: 1.5pt, paint: blue))
    line((5, 1.5), (4.5, 3), stroke: (thickness: 1.5pt, paint: blue))
    line((4.5, 3), (3, 2.5), stroke: (thickness: 1.5pt, paint: red))
    line((3, 2.5), (1.5, 3), stroke: (thickness: 1.5pt, paint: blue))
    line((1.5, 3), (0, 2), stroke: (thickness: 1.5pt, paint: blue))
    line((0, 2), (0, 0), stroke: (thickness: 1.5pt, paint: blue))

    // Original points u and w (faded)
    circle((1, 1.2), radius: 0.06, fill: green. lighten(50%), stroke: green. lighten(50%))
    content((0.7, 1.2), text(fill: green. lighten(50%), size: 9pt)[u])

    circle((3.5, 1.8), radius: 0.06, fill: green.lighten(50%), stroke: green.lighten(50%))
    content((3.8, 1.8), text(fill: green.lighten(50%), size: 9pt)[w])

    // Draw the line segment s through the concave region
    line((1.8, 2.6), (2.8, 2.55), stroke: (thickness: 2pt, paint: orange))

    // Mark s' and s''
    circle((1.8, 2.6), radius: 0.08, fill: orange, stroke: orange)
    content((1.8, 2.6), anchor: "south-east", padding: 0.1, text(fill: orange, size: 9pt)[*s'*])

    circle((2.8, 2.55), radius: 0.08, fill: orange, stroke: orange)
    content((2.8, 2.55), anchor: "south-west", padding: 0.1, text(fill: orange, size: 9pt)[*s''*])

    // Mark s_min (closer to u)
    circle((1.8, 2.6), radius: 0.1, stroke: (paint: orange, dash: "dotted"), fill: none)
    content((1.5, 2.8), text(fill: orange, size: 8pt)[s#sub[min]])

    // New shifted points u' and w'
    circle((1.5, 2.5), radius: 0.08, fill: green.darken(20%), stroke: green.darken(20%))
    content((1.5, 2.5), anchor: "north-east", padding: 0.1, text(fill: green.darken(20%))[*u'*])

    circle((3.2, 2.4), radius: 0.08, fill: green.darken(20%), stroke: green.darken(20%))
    content((3.2, 2.4), anchor: "north-west", padding: 0.1, text(fill: green.darken(20%))[*w'*])

    // Arrow showing direction d
    line((4.5, 3), (3, 2.5), stroke: (paint: red, thickness: 1.5pt))
    line((3.2, 2.6), (3.5, 2.4), stroke: (paint: red, thickness: 1pt), mark: (end: ">"))
    content((3.7, 2.5), text(fill: red, size: 9pt)[#math. arrow(d)])

    // Normal vector n(d)
    line((2.3, 1.5), (2.3, 3), stroke: (paint: purple, dash: "dashed"), mark: (end: ">"))
    content((2.5, 3), text(fill: purple, size: 9pt)[n(#math.arrow("d"))])

    // Show that u' and w' are inside P
    content((1.2, 2), text(fill: green. darken(20%), size: 8pt)[u' ∈ P])
    content((3.5, 2), text(fill: green.darken(20%), size: 8pt)[w' ∈ P])
  })
)<fig:shift-process>

Let's now denote $arrow(d)$ as the direction of the edge of the convex hull that contains the two points. From the definition of concavity, there exists at least a point $q in P$ such that $forall p', p'' in P, lambda in [0, 1]$ it holds that $q in.not lambda p' + (1 - lambda) p''$, therefore must exists a line segment $s$ that connects the intersects the two edges of the polygon. Moreover, we will denote $n(d)$ as the normal vector to $arrow(d)$. We can argue that the vector $v$ can be expressed as $v = k dot n(d)$, where $k in RR$ and will intersect the polygon $P$ in two points $s', s'' in P$.

If we now shift again the points $u$ to $u' = u - s_("min")$ where $s_("min")$ is the point between $s'$ and $s''$ that is closer to $u$, and $w$ to $w' = w + s_("min")$, we have that both $u'$ and $w'$ (from the definition of convexity and convex hull) lie inside the polygon $P$, hence their sum $q = u' + w'$ lies inside $P pc Conv(P)$.

$square$

==
Impossible, see image
==
TODO (Impossible)

#figure(
cetz.canvas({
  // Importa le funzioni di disegno
  import cetz.draw: *


  let A = (1, 1)
  let B = (0, 0)
  let C = (-1, 1)
  let D = (0, -1)
  let r = 3

  let E = (A.at(0), A.at(1) + r)
  let F = (C.at(0), C.at(1) + r)
  let G = (0, E.at(1))

  grid(
    (-3, -2),
    (3, 2 + r),
    step: 1,
    stroke: gray + 0.2pt,
  )

  line((-3, 0), (3, 0), mark: (end: "stealth"), stroke: 0.4pt)
  content((), $x$, anchor: "west", padding: .1)
  line((0, -2), (0, 2 + r), mark: (end: "stealth"), stroke: 0.4pt)
  content((), $y$, anchor: "south", padding: .1)

  arc(
    A,
    anchor: "origin",
    start: 60deg,
    stop: 120deg,
    radius: r,
    stroke: 1pt + red,
    mode: "PIE",
    name: "circleA",
    fill: rgb("#d2310d33"),
  )

  arc(
    C,
    anchor: "origin",
    start: 60deg,
    stop: 120deg,
    radius: r,
    stroke: 1pt + red,
    mode: "PIE",
    name: "circleA",
    fill: rgb("#d2310d33"),
  )

  line(
    A,
    B,
    C,
    D,
    close: true,
    //fill: luma(200), // Colore di riempimento grigio chiaro
    stroke: 1.5pt + black,
  )

  line(
    A,
    E,
    stroke: 1pt + red,
    name: "lineA",
  )
  line(
    C,
    F,
    stroke: 1pt + red,
    name: "lineC",
  )

  line(E, F, stroke: 1pt + blue, name: "lineEF")
  line(C, G, stroke: (thickness: 1pt, paint: green, dash: (4pt, 3pt)), name: "lineCG")
  line(A, G, stroke: (thickness: 1pt, paint: green, dash: (4pt, 3pt)), name: "lineAG")


  content(A, [$A$], anchor: "south-east", padding: .1)
  content(B, [$B$], anchor: "north", padding: .1)
  content(C, [$C$], anchor: "south-east", padding: .1)
  content(D, [$D$], anchor: "north", padding: .1)
  content(E, [$E$], anchor: "south-east", padding: .1)
  content(F, [$F$], anchor: "south-east", padding: .1)
  content("lineA.mid", [$r$], anchor: "east", padding: .1)
  content("lineC.mid", [$r$], anchor: "east", padding: .1)
  content(G, [$G$], anchor: "south-east", padding: .1)
})
,
caption: []) <5.a>

==
// For two convex polygons P and Q, the perimeter of P ⊕ Q is equal to the sum of the perimeters of P and Q.
We start by the following observation: \
Let $Q := P pc R$, an extreme point on $Q$ in direction $d$ is the sum of extreme points in direction $d$ on $P$ and $R$.

An extreme can be a vertex or an edge. Hence, an extreme $q$ on $Q$ can be the sum of either two vertices or a vertex and an edge, or two edges. In the first case, $q$ would be a vertex. In the second case it would be an edge, the starting one translate by the vector of the vertex considered. When considering the third case, since the two edges must be parallel, otherwise they wouldn't be extremes on the same direction, $q$ would result in an edge, with the same length as the sum of the lengths of the considered edges.

Hence, every edge of $Q$ either corresponds to an edge of $P$ or $R$, or is the sum of two edges of $P$ and $R$. Also, every edge in $P$ will have a corresponding edge in $Q$, and the same for $R$. \
Therefore, the perimeter of $Q$ is the sum of the perimeters of $P$ and $R$.
