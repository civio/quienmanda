function NetworkGraph(selector, infobox) {

  // Basic D3.js SVG container setup
  var width = $(selector).width(),
      height = Math.max(width * 9 / 16, 450),
      centerx = width / 2,
      centery = height / 2,
      linkDistance = height * .2;

  var category2 = [ "#60A300", "#A9C300" ];
  var color = d3.scale.ordinal().range(category2).domain([1,2]);
  var infobox = d3.select(infobox);

  // I keep track of panning+zooming and use the 'drag' behaviour plus two buttons.
  // The mousewheel behaviour of the 'zoom' behaviour was annoying, and couldn't 
  // find a way of disabling it.
  var scale = 1;
  var viewport_x = 0;
  var viewport_y = 0;

  var svg = d3.select(selector).append("svg")
      .attr("width", width)
      .attr("height", height)
      .call(d3.behavior.drag().on("drag", onDrag))
      .append("g");   // Removing this breaks zooming/panning

  // Force layout configuration
  var force = d3.layout.force()
      .on("tick", tick)
      .charge(-linkDistance * 5)
      .gravity(0.02)
      .linkDistance(linkDistance)
      .linkStrength(.6)
      .size([width, height]);

  // Node drag behaviour
  var drag = force.drag()
      .on("dragstart", dragstart)
      .on("drag", dragmove);

  // Visualization data
  var nodes = {};
  var links = {};
  var connectedNodes = {};  // Convenience data, to highlight neighbours

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
      .attr("markerWidth", 5)
      .attr("markerHeight", 5)
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
        .on("mouseover", onRelationMouseOver)
        .attr("marker-end", function(d) { return "url(#relation)"; });

    // Nodes
    node = svg
        .select("#nodesContainer")
        .selectAll(".node")
        .data(force.nodes(), function(d) { return d.url; })

    var that = this;
    node.enter().append("g")
      .call(drag)
      .call(createNode)
        .attr("class", function(d) { return d.root ? "node root" : "node" } )
        .on('dblclick', function(d) { 
          d.fixed = true; // Feels better if the node gets fixed when it 'explodes'
          that.loadNode(d.url, d.x, d.y); 
        })
      .append("text")
        .attr("dx", 11)
        .attr("dy", ".35em")
        .text(function(d) { return d.name });
  };

  this.loadNode = function(url, posx, posy) {
    // If a position is given, preposition child nodes around that.
    // Otherwise just put them in the middle of the screen
    if(typeof(posx)==='undefined') posx = centerx;
    if(typeof(posy)==='undefined') posy = centery;

    var spinner = showSpinner();
    var networkGraph = this;
    $.getJSON(url, function(data) {
      // Add the retrieved nodes to the network graph
      $.each(data.nodes, function(key, node) {
        presetChildNodes(node, posx, posy);
        nodes[node.url] = nodes[node.url] || node;
      });

      // Add the retrieved links to the network graph
      $.each(data.links, function(key, link) {
        addLink(link);
      });

      // Go through the relations of child nodes, looking for relations among them
      $.each(data.child_links, function(key, link) {
        if ( nodes[link.source]!=null && nodes[link.target]!=null) {
          addLink(link);
        }
      });

      spinner.stop();
      networkGraph.display();
    });
  };

  // Zoom controls
  this.zoomIn = function() {
    scale *= 1.2;
    rescale();
  };
  this.zoomOut = function() {
    scale /= 1.2;
    rescale();
  };
  this.zoomReset = function() {
    scale = 1;
    viewport_x = 0;
    viewport_y = 0;
    rescale();
  };

  /* PRIVATE */

  function createNode(node) {
    node.append("circle")
      .on("mouseover", onNodeMouseOver)
      .on("mouseout", onNodeMouseOut)
      .attr("r", 9)
      .style("fill", function(d) { return color(d.group); });
  }

  function addLink(link) {
    // Keep track of neighboring nodes
    connectedNodes[link.source + "," + link.target] = 1;

    link.source = nodes[link.source];
    link.target = nodes[link.target];
    links[link.id] = links[link.id] || link;
  }

  // When adding children nodes, put the news nodes randomly in a circle around 
  // the existing one to avoid the dizzying start where all the nodes fly around.
  function presetChildNodes(node, posx, posy) {
    if (node['root']) {
      node['fixed'] = true;
      node['x'] = posx;
      node['y'] = posy;
    } else {
      var angle = 2 * Math.PI * Math.random();
      node['x'] = posx + linkDistance * Math.sin(angle);
      node['y'] = posy + linkDistance * Math.cos(angle);
    }
  }

  // Load spinner, using spin.js
  function showSpinner() {    
    var opts = {
      lines: 13, // The number of lines to draw
      length: 20, // The length of each line
      width: 12, // The line thickness
      radius: 45, // The radius of the inner circle
      corners: 0.7, // Corner roundness (0..1)
      rotate: 59, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: '#000', // #rgb or #rrggbb or array of colors
      speed: 1, // Rounds per second
      trail: 63, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: 'auto', // Top position relative to parent in px
      left: 'auto' // Left position relative to parent in px
    };
    return new Spinner(opts).spin($(selector)[0]);
  }

  // Force layout iteration
  function tick() {
    path.attr("d", function(d) {
      var dx = d.target.x - d.source.x,
          dy = d.target.y - d.source.y,
          dr = Math.sqrt(dx * dx + dy * dy) * 1.5;
      return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
    });

    node.attr("transform", function(d) {
      return "translate(" + d.x + "," + d.y + ")";
    });
  }

  // Canvas drag handler
  function onDrag() {
    viewport_x += d3.event.dx;
    viewport_y += d3.event.dy;
    rescale();
    d3.event.sourceEvent.stopPropagation(); // silence other listeners
  }
  function rescale() {
    svg.attr("transform", "translate(" + viewport_x + ","+ viewport_y+")scale("+scale+")");
  }

  // Node drag handlers
  function dragstart(d) {
    d3.event.sourceEvent.stopPropagation(); // silence other listeners
  }
  function dragmove(d) {
    // fix the node position when the node is dragged
    // (used to do this at dragend, but a double click would confuse it)
    d.fixed = true;   
  }

  // Mouse over handlers
  function renderNodeName(parent, node) {
    parent.append('a')
      .attr('href', node.url)
      .attr('target', '_blank')
      .append('strong')
        .text(node.name)
      .append('i')
        .attr('class', 'icon-external-link');
  }

  function onNodeMouseOver(d) {
    fade(d, .2);  // Fade-out non-neighbouring nodes

    // Display node information
    infobox.html('');
    renderNodeName(infobox, d);
    if ( d.description != null ) {
      infobox.append('span')
        .text('. '+d.description+' ');
    }
  }

  function onNodeMouseOut(d) {
    fade(d, 1);   // Fade-in the whole graph
  }

  function onRelationMouseOver(relation) {
    // Display basic relation information
    infobox.html('');
    renderNodeName(infobox, relation.source);
    infobox.append('span')
      .attr('class', 'separator')
      .text(relation.type);
    renderNodeName(infobox, relation.target);

    // Display date information
    if ( relation.at != null ) {
      infobox.append('span')
        .attr('class', 'separator')
        .text('('+relation.at+')');
    } else if ( relation.from != null || relation.to != null ) {
      infobox.append('span')
        .attr('class', 'separator')
        .text('('+(relation.from||'')+' - '+(relation.to||'')+')');
    }

    // Display sources
    if ( relation.via.length > 0 ) {
      sources = infobox.append('span').attr('class', 'sources').text('Fuente: ');
      sources.selectAll('.via').data(relation.via)
        .enter().append('a')
          .attr('target', '_blank')
          .attr('href', function(d) { return d; })
          .text(function(d, i) { return (i+1); });
    }
  }


  // Highlighting neighbouring nodes on hover
  function isConnected(a, b) {
    return  connectedNodes[a.url + "," + b.url] || 
            connectedNodes[b.url + "," + a.url] || 
            a.url == b.url;
  }
  
  function fade(d, opacity) {
    node.style("stroke-opacity", function(o) {
      thisOpacity = isConnected(d, o) ? 1 : opacity;
      this.setAttribute('fill-opacity', thisOpacity);
      return thisOpacity;
    });

    path.style("stroke-opacity", function(o) {
      return o.source === d || o.target === d ? 1 : opacity;
    });

    if (d3.event.type == "mouseover")
      path.attr("marker-end", function(o) { return o.source === d || o.target === d ? "url(#relation)" : null; });
    else
      path.attr("marker-end", "url(#relation)");
  }


};