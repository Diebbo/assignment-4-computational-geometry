= Question
How to find the union of the areas of the $n$ rectangles in $O(n log n)$ time?

== Answer Sweep Line

We create the same data structure presented in the first exercise. We define as "events" the left and right sides of each rectangle ($O(2 n)$. We start iterating from the left to the right (top to bottom is also possible, but we need to adapt the DS).
