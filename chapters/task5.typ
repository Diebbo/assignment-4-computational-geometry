= Minkowski Sum
#let pc = $plus.circle$
Let $A pc B$ the Minkowski sum of two sets $A, B in RR^2$, defined as $A pc B := {a + b | a in A, b in B }$.
==
TODO
== 
Impossible, see image
==
TODO (yes)
==
// For two convex polygons P and Q, the perimeter of P ⊕ Q is equal to the sum of the perimeters of P and Q.
We start by the following observation: \
Let $Q := P pc R$, an extreme point on $Q$ in direction $d$ is the sum of extreme points in direction $d$ on $P$ and $R$.

An extreme can be a vertex or an edge. Hence, an extreme $q$ on $Q$ can be the sum of either two vertices or a vertex and an edge, or two edges. In the first case, $q$ would be a vertex. In the second case it would be an edge, the starting one translate by the vector of the vertex considered. When considering the third case, since the two edges must be parallel, otherwise they wouldn't be extremes on the same direction, $q$ would result in an edge, with the same length as the sum of the lengths of the considered edges.

Hence, every edge of $Q$ either corresponds to an edge of $P$ or $R$, or is the sum of two edges of $P$ and $R$. Also, every edge in $P$ will have a corresponding edge in $Q$, and the same for $R$. \
Therefore, the perimeter of $Q$ is the sum of the perimeters of $P$ and $R$.
