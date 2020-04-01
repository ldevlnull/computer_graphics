class Point {
  private float x;
  private float y;
    
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void draw() {  
    strokeWeight(10);
    point(x, y);
  }
  
  float getX() { return x; }
  float getY() { return y; }
}

class Circle {
   private Point center;
   private float radius;
   
   Circle(float x, float y, float radius) {
     this(new Point(x, y), radius);
   }
   
   Circle(Point center, float radius) {
     this.center = center;
     this.radius = radius;
   }
   
   void draw() {
     strokeWeight(3);
     circle(center.getX(), center.getY(), radius);
   }
   
   Point getCenter() { return center; }
   float getRadius() { return radius*0.5; }
   
}

class Line {
  private Point p1;
  private Point p2;
  
  Line(float x1, float y1, float x2, float y2) {
    this(new Point(x1, y1), new Point(x2, y2));
  }
  
  Line(Point p1, Point p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
  
  void draw() {
    strokeWeight(3);
    line(p1.getX(), p1.getY(), p2.getX(), p2.getY());
  }
  
  boolean isPointOnLine(Point p) {
    return (p.getX() - p1.getX()) / (p2.getX() - p1.getX()) ==  (p.getY() - p1.getY()) / (p2.getY() - p1.getY());
  }
  
  Point getP1() { return p1; }
  Point getP2() { return p2; }
}

Point pC, pQ1, pQ2, pP1, pP2, pL, pN1;
Circle c;
Line l1, l2;

void setup() {
  size(1024, 1024);
  render(width*0.5, height*0.7);
}

void draw() {
  pC.draw();
  c.draw();
  pL.draw();
  pP1.draw();
  l1.draw();
  pP2.draw();
  l2.draw();
}

void mouseClicked() {
  render(mouseX, mouseY);
}

void render(float circleX, float circleY) {
  background(255);
  pC = new Point(width*0.5, height*0.7);
  pL = new Point(circleX, circleY);
  c = new Circle(pL, 100);
  
  float Nx1, Ny1, Nx2, Ny2, pLsquareSum, D, Px1, Py1, Px2, Py2;
  pLsquareSum = pow(pL.getX(), 2) + pow(pL.getY(), 2);
  D = 4*(pow(c.getRadius(), 2) * pow(pL.getX(), 2) - pLsquareSum * (pow(c.getRadius(), 2) - pow(pL.getY(),2)));
  
  Nx1 = (c.getRadius() * pL.getX() + sqrt(D/4)) / pLsquareSum;
  Ny1 = (c.getRadius() - Nx1*pL.getX()) / pL.getY();
  
  Px1 = pL.getX() - c.getRadius() * Nx1;
  Py1 = pL.getY() - c.getRadius() * Ny1;
  pP1 = new Point(Px1, Py1);
  l1 = new Line(pC, pP1);
  
  Nx2 = (c.getRadius() * pL.getX() - sqrt(D/4)) / pLsquareSum;
  Ny2 = (c.getRadius() - Nx2 * pL.getX()) / pL.getY();
  
  Px2 = pL.getX() - c.getRadius() * Nx2;
  Py2 = pL.getY() - c.getRadius() * Ny2;
  pP2 = new Point(Px2, Py2);
  l2 = new Line(pC, pP2);
}
