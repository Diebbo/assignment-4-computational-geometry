= Geodesic Distances in Polygons with Holes

We want to show an example of a polygon with holes where, given a point $q$ inside the polygon, exists a point $q'$ such that the geodesic distance is maximum and the $q'$ is not on the boundary of the polygon.

Let's consider the following image of a polygon with holes. We assume that the line holes are degenerate rectangles.

#figure(
  caption: "Polygon with holes.",
  image("../assets/poly2.png", width: 50%),
)

Let's denote $T_u$ the upper equilateral triangle where $q'$ lays. From definition all the vertices are equally distant from each other and from the center.

The horizontal hole in the middle constrains the shortest path from $q$ to $q'$ to reach either the left or the right side of the bottom triangle $T_b$. From the following lemma defined in class, we know that the shortest path must pass through some of the vertices of the holes.

_*Lemma*: A shortest path between s and t
among a set of disjoint obstacles $P_1, dots, P_h$ is
a polygonal path whose inner vertices are
vertices of $P_1, dots, P_h$_

In addition, the x-coordinate of $q$ is in the midpoint of the horizontal hole that define $T_b$, so the two shortest paths to the edges of the hole are equal.

From those edges, we want to reach one of the vertices of $T_u$. Since we have to go through the congruent equilateral triangles $T_l$ and $T_r$, the distance between each one of the vertices of $T_b$ and each one of the vertices of $T_u$ will be equal.

Every point in $T_b$, $T_l$ and $T_r$ is closer to $q$ than any of the vertices of $T_u$, so $q'$ has to be inside $T_u$.

Finally, the point $q'$ that maximizes the geodesic distance from $q$ is the center of the triangle $T_u$, since it is equally distant from all the vertices of the triangle, and every point on the boundaries would be closer to at least one of the vertices, by the Pythagoras theorem.

To be more precise, for visualization purposes, the image concedes some approximation, since we need to show that the holes are actually disjoints rectangles, and the triangles are not perfectly equilateral, but at least isosceles. However, the reasoning still holds.

#figure(
  caption: [Shortest possible paths from $q$ to $q'$.],
  image("../assets/poly2-with-path.png", width: 50%),
)
