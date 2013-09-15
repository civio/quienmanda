function NetworkGraph() {

  /* TODO: Clean hardcoded dimensions below */
  var width = 960,
      height = 500,
      center_x = width / 2,
      center_y = height / 2;

  var color = d3.scale.category20();

  var force = d3.layout.force()
      .charge(-500)
      .linkDistance(120)
      .size([width, height]);

  var svg = d3.select("#viz-container").append("svg")
      .attr("width", width)
      .attr("height", height);

  this.display = function(graph) {
    // Pre-position the root node in the middle of the screen (and mark it as fixed
    // for the D3.js layout). Put the non-root nodes randomly in a circle around it
    // to avoid the dizzying start where all the nodes fly around
    $.each(graph.nodes, function(key, value) {
      if (value['root']) {
        value['fixed'] = true;
        value['x'] = center_x;
        value['y'] = center_y;
      } else {
        var angle = 2 * Math.PI * Math.random();
        value['x'] = center_x + height / 2 * Math.sin(angle);
        value['y'] = center_y + height / 2 * Math.cos(angle);
      }
    });

    // Create force layout
    force
        .nodes(graph.nodes)
        .links(graph.links)
        .start();

    // Arrow marker
    svg.append("svg:defs")
      .append("svg:marker")
        .attr("id", 'relation')
        .attr("viewBox", "0 -5 15 10")
        .attr("refX", 20)
        .attr("refY", -0.5)
        .attr("markerWidth", 6)
        .attr("markerHeight", 6)
        .attr("orient", "auto")
      .append("svg:path")
        .attr("d", "M0,-5L10,0L0,5");

    var path = svg.append("svg:g").selectAll("path")
        .data(force.links())
      .enter().append("svg:path")
        .attr("class", "link")
        .attr("marker-end", function(d) { return "url(#relation)"; })
        .style("stroke-width", function(d) { return Math.sqrt(d.value); });

    var node = svg.selectAll(".node")
        .data(graph.nodes)
      .enter().append("circle")
        .attr("class", "node")
        .attr("r", 13)
        .style("fill", function(d) { return color(d.group); })
        .call(force.drag);

    var text = svg.append("svg:g").selectAll("g")
        .data(force.nodes())
      .enter().append("svg:g")
        .append("svg:text")
        .attr("x", 18)
        .attr("y", ".31em")
        .text(function(d) { return d.name; });      

    force.on("tick", function() {
      path.attr("d", function(d) {
        var dx = d.target.x - d.source.x,
            dy = d.target.y - d.source.y,
            dr = Math.sqrt(dx * dx + dy * dy);
        return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
      });

      node.attr("cx", function(d) { return d.x; })
          .attr("cy", function(d) { return d.y; });

      text.attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      });

    });
  };

};