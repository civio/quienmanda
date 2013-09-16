function NetworkGraph(selector) {

  // Basic D3.js SVG container setup
  var width = $(selector).width(),
      height = width * .5,
      centerx = width / 2,
      centery = height / 2,
      linkDistance = height * .2;

  var color = d3.scale.category20();

  var svg = d3.select(selector).append("svg")
      .attr("width", width)
      .attr("height", height);

  // Force layout configuration
  var force = d3.layout.force()
      .on("tick", tick)
      .charge(-linkDistance * 5)
      .linkDistance(linkDistance)
      .size([width, height]);

  var drag = force.drag()
      .on("dragend", dragend);

  // Visualization data
  var nodes = {};
  var links = {};

  // D3.js selectors, available for tick() method
  var node,
      path,
      text;

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

  // Create two separate containers for links and nodes, to make sure
  // nodes come always after nodes, even when loading data dynamically
  svg.append("g")
    .attr("id", "linksContainer");
  svg.append("g")
    .attr("id", "nodesContainer");


  /* PUBLIC interface */

  this.display = function() {
    // Create force layout
    force
        .nodes(d3.values(nodes))
        .links(d3.values(links))
        .start();

    // Relations
    path = svg.select("#linksContainer").selectAll(".link")
        .data(force.links(), function(d) { return d.id; })

    path.enter().append("svg:path")
        .attr("class", "link")
        .attr("marker-end", function(d) { return "url(#relation)"; })
        .style("stroke-width", function(d) { return Math.sqrt(d.value); });

    // Nodes
    node = svg.select("#nodesContainer").selectAll(".node")
        .data(d3.values(nodes), function(d) { return d.url; })

    var that = this;
    node.enter().append("circle")
        .attr("class", "node")
        .attr("r", 13)
        .style("fill", function(d) { return color(d.group); })
        .on('dblclick', function(d) { that.loadNode(d.url); })
        .call(force.drag);

    // FIXME: Put back titles until I get labels fixed!
    node.append("title")
      .text(function(d) { return d.name; });
    // Labels
    // text = svg.append("svg:g").selectAll("g")
    //     .data(force.nodes())
    //   .enter().append("svg:g")
    //     .append("svg:text")
    //     .attr("x", 18)
    //     .attr("y", ".31em")
    //     .text(function(d) { return d.name; });
  };

  this.loadNode = function(url) {
    var networkGraph = this;
    $.getJSON(url, function(data) {
      var isFirstLoad = (typeof node === 'undefined');

      // Add the retrieved nodes to the network graph
      $.each(data.nodes, function(key, node) {
        if ( isFirstLoad ) {
          presetFirstNodes(node);
        }
        nodes[node.url] = nodes[node.url] || node;
      });

      // Add the retrieved links to the network graph
      $.each(data.links, function(key, link) {
        link.source = nodes[link.source];
        link.target = nodes[link.target];
        links[link.id] = links[link.id] || link;
      });

      networkGraph.display();
    });
  };


  /* PRIVATE */

  // When creating a new, pre-position the root node in the middle of the screen 
  // (and mark it as fixed for the D3.js layout). Put the non-root nodes randomly 
  // in a circle around it to avoid the dizzying start where all the nodes fly around
  function presetFirstNodes(node) {
    if (node['root']) {
      node['fixed'] = true;
      node['x'] = centerx;
      node['y'] = centery;
    } else {
      var angle = 2 * Math.PI * Math.random();
      node['x'] = centerx + linkDistance * Math.sin(angle);
      node['y'] = centery + linkDistance * Math.cos(angle);
    }
  };

  // Force layout iteration
  function tick() {
    path.attr("d", function(d) {
      var dx = d.target.x - d.source.x,
          dy = d.target.y - d.source.y,
          dr = Math.sqrt(dx * dx + dy * dy);
      return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
    });

    node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });

    // text.attr("transform", function(d) {
    //   return "translate(" + d.x + "," + d.y + ")";
    // });
  };

  // Drag handler: toggle fixed attribute after dragging is completed
  function dragend(d) {
    d.fixed = !d.fixed;
  };
};