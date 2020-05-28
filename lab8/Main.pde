int hw, hh; // half-width and half-height
final int scale = 1;

class Point {
  private float x;
  private float y;
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  @Override
  public String toString() {
    return String.format("(%.2f, %.2f)", x, y);
  }
}

class Line {
  private Point start;
  private Point end;
  
   public Line(Point start, Point end){
     this.start = start;
     this.end = end;
   }
   
  public void build() {
    line(start.x, -start.y, end.x, -end.y);
  }
  
  public Line scale(int k) {
    Point p1 = new Point(k * start.x, k * start.y);
    Point p2 = new Point(k * end.x, k * end.y);
    println("scaled point1 = " + p1);
    println("scaled point2 = " + p2);
    return new Line(p1, p2);
  }
  
  public Line scale(int k, Point p) {
    Point p1 = new Point(
      k * (start.x - p.x) + p.x, 
      k * (start.y - p.y) + p.y
    );
    Point p2 = new Point(
      k * (end.x - p.x) + p.x, 
      k * (end.y - p.y) + p.y
    );
    println("scaled point1 = " + p1);
    println("scaled point2 = " + p2);
    return new Line(p1, p2);
  }
   
  @Override
  public String toString() {
    return String.format("(%s; %s)", start, end);
  }
}

void drawAxes() {
  stroke(20);
  line(-hw, 0, hw, 0);
  line(0, -hh, 0, hh);
  for (int x = 0; x <= hw; x += 40) {
      if (x == 0) continue;
      text(x/scale, x, 12);
      text(-x/scale, -x, 12);
  }
  for (int y = 0; y <= hh; y += 20) {
      text(-y/scale, 4, y);
      text(y/scale, 4, -y);
  }
}

void setup() {
  size(1280, 720);
  hw = width/2;
  hh = height/2;
  
}

void draw() {
  // (-74, 34)  (19, 120)
  translate(hw, hh);
  drawAxes();
  Point p1, p2;
  p1 = new Point(-74, 34);
  p2 = new Point(19, 120);
  Line line = new Line(p1, p2);
  
  stroke(255, 0, 0);
  line.build();
  stroke(0, 0, 255);
  line.scale(3).build();
  stroke(200, 0, 200);
  Point cp = new Point(20, 40);
  strokeWeight(8);
  point(cp.x, -cp.y);
  strokeWeight(2);
  line.scale(3, cp).build();
  noLoop();
}
