// We define $j instead of $ to avoid conflict with annotorious.js 
// (see https://learn.jquery.com/using-jquery-core/avoid-conflicts-other-libraries/)
$j = jQuery.noConflict();

function NetworkGraph(selector, infobox) {

  var _this = this;

  // Basic D3.js SVG container setup
  var width = $j(selector).width(),
      height = $j(selector).height(),
      centerx = width / 2,
      centery = height / 2,
      linkDistance = height * 0.2,
      isFullscreen = false;

  var category2 = [ "#60A300", "#A9C300" ]; //[ "#CE7A20", "#814607" ];
  var color = d3.scale.ordinal().range(category2).domain([1,2]);
  var infobox = d3.select(infobox);

  // I keep track of panning+zooming and use the 'drag' behaviour plus two buttons.
  // The mousewheel behaviour of the 'zoom' behaviour was annoying, and couldn't 
  // find a way of disabling it.
  var scale = 1;
  var viewport_origin_x = 0;
  var viewport_origin_y = 0;
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
      .linkStrength(0.6)
      .size([width, height]);

  // Node drag behaviour
  var drag = force.drag()
      .on("dragstart", onNodeDragStart)
      .on("drag", onNodeDragMove);

  // Visualization data
  var nodes = {};
  var links = {};
  var connectedNodes = {};  // Convenience data, to highlight neighbours

  // D3.js selectors, available for tick() method
  var nodeRootUrl,
      node,
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


  /*** PUBLIC mehods ***/

  // Load the root node
  this.loadRootNode = function(url) {
    loadNode(url);
    nodeRootUrl = url;
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

  // Resize visualization
  this.resize = function() {

    width = $j(selector).width();
    height = $j(selector).height();
    viewport_origin_x = (width * 0.5) - centerx;
    viewport_origin_y = (height * 0.5) - centery;
    linkDistance = height * 0.2;

    // update svg size
    d3.select(selector).select('svg')
      .attr('width', width)
      .attr('height', height);

    rescale();
  };


  /*** PRIVATE mehods ***/

  // Update canvas after nodes are added
  function display() {
    // Create force layout
    force
        .nodes(d3.values(nodes))
        .links(d3.values(links))
        .start();

    // Relations
    path = svg.select("#linksContainer").selectAll(".link")
        .data(force.links(), function(d) { return d.id; });

    path.enter().append("svg:path")
        .attr("id", function(d){ return 'link-'+d.id; })
        .attr("class", "link")
        .on("mouseover", onLinkMouseOver)
        .on("mouseout", onLinkMouseOut)
        .attr("marker-end", function(d) { return "url(#relation)"; });

    // Nodes
    node = svg
        .select("#nodesContainer")
        .selectAll(".node")
        .data(force.nodes(), function(d) { return d.url; });

    node.enter().append("g")
      .call(drag)
      .call(displayNode)
        .attr("id", function(d){ return 'node'+d.url.replace(/\//g,'-'); })
        .attr("class", getNodeClass)
        .on('click', onNodeClick)
      .append("text")
        .attr("dx", 11)
        .attr("dy", ".35em")
        .text(function(d) { return d.name; });
  }

  // NODE METHODS

  // Load a node .json & add its related nodes & links
  function loadNode(url, posx, posy) {
    // If a position is given, preposition child nodes around that.
    // Otherwise just put them in the middle of the screen
    if(typeof(posx)==='undefined') posx = centerx;
    if(typeof(posy)==='undefined') posy = centery;

    var spinner = showSpinner();

    // Adding '.json' is not strictly necessary, since Rails and jQuery will understand
    // the Content Type headers of the request. But the Rails cache is mixing up the 
    // HTML and JSON responses, so the quickest way of fixing that is making sure the
    // request URLs are different.
    $j.getJSON(url+'.json', function(data) {

      // Add the retrieved nodes to the network graph
      $j.each(data.nodes, function(key, node) {
        addNode(node, url, posx, posy);
      });

      // Add the retrieved links to the network graph
      $j.each(data.links, function(key, link) {
        addLink(link);
      });

      // Go through the relations of child nodes, looking for relations among them
      $j.each(data.child_links, function(key, link) {
        if ( nodes[link.source] == null ) {
          nodes[link.target]['expandable'] = true;
        } else if ( nodes[link.target] == null ) {
          nodes[link.source]['expandable'] = true;
        } else {
          addLink(link);
        }
      });

      spinner.stop();
      display();
    });
  }

  // Remove related nodes & its links
  function unloadNode(url) {
    $j.each(nodes, function(key,node) {
      // filter all nodes to get only nodes loadedBy url
      if (node.url !== url && node.url !== nodeRootUrl && node.loadedBy && node.loadedBy.indexOf(url) > -1) {
        // check if node has been loadedBy other nodes
        if (node.loadedBy.length < 2) {
          // Remove links from this node
          $j.each(links, function(key,link) {
              if (link.source.url == node.url || link.target.url == node.url){
                removeLink(link);
              }
          });
          removeNode(node);
        }
        // update node.loadedBy
        node.loadedBy.splice(node.loadedBy.indexOf(url), 1);
      }
    });

    // Update force after remove nodes & links
    force
      .nodes(d3.values(nodes))
      .links(d3.values(links))
      .start();
  }

  // Add a node
  function addNode(node, url, posx, posy) {
    presetNode(node, posx, posy);
    nodes[node.url] = nodes[node.url] || node;
    // update loadedBy array
    if (node.url !== url && node.url !== nodeRootUrl) {
      (nodes[node.url].loadedBy = (nodes[node.url].loadedBy || [])).push( url );
    }
  }

  // Remove a node
  function removeNode(node) {
    var nodeToDelete = d3.select('#node'+node.url.replace(/\//g,'-'));

    // Check if node to delete has child to remove recursively
    if( nodeToDelete.classed('expanded') ){
      unloadNode( node.url );
    }

    // Delete node
    nodeToDelete.remove();  // from DOM
    delete nodes[node.url]; // from data
  }

  // Display a node in canvas
  function displayNode(node) {
    node.append("circle")
      .on("mouseover", onNodeMouseOver)
      .on("mouseout", onNodeMouseOut)
      .attr("r", 9)
      .style("fill", function(d) { return color(d.group); });

    // We add an image with a expand sign; will be visible only when applicable
    node.append("image")
      .attr("xlink:href", "/img/plus-sign.png")
      .attr("x", -8)
      .attr("y", -8)
      .attr("class", "expand-icon")
      .attr("width", 16)
      .attr("height", 16);
  }

  // Get the node class (root|expandable|expanded)
  function getNodeClass(node) {
    return node.root ?
            "node root" :
            (node['expandable'] ? "node expandable" :
            (node['expanded'] ? "node expanded" : "node") );
  }

  // When load a node, put the related nodes randomly in a circle around 
  // the existing one to avoid the dizzying start where all the nodes fly around.
  function presetNode(node, posx, posy) {
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

  // LINK METHODS

  // Add a link
  function addLink(link) {
    // Keep track of neighboring nodes
    connectedNodes[link.source + "," + link.target] = 1;

    link.source = nodes[link.source];
    link.target = nodes[link.target];
    links[link.id] = links[link.id] || link;
  }

  // Remove a link
  function removeLink(link) {
    d3.select('#link-'+link.id).remove(); // from DOM
    delete links[link.id];                // from data
  }

  // EVENT HANDLERS

  // Canvas drag handler
  function onDrag() {
    viewport_x += d3.event.dx;
    viewport_y += d3.event.dy;
    rescale();
    d3.event.sourceEvent.stopPropagation(); // silence other listeners
  }

  // Node drag handlers
  function onNodeDragStart(d) {
    d3.event.sourceEvent.stopPropagation(); // silence other listeners
  }
  function onNodeDragMove(d) {
    // fix the node position when the node is dragged
    // (used to do this at dragend, but a double click would confuse it)
    d.fixed = true;
  }

  // Node click handler
  function onNodeClick(d) {
    if (d3.event.defaultPrevented) return;  // click suppressed
  
    // Check if expand or contract
    if ( d['expandable'] ) {
      d['expandable'] = false;                // Not anymore expandable
      d['expanded'] = true;                   // Expanded
      d3.select( d3.event.target.parentNode ) // Update class & change image icon (less)
        .attr('class', getNodeClass)
        .select('image')
          .attr("xlink:href", "/img/less-sign.png");
      d.fixed = true;                         // Fix after 'exploding', feels better
      loadNode(d.url, d.x, d.y);        // add linked nodes

    } else if ( d['expanded'] ) {
      d['expandable'] = true;
      d['expanded'] = false;
      d3.select( d3.event.target.parentNode ) // Update class & change image icon (plus)
        .attr('class', getNodeClass)
        .select('image')
          .attr("xlink:href", "/img/plus-sign.png");
      d.fixed = false;
      unloadNode(d.url);                      // remove linked nodes
    }
  }

  // Node over/out handlers
  function onNodeMouseOver(d) {
    if (d3.select( d3.event.target.parentNode ).classed('root')) { return; }

    highlightRelatedNodes(d, 0.2);  // Fade-out non-neighbouring nodes

    // Display node information
    infobox.html('');
    renderNodeName(infobox, d);
    if ( d.description !== null ) {
      infobox.append('span')
        .text(' '+d.description+' ');
    }
  }
  function onNodeMouseOut(d) {
    if (d3.select( d3.event.target.parentNode ).classed('root')) { return; }

    highlightRelatedNodes(d, 1);   // Fade-in the whole graph
  }

  // Link over/out handlers
  function onLinkMouseOver(link) {
    highlightRelatedNodes(link.source, 0.2);  // Fade-out non-neighbouring nodes

    // Display basic relation information
    infobox.html('');
    renderNodeName(infobox, link.source);
    infobox.append('span')
      .attr('class', 'separator')
      .text(link.type);
    renderNodeName(infobox, link.target);

    // Display date information
    if ( link.at !== null ) {
      infobox.append('span')
        .attr('class', 'separator')
        .text('('+relation.at+')');
    } else if ( link.from !== null || link.to !== null ) {
      infobox.append('span')
        .attr('class', 'separator')
        .text('('+(link.from||'')+' - '+(link.to||'')+')');
    }

    // Display sources
    if ( link.via.length > 0 ) {
      sources = infobox.append('span').attr('class', 'sources').text('Fuente: ');
      sources.selectAll('.via').data(link.via)
        .enter().append('a')
          .attr('target', '_blank')
          .attr('href', function(d) { return d; })
          .text(function(d, i) { return (i+1); });
    }
  }
  function onLinkMouseOut(link) {
    highlightRelatedNodes(link.source, 1);   // Fade-in the whole graph
  }

  // AUXILIAR METHODS

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
    return new Spinner(opts).spin($j(selector)[0]);
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

  // Update translate/scale of canvas
  function rescale() {
    svg.attr("transform", "translate(" + (viewport_origin_x + viewport_x) + ","+ (viewport_origin_y + viewport_y) +")scale("+scale+")");
  }

  // Add node label to infobox on hover
  function renderNodeName(parent, node) {
    parent.append('a')
      .attr('href', node.url)
      .attr('target', '_blank')
      .append('strong')
        .text(node.name)
      .append('i')
        .attr('class', 'icon-external-link');
  }

  // Highlighting related nodes on hover
  function highlightRelatedNodes(d, opacity) {
    node.style("stroke-opacity", function(o) {
      thisOpacity = isConnected(d, o) ? 1 : opacity;
      this.setAttribute('fill-opacity', thisOpacity);
      return thisOpacity;
    });

    d3.selectAll('.expand-icon')
      .style('opacity', opacity);

    path.style("stroke-opacity", function(o) {
      return o.source === d || o.target === d ? 1 : opacity;
    });

    if (d3.event.type == "mouseover")
      path.attr("marker-end", function(o) { return o.source === d || o.target === d ? "url(#relation)" : null; });
    else
      path.attr("marker-end", "url(#relation)");
  }

  // Check if two nodes are connected
  function isConnected(a, b) {
    return  connectedNodes[a.url + "," + b.url] ||
            connectedNodes[b.url + "," + a.url] ||
            a.url == b.url;
  }
}
