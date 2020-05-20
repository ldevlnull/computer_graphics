int hw, hh; // half-width and half-height
final int scale = 50;

void setup() {
  size(1280, 720);
  hw = width/2;
  hh = height/2;
  translate(hw, hh);
  drawAxes();
  //line(-3*scale, 4*scale, 2*scale, -6*scale);
  lineBrez(-3*scale, 4*scale, 2*scale, -6*scale);
  //drawShape();
}

void drawAxes() {
  stroke(20);
  line(-hw, 0, hw, 0);
  line(0, -hh, 0, hh);
  for (int x = 0; x <= hw; x += scale) {
      if (x == 0) continue;
      text(x/scale, x, 12);
      text(-x/scale, -x, 12);
  }
  for (int y = 0; y <= hh; y += scale) {
      text(-y/scale, 4, y);
      text(y/scale, 4, -y);
  }
}

void drawShape() {
  lineBrez(-3*scale, 0, 0, -6*scale);
  lineBrez(3*scale, 0, 0, -6*scale);
  lineBrez(-3*scale, 0, 0, 6*scale);
  lineBrez(3*scale, 0, 0, 6*scale);
  
  lineBrez(-2*scale, 0, 0, -4*scale);
  lineBrez(2*scale, 0, 0, -4*scale);
  lineBrez(-2*scale, 0, 0, 4*scale);
  lineBrez(2*scale, 0, 0, 4*scale);
  
  lineBrez(-3*scale, 0, -2*scale, 0);
  lineBrez(3*scale, 0, 2*scale, 0);
  lineBrez(0, -6*scale, 0, -4*scale);
  lineBrez(0, 6*scale, 0, 4*scale);
}

void lineBrez(int x1, int y1, int x2, int y2) {
  int x, y, dx, dy, incx, incy, pdx, pdy, es, el, err;
   
  dx = x2 - x1;
  dy = y2 - y1;
   
  incx = sign(dx);
  incy = sign(dy);
   
  if (dx < 0) 
    dx = -dx;
  if (dy < 0) 
    dy = -dy;
   
  if (dx > dy) {
    pdx = incx;     
    pdy = 0;
    es = dy;        
    el = dx;
  } else {
    pdx = 0;        
    pdy = incy;
    es = dx;        
    el = dy;
  }
   
  x = x1;
  y = y1;
  err = el/2;
  line (x, y, x, y);
  
  for (int t = 0; t < el; t++) {
    err -= es;
    if (err < 0) {
      err += el;
      x += incx;
      y += incy;
    } else {
      x += pdx;
      y += pdy;
    }
    line (x, y, x, y);
    if (t%scale == 0)
       print(String.format("x = %d\ty = %d%n", x/scale, y/scale));
  }
}

int sign(int x) {
  return (x > 0) ? 1 : (x < 0) ? -1 : 0;
}
