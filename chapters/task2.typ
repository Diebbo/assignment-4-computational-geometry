= Geodesic Distances in Polygons with Holes

We want to show an example of a polygon with holes where, given a point $q$ inside the polygon, exists a point $p$ such that the geodesic distance is maximum and the $p$ is not on the boundary of the polygon.

Let's consider the following image of a polygon with holes. We assume that the line holes are degenerate rectangles.

#figure(
  caption: "Polygon with holes.",
  image("../assets/poly2.png", width: 50%),
)

Let's denote $T_u$ the upper equilateral triangle where $q$ lays. From definition all the vertices are equally distant from each other and from the center.

From the middle constraint we know that $q$ must reach either the left or the right side of the lower triangle $T_b$, and from the theorem defined in class (for shortest path in polygons with holes) it also must pass through one of the vertices of the holes.

By adding two equilateral triangles on the side of $T_b$ we are sure that the distance to go from one of the vertices of $T_u$ to one of the upper vertices of $T_b$ is equal.

Finally, in order to maximize the distance without contracting the fact that exists another shorter path, $q$ must be in the center of $T_u$ and $p$ in one of the lower vertices of $T_b$ because of Pythagoras theorem.

#figure(
  caption: "An example image added to the document.",
  image("../assets/poly2-with-path.png", width: 50%),
)
