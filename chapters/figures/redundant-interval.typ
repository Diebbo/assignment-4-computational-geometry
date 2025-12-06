#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot

#let redundant-interval = canvas({
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
      let x-intersect = 0 // Adjust this to set where the lines cross

      // First intersecting line: y = mx + q (solid before intersection, dotted after)
      plot.add(
        style: (stroke: green + 1.5pt),
        label: "l2",
        domain: (x-intersect, 8),
        x => m * x + q,
      )
      plot.add(
        style: (stroke: (paint: green, thickness: 1.5pt, dash: "dotted")),
        label: "l2 redundant",
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
