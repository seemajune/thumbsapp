colorCodes = ["#FF0000",
        "#FF7F00",
        "#FFFF00",
        "#7FFF00",
        "#00FF00"]; 

var globalNode;

function renderTree(json_url, sel) {
    var m = [20, 120, 20, 120],
  w = 1400 - m[1] - m[3],
  h = 1200, //;,2000 - m[0] - m[2],
  i = 0,
  root;

    var tree = d3.layout.tree()
  .size([h,w]);

    var diagonal = d3.svg.diagonal()
  .projection(function(d) { return [d.x, d.y]; });

    var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([-10, 0])
  .html(function(d) {
      return "<span style='color:white'>" + d.phrase + "</span>";
  });


    var vis = d3.select(sel).append("svg:svg")
  .attr("width", w + m[1] + m[3])
  .attr("height", h + m[0] + m[2])
  .append("svg:g")
  .attr("transform", "translate(" + m[3] + "," + m[0] + ")");

    vis.call(tip)

var depthCount = function (branch) {
    if (!branch.children) {
        return 1;
    }
    return 1 + d3.max(branch.children.map(depthCount));
 }
    
    d3.json(json_url, function(json) {
  console.log(json);


  root = json;
  $(sel).height(depthCount(root) * 45);

  root.x0 = 0;
  root.y0 = 0;

  function toggleAll(d) {
      if (d.children) {
    d.children.forEach(toggleAll);
    toggle(d);
      }
  }
  
  

  // Initialize the display to show a few nodes.
  //  root.children.forEach(toggleAll);

  update(root);
    });

    function update(source) {
  var duration = d3.event && d3.event.altKey ? 5000 : 500;

  // Compute the new tree layout.
  var nodes = tree.nodes(root).reverse();

  // Normalize for fixed-depth.
  nodes.forEach(function(d) { d.y = d.depth * 40; });

  // Update the nodes
  var node = vis.selectAll("g.node")
      .data(nodes, function(d) { return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("svg:g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
      .on("click", function(d) { toggle(d); update(d); });
  
  var collectPhrase = function(node) {
            if (node.hasOwnProperty("label")) {
    return node.label;
            } else {
    return collectPhrase(node.children[0]) + " " + collectPhrase(node.children[1]);
            }        
  };

  var phraseTooltip = function() {
      var circle = d3.select(this);
      circle.phrase = collectPhrase(circle[0][0].__data__);
      
      tip.show(circle);
  }

  // var updateScore = function(d){
  //   collectPhrase(this.parentNode)
  //   debugger;

  // }
  
  var suggestScore = function(d) {
    var popUp = d3.select(this.parentElement).append("svg:g").attr("id", "#popup")

    popUp.append("svg:rect").attr("width", "200")
    .attr("height", "240")
    .style("fill", "#fff")
    .attr("rx","15")
    .attr("ry","15")
    .style("stroke", "#000")
    .style("stroke-width", "2");

    popUp.append("text").attr("dx", "20")
    .attr("dy", "30")
    .text("Select the correct value:")
    .style("fill", "#ff0000")
    .style("font-size", "15px");

    popUp.append("svg:circle").attr("r", 10).style("fill", "#FF0000")
    .attr("cx", 50)
    .attr("cy", 70)
  //  .on("click", updateScore);

    popUp.append("text").attr("dx", "65")
    .attr("dy", "74")
    .text("very negative")
    .style("fill", "#000")
    .style("font-size", "15px")
  //  .on("click", updateScore);


    popUp.append("svg:circle").attr("r", 10).style("fill", "#FF7F00")
    .attr("cx", 50)
    .attr("cy", 95);

    popUp.append("text").attr("dx", "65")
    .attr("dy", "99")
    .text("negative")
    .style("fill", "#000")
    .style("font-size", "15px")

    popUp.append("svg:circle").attr("r", 10).style("fill", "#FFFF00")
    .attr("cx", 50)
    .attr("cy", 120);

     popUp.append("text").attr("dx", "65")
    .attr("dy", "124")
    .text("neutral")
    .style("fill", "#000")
    .style("font-size", "15px")

    popUp.append("svg:circle").attr("r", 10).style("fill", "#7FFF00")
    .attr("cx", 50)
    .attr("cy", 145);

    popUp.append("text").attr("dx", "65")
    .attr("dy", "149")
    .text("positive")
    .style("fill", "#000")
    .style("font-size", "15px")

    popUp.append("svg:circle").attr("r", 10).style("fill", "#00FF00")
    .attr("cx", 50)
    .attr("cy", 170);

    popUp.append("text").attr("dx", "65")
    .attr("dy", "174")
    .text("very positive")
    .style("fill", "#000")
    .style("font-size", "15px");

    popUp.append("svg:rect").attr("width", "100")
    .attr("height", "30")
    .style("fill", "#3b3b3b")
    .attr("rx","5")
    .attr("ry","5")
    .style("stroke", "#000")
    .style("stroke-width", "2")
    .attr("x", 50)
    .attr("y", 200)
    .on("click", function() { this.parentElement.remove();});

    popUp.append("text").attr("dx", "77")
    .attr("dy", "220")
    .text("Dismiss")
    .style("fill", "#fff")
    .style("font-size", "15px");

  }

  nodeEnter.append("svg:circle")
      .attr("r", 1e-7)
      .style("fill", function(d) { return colorCodes[d.score]; })
      .on("mouseover", phraseTooltip)
      .on("mouseout", tip.hide)
      .on("dblclick", suggestScore);


  nodeEnter.append("svg:text")
      .attr("y", function(d) { return d.children || d._children ? -10 : 10; })
      .attr("dx", -10)
      .attr("dy", 20)
      .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
      .text(function(d) { return d.label; })
      .style("fill-opacity", 1e-6);

  /* Create the text for each block */
  nodeEnter.append("svg:text")
      .attr("dx", -3)
      .attr("dy", 3)
      .text(function(d){return d.score;})
      .style("fill", "#000")

      .on("mouseover", phraseTooltip)
      .on("mouseout", tip.hide);


  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });


  
  nodeUpdate.select("circle")
      .attr("r", 10)
      .style("fill", function(d) { return colorCodes[d.score]; });

  
  nodeUpdate.select("text")
      .style("fill-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
      .remove();

  nodeExit.select("circle")
      .attr("r", 1e-6);

  nodeExit.select("text")
      .style("fill-opacity", 1e-6);

  // Update the links
  var link = vis.selectAll("path.link")
      .data(tree.links(nodes), function(d) { return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("svg:path", "g")
      .attr("class", "link")
      .attr("d", function(d) {
    var o = {x: source.x0, y: source.y0};
    return diagonal({source: o, target: o});
      })
      .transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition links to their new position.
  link.transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
      .duration(duration)
      .attr("d", function(d) {
    var o = {x: source.x, y: source.y};
    return diagonal({source: o, target: o});
      })
      .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
      d.x0 = d.x;
      d.y0 = d.y;
  });
    }

    // Toggle children.
    function toggle(d) {
  if (d.children) {
      d._children = d.children;
      d.children = null;
  } else {
      d.children = d._children;
      d._children = null;
  }
    }
};