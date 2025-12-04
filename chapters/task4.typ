#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot

= Questions
Given a set $P$ of $n$ points in the plane, each associated with a weight ($w(p_i))$), and a line $ell$, find the point with the maximum weight above the line.

Idea:
- map to the dual space. $p_i : (x_p, y_p) -> p* : y = x_p x - y_p$ and $ell : y = m x + b -> ell* : (m, -b)$
- in the dual space, the problem becomes finding the line with the maximum weight above the point $ell*$
- introducing the concept of _useless_ intervals.

Precomputing phase (time unbounded):
- sort the lines by weight in decreasing order
  - why? we can discard every line (or portion of line) that is covered by a line with higher weight.
- for each line intersection, compute the _useless_ interval, and discard them from the arrangement of lines (this will reduce the expected number of lines intersection).

#figure(
  caption: "Two incident lines with useless intervals",
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
      
      // First incident line: y = mx + q (solid before intersection, dotted after)
      plot.add(
        style: (stroke: green + 1.5pt),
        label: $y = #m x + #q$,
        domain: (x-intersect, 8),
        x => m * x + q,
      )
      plot.add(
        style: (stroke: (paint: green, thickness: 1.5pt, dash: "dotted")),
        domain: (-8, x-intersect),
        x => m * x + q,
      )
      
      // Second incident line: y = -mx + q' (solid throughout)
      // Calculate q' so the lines intersect at x-intersect
      let y-intersect = m * x-intersect + q
      let q-prime = y-intersect + m * x-intersect
      
      plot.add(
        style: (stroke: purple + 1.5pt),
        domain: (-8, 8),
        label: $y = #(-m) x + #q-prime$,
        x => -m * x + q-prime,
      )
    },
  )
})
)<fig:useless-interval>

- Given this notion we can compute a lower envelope of the lines, discarding useless intervals.
- Finally, we can query the lower envelope with the point $ell*$ to find the line with maximum weight above it.



#figure(
  caption: "Lower envelope of multiple lines",
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
        // Define the 4 points on the lower envelope
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
        
        // Draw the lower envelope segments as thick solid lines
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

Given a Binary Space Partitioning (BSP) of the lines, we can find the region where the point lies in $O(log n)$ time, and once we have the region, moreover the weight associated.

What's the total number of intersections? Because we are discarding every time half of the lines, the total number of intersections of points on the lower envelope is $O(n)$, because I'm taking each line at most once.

The only problem that remains is: given a slab, how to efficiently find the 
