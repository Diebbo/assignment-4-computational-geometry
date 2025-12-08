#import "@preview/cetz:0.4.2": canvas, draw

#set heading(numbering: "1.a")

#let Conv="Conv"
#let pc = $xor$

= Minkowski Sum
Let $A pc B$ be the Minkowski sum of two sets $A, B in RR^2$, defined as $A pc B := {a + b | a in A, b in B }$.

==

_If $P$ is a simple polygon then $P xor Conv(P)$ is convex, where $Conv(P)$ is the convex hull of $P$._




// #figure(
//   caption: "Two points u and w separated by a concave edge of the polygon.",
//   canvas(length: 1cm, {
//     import draw: *

//     // Define polygon P with a concave section
//     let points = (
//       (0, 0),
//       (5, 0),
//       (5, 3),
//       (2.5, 1.5),  // concave point
//       (0, 3)
//     )

//     // Draw polygon P
//     for i in range(points.len()) {
//       let next_i = calc.rem(i + 1, points.len())
//       line(points.at(i), points.at(next_i), stroke: (thickness: 1.5pt, paint: blue))
//     }

//     // Convex hull edge (dashed red line at bottom)
//     line((0, 3), (5, 3), stroke: (dash: "dashed", paint: red, thickness: 1.5pt))

//     // Mark points u and w inside polygon
//     let u = (1, 2)
//     let w = (4, 2)


//     // Mark the midpoint v
//     let v = ((u.at(0) + w.at(0)) / 2, (u.at(1) + w.at(1)) / 2)
//     circle(v, radius: 0.08, fill: purple, stroke: purple)
//     content((v.at(0), v.at(1)), anchor: "south", padding: 0.15, text(fill: purple)[*v*])
//     circle((v.at(0) - 0.5, v.at(1)), radius: 0.06, fill: purple, stroke: purple)
//     content((v.at(0) - 0.5, v.at(1)), anchor: "south", padding: 0.15, text(fill: purple)[*v'*])

//     // Segment s passing through the polygon (perpendicular to d)
//     // line((0, v.at(1)), (5, v.at(1)), stroke: (thickness: 1pt, paint: orange, dash: "dotted"))

//     // Mark points s' and s'' where segment intersects polygon edges
//     // get m and q for the line going from point[2] to point[3] and from point[3] to point[4]
//     let m1 = (points.at(3).at(1) - points.at(2).at(1)) / (points.at(3).at(0) - points.at(2).at(0))
//     let q1 = points.at(2).at(1) - m1 * points.at(2).at(0)
//     let m2 = (points.at(4).at(1) - points.at(3).at(1)) / (points.at(4).at(0) - points.at(3).at(0))
//     let q2 = points.at(3).at(1) - m2 * points.at(3).at(0)

//     let s_prime = ((v.at(1) - q1) / m1, v.at(1))
//     let s_double_prime = ((v.at(1) - q2) / m2, v.at(1))

//     circle(s_prime, radius: 0.08, fill: orange, stroke: orange)
//     content((s_prime.at(0), s_prime.at(1)), anchor: "north", padding: 0.15, text(fill: orange)[*s'*])

//     circle(s_double_prime, radius: 0.08, fill: orange, stroke: orange)
//     content((s_double_prime.at(0), s_double_prime.at(1)), anchor: "north", padding: 0.15, text(fill: orange)[*s''*])

//     line(s_prime, s_double_prime, stroke: (thickness: 1pt, paint: orange, dash: "dotted"))

//     // Add labels
//     content((2.5, 3.5), text(size: 10pt)[Polygon P])
//     content((2.5, -0.5), text(size: 10pt, fill: red)[Conv(P)])


//   })
// )<fig:concavity-separation>


#let CP = $Conv(P)$
Let $Q = Conv(P) pc Conv(P) = {a + b | a in CP, b in CP}$.
Take a random point $q in Q$.
We can express that point $q$ as the sum of two points $a in CP$, $b in CP$.
Since #CP is convex, then the midpoint of $a$ and $b$, $v = (a + b)/2$, will also be in #CP.
Therefore, it follows that $exists v in CP | q = v + v$.

By the definition of convex hull, we can express it as the set of convex combination of two points in $P$:
$CP = {lambda a + (1-lambda)b | lambda in [0, 1], a in P, b in P}$.

Then, we can express $v$ as $v = lambda u + (1-lambda)w$ for some $u, w in P$ and $lambda in [0, 1]$.


#figure(
  caption: [Point $v$ is a convex combination of points $u$ and $w$],
  canvas(length: 1cm, {
    import draw: *

    let u = (0.5, 0.8)
    let w = (3.7, 1.5)
    // Left triangle (open)
    line((0, 0), (2, 2), stroke: (thickness: 1.5pt, paint: blue))
    line((5, 3), (0, 3), stroke: (thickness: 1.5pt, paint: blue))
    line((0, 3), (0, 0), stroke: (thickness: 1.5pt, paint: blue))

    // Right triangle (open)
    line((5, 0), (5, 3), stroke: (thickness: 1.5pt, paint: blue))

    // Concave edge connecting the two triangles
    line((2, 2), (5, 0), stroke: (thickness: 1.5pt, paint: blue))

    // Mark point u (inside the polygon P - left triangle)
    circle(u, radius: 0.08, fill: green, stroke: green)
    content(u, anchor: "east", padding: 0.15, text(fill: green)[*$u$*])

    // dotted red line on the convex hull
    line((0, 0), (5, 0), stroke: (dash: "dashed", paint: red))

    // Mark point w (in the concave region - outside P but would be inside Conv(P))
    circle(w, radius: 0.08, fill: green, stroke: green)
    content(w, anchor: "north", padding: 0.15, text(fill: green)[*$w$*])

    // Draw dashed line connecting them

    line(u, w, stroke: (dash: "dashed", paint: gray))

    // Mark the midpoint v (on the concave edge or near it)
    let v = ((u.at(0) + w.at(0)) / 2, (u.at(1) + w.at(1)) / 2)
    circle(v, radius: 0.08, fill: purple, stroke: purple)
    content((v.at(0) , v.at(1) - 0.5), anchor: "south", padding: 0.15, text(fill: purple)[*$v$*])

    // Highlight the concave edge
    content((2.5, 2.5), text(fill: red, size: 9pt)[concave edge])

    // Add label for polygon
    content((2.5, 3.3), text(size: 10pt)[Polygon P])
    content((1, -0.3), text(size: 10pt, fill:red)[conv P])
  })
)<fig:concavity-separation>

Without loss of generality, we can consider the case where $lambda >= 1/2$. This means that $v$ will be closer to $u$ than $w$. We define now $Delta V = u - v$, such that $v + Delta V = u$, which is in $P$.

We can now define a new point:$
w' = v - Delta V = v - (u - v) = 2 v - u = (2 lambda - 1) u + 2 (1 - lambda) w,
$
since the sum of $2 lambda -1 $ and $2 (1 - lambda)$ is equal to 1, and both coefficients are non-negative, then $v'$ is a convex combination of $u$ and $w$, there forse it is in #CP.

Hence, we can express $q$ as: $
q = v + v = (v + Delta V) + (v - Delta V) = u + w', u in P, w' in CP.
$
This shows that $q in P pc CP$, therefore $CP pc CP subset.eq P pc CP$.

Since $P subset.eq CP$, then $P pc CP subset.eq CP pc CP$, hence $P pc CP = CP pc CP$, which is convex.
$square$


==

_If $P$ is a simple polygon and $C$ is a disk (circle and its interior) then $P pc C$ is convex if the diameter of $C$ is at least as large as the diameter of $P$._

It's easy to find a counter-example to disprove the statement, as shown in @fig:counter-example-5b.

#figure(
  image("../assets/counter-5b.svg"),
  caption: [Counter-example for the statement]
) <fig:counter-example-5b>

The blue dashed line represents the diameter of the polygon $P$, while the green line represents the radius of the disk $C$. In the image, the radius $r$ is exactly half of the diameter $d$ of the polygon $P$, hence the diameter of the disk is the same as that of $P$. \
The yellow region contains points that don't belong to the Minkowski sum $P pc C$,
but can be expressed as a convex combination of a point of $P$ and a point of $C$.
The fact that the yellow region exists proves that $P pc C$ is not convex,
even though the diameter of the disk is equal to or greater than the diameter of the polygon $P$.

For a more formal proof of the general case, check exercise *5.c*.

==
_If $P$ is a simple polygon then there exists a large enough disk such that $P pc C$ is convex._

The statement is false.

Consider the simple polygon $P$ defined by the vertices $A = (1, 1)$, $B = (0, 0)$, $C = (-1, 1)$ and $D = (0, -1)$. \
Consider also a disk $C$ of radius $r > 0$ centered on the origin. \
The topmost points of the polygon $P$ are $A$ and $C$. When computing the Minkowski sum $P pc C$, the topmost points will be $E = (1, 1 + r)$ and $F = (-1, 1 + r)$. \
Consider the midpoint $G = (0, 1 + r)$ between $E$ and $F$. The closest points to $G$ on the polygon $P$ are $A$ and $C$. The distance of $G$ from both $A$ and $C$ is exactly $sqrt(r^2 + 1)$, which is greater than $r$ for every $r$.
$ sqrt(r^2 + 1) > r \
  r^2 + 1 > r^2 \
  1 > 0
$
Therefore, the point $G$ does not lie inside the disk of radius $r$ centered at either $A$ or $C$, hence it does not lie inside the Minkowski sum $P pc C$, while being the midpoint of the segment $dash(E F)$. This shows that $P pc C$ is not convex for any $r > 0$.
$square$

#figure(
canvas({
  // Importa le funzioni di disegno
  import draw: *


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
caption: [Visualization of the counter-example]) <fig:counter-example-minkowski-disk>

==
_For two convex polygons $P$ and $Q$, the perimeter of $P pc Q$ is equal to the sum of the perimeters of $P$ and $Q$._

Let $Q := P pc R$.

We start with the following observation:
an extreme point on $Q$ in direction $d$ is the sum of
the extreme points in direction $d$ on $P$ and $R$.

An extreme can be a vertex or an edge.
Hence, an extreme $q$ on $Q$ can be the sum of either
two vertices, a vertex and an edge, or two edges.
In the first case, $q$ would be a vertex.
In the second case it would be the starting edge
translated by the vector of the vertex considered.
When considering the third case, since the two edges must be parallel
(otherwise they wouldn't be extremes in the same direction),
$q$ would result in an edge with the same length
as the sum of the lengths of the considered edges.

Hence, every edge of $Q$ either corresponds to an edge of $P$ or $R$,
or is the sum of two edges of $P$ and $R$.
Also, every edge in $P$ will have a corresponding edge in $Q$,
and the same for $R$. \
Therefore, the perimeter of $Q$ is the sum of the perimeters of $P$ and $R$.
$square$
