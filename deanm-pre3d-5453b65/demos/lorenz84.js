// (c) Dean McNamee <dean@gmail.com>.  All rights reserved.

// Inspired by http://www.unitzeroone.com/labs/alchemyPushingPixels/
// Also reading 'Strange Attractors: Creating Patterns in Chaos'.
// This attractor is Lorenz-84, with parameters from chaoscope.
var refresh=function() {
	var inputs=document.getElementsByName('input');
	console.log("inputs",inputs);
	
	console.log(inputs.length);
	
	for(key in inputs) if(key!="item" && key!="length"){
		inputs[key].addEventListener("change",refresh, false);
	}



  var screen_canvas = document.getElementById('canvas');
  var renderer = new Pre3d.Renderer(screen_canvas);

  renderer.ctx.lineWidth = 0.2;

  var x = 1;
  var y = 1;
  var z = 1;
  
	var values = [
		parseFloat(document.getElementById('one').value) || 0,
		parseFloat(document.getElementById('two').value) || 0,
		parseFloat(document.getElementById('three').value) || 0,
		parseFloat(document.getElementById('four').value) || 0,
		parseFloat(document.getElementById('five').value) || 0,
		parseFloat(document.getElementById('six').value) || 0,
		parseFloat(document.getElementById('seven').value) || 0,
		parseFloat(document.getElementById('eight').value) || 0,
		parseFloat(document.getElementById('nine').value) || 0
	];
  function step() {
    var dx = (values[0] * x - y * y - z * z + values[1] * values[2]) * values[3];
    var dy = (-y + x * y - values[4] * x * z + values[5]) * values[6];
    var dz = (-z + values[7] * x * y + x * z) * values[8];

    x += dx;
    y += dy;
    z += dz;

    return {x: x, y: y, z: z};
  }

  var N = 7000;
  var path = new Pre3d.Path();
  path.points = new Array(N * 2 + 1);
  path.curves = new Array(N);

  // Warm up a bit so we don't get a cast from the origin into the attractor.
  for (var i = 0; i < 10; ++i)
    step();

  // Setup our initial point, |p0| will track our previous end point.
  var p0 = step();
  path.points[path.points.length - 1] = p0;
  path.starting_point = path.points.length - 1;

  for (var i = 0; i < N; ++i) {
    path.curves[i] = new Pre3d.Curve(i * 2, i * 2 + 1, null);  // Quadratic.

    var p1 = step();
    var p2 = step();
    path.points[i * 2 + 1] = Pre3d.PathUtils.fitQuadraticToPoints(p0, p1, p2);
    path.points[i * 2] = p2;
    p0 = p2;
  }

  var colormap = [
    {n: 'r', c: new Pre3d.RGBA(1, 0, 0, 1)},
    {n: 'g', c: new Pre3d.RGBA(0, 1, 0, 1)},
    {n: 'b', c: new Pre3d.RGBA(0, 0, 1, 1)},
    {n: 'a', c: new Pre3d.RGBA(0, 1, 1, 1)},
    {n: 'y', c: new Pre3d.RGBA(1, 1, 0, 1)},
    {n: 'w', c: new Pre3d.RGBA(1, 1, 1, 1)}
  ];
 
  var fgcolor = new Pre3d.RGBA(1, 1, 1, 1);

  function draw() {
    renderer.ctx.setFillColor(0, 0, 0, 1);
    renderer.drawBackground();

    renderer.ctx.setStrokeColor(fgcolor.r, fgcolor.g, fgcolor.b, fgcolor.a);
    renderer.drawPath(path);
  }

  var colordiv = document.createElement('div');
  colordiv.appendChild(document.createTextNode('color \u2192 '));
  for (var i = 0, il = colormap.length; i < il; ++i) {
    var cm = colormap[i];
    var a = document.createElement('a');
    a.href = '#';
    a.onclick = (function(c) {
      return function() {
        fgcolor = c.c
        draw();
        return false;
      }
    })(cm);
    a.appendChild(document.createTextNode(cm.n));
    colordiv.appendChild(a);
  }
//  document.body.insertBefore(colordiv, document.body.firstChild);

  renderer.camera.focal_length = 2.5;
  DemoUtils.autoCamera(renderer, 0, 0, -15, 0, -1.7, 0, draw);

  draw();
}; 
window.addEventListener('load', refresh, false);


