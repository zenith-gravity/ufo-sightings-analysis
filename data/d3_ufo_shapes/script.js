import { json } from 'https://esm.sh/d3-fetch';
import { select } from 'https://esm.sh/d3-selection';
import { rollup } from 'https://esm.sh/d3-array';
import {
  symbol,
  symbolTriangle,
  symbolStar,
  symbolWye
} from 'https://esm.sh/d3-shape';

const data = await json("https://zenith-gravity.github.io/ufo-sightings-analysis/data/ufo_sightings.json");

// Count sightings by shape, removing blanks
let shapeCounts = Array.from(
  rollup(
    data.filter(d => d.shape && d.shape.trim() !== ""),
    v => {
      const validDurations = v
        .map(row => Number(row["duration..seconds."]))
        .filter(value => !isNaN(value));

      return {
        count: v.length,
        avgDuration:
          validDurations.reduce((sum, value) => sum + value, 0) /
          validDurations.length
      };
    },
    d => d.shape
  ),
  ([shape, values]) => ({
    shape: shape,
    count: values.count,
    avgDuration: values.avgDuration
  })
);

// Sort from highest to lowest
shapeCounts.sort((a, b) => b.count - a.count);

// Keep top 10
shapeCounts = shapeCounts.slice(0, 10);

const svg = select("svg");

// Title
svg.append("text")
  .attr("x", 550)
  .attr("y", 30)
  .attr("text-anchor", "middle")
  .attr("font-size", "22px")
  .text("Top 10 UFO Shapes by Number of Sightings");

// Create one group per category
const groups = svg.selectAll(".ufo-item")
  .data(shapeCounts)
  .join("g")
  .attr("class", "ufo-item")
  .attr("transform", (d, i) => `translate(${80 + i * 100},160)`);

// Draw the symbol/shape for each category
groups.each(function(d) {
  const g = select(this);
  const size = Math.sqrt(d.count) / 2.6;  // general size scale

  if (d.shape === "light") {
    g.append("path")
      .attr("d", symbol().type(symbolWye).size(size * size * 3)())
      .attr("fill", "steelblue")
      .attr("stroke", "black");
  }

  else if (d.shape === "triangle") {
    g.append("path")
      .attr("d", symbol().type(symbolTriangle).size(size * size * 3)())
      .attr("fill", "steelblue")
      .attr("stroke", "black");
  }

  else if (d.shape === "circle") {
    g.append("circle")
      .attr("r", size)
      .attr("fill", "none")
      .attr("stroke", "black")
      .attr("stroke-width", 2);
  }

  else if (d.shape === "fireball") {
    g.append("path")
      .attr("d", symbol().type(symbolStar).size(size * size * 3.5)())
      .attr("fill", "orange")
      .attr("stroke", "black");
  }

  else if (d.shape === "other") {
    g.append("rect")
      .attr("x", -size)
      .attr("y", -size)
      .attr("width", size * 2)
      .attr("height", size * 2)
      .attr("fill", "steelblue")
      .attr("stroke", "black");
  }

  else if (d.shape === "unknown") {
    g.append("rect")
      .attr("x", -size)
      .attr("y", -size)
      .attr("width", size * 2)
      .attr("height", size * 2)
      .attr("fill", "none")
      .attr("stroke", "black")
      .attr("stroke-width", 2);
  }

  else if (d.shape === "sphere") {
    g.append("circle")
      .attr("r", size)
      .attr("fill", "steelblue")
      .attr("stroke", "black");
  }

  else if (d.shape === "disk") {
    g.append("ellipse")
      .attr("rx", size * 1.2)
      .attr("ry", size * 0.7)
      .attr("fill", "steelblue")
      .attr("stroke", "black");
  }

  else if (d.shape === "oval") {
    g.append("ellipse")
      .attr("rx", size * 1.2)
      .attr("ry", size * 0.7)
      .attr("fill", "none")
      .attr("stroke", "black")
      .attr("stroke-width", 2);
  }

  else if (d.shape === "formation") {
    g.append("circle")
      .attr("cx", -size * 0.9)
      .attr("cy", 0)
      .attr("r", size * 0.35)
      .attr("fill", "steelblue")
      .attr("stroke", "black");

    g.append("circle")
      .attr("cx", 0)
      .attr("cy", 0)
      .attr("r", size * 0.35)
      .attr("fill", "steelblue")
      .attr("stroke", "black");

    g.append("circle")
      .attr("cx", size * 0.9)
      .attr("cy", 0)
      .attr("r", size * 0.35)
      .attr("fill", "steelblue")
      .attr("stroke", "black");
  }

  // fallback for any top-10 category we didn't explicitly map
  else {
    g.append("circle")
      .attr("r", size)
      .attr("fill", "lightgray")
      .attr("stroke", "black");
  }
});

// Shape label
groups.append("text")
  .attr("y", 85)
  .attr("text-anchor", "middle")
  .attr("font-size", "12px")
  .text(d => d.shape);

// Count label
groups.append("text")
  .attr("y", 105)
  .attr("text-anchor", "middle")
  .attr("font-size", "11px")
  .text(d => `${d.count} sightings`);

//Average duration label
groups.append("text")
  .attr("y", 123)
  .attr("text-anchor", "middle")
  .attr("font-size", "10px")
  .text(d => `Avg: ${Math.round(d.avgDuration)} sec`);

