import java.util.*;

Set<Rect> rects = new HashSet<Rect>();
Deque<Point> mousePoints = new LinkedList<Point>();

void setup(){
  size(800, 600);
  strokeWeight(2);
  //rects.add(new Rect(200, random(300, 400), random(300, 500), 100));
  rects.add(new Rect(50, 50 + random(100, 250), 50 + random(100, 250), 50));
  rects.add(new Rect(150, 150 + random(100, 250), 150 + random(100, 250), 150));
  rects.add(new Rect(300, 300 + random(100, 250), 300 + random(100, 250), 300));
}

void draw() {}

void mousePressed(){
    mousePoints.add(new Point(mouseX, mouseY));
    if (mousePoints.size() >= 2)
       check(); 
}

void check() { 
  Point p1 = mousePoints.pop();
  Point p2 = mousePoints.pop();
  pushMatrix();
  strokeWeight(2);
  stroke(255, 0, 0);
  line(p1.x, p1.y, p2.x, p2.y);
  popMatrix();
  for (Rect r: rects)
    r.checkForIntersection(p1, p2);
}

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

class Rect {
  private Point min;
  private Point max;
  
   Rect(float xMin, float yMin, float xMax, float yMax){
    min = new Point(xMin, yMax);
    max = new Point(xMax, yMin);
    stroke(255, 0, 0);
    this.drawSides();
  }
  
     
  public void drawSides(){
    stroke(0, 0, 255);
    line(min.x, min.y, max.x, min.y);
    line(max.x, max.y, min.x, max.y);
    line(max.x, min.y, max.x, max.y);
    line(min.x, max.y, min.x, min.y);
  }
  
  public void checkForIntersection(Point p1, Point p2) {
    println("Line: " + p1 + "; " + p2);
    float[] points = { p1.x - min.x, max.x - p1.x, p1.y - min.y, max.y - p1.y };
    Point delta = new Point(p2.x - p1.x, p2.y - p1.y);
    float[] p = { -delta.x, delta.x, -delta.y, delta.y };
    
    for(int i = 0; i < p.length; i++)
      if(p[i] == 0 && points[i] < 0)
        return;
       
    List<Float> valuesT0 = new ArrayList<Float>();
    List<Float> valuesT1 = new ArrayList<Float>();
    
    valuesT0.add(0.0);
    valuesT1.add(1.0);
    
    for(int i = 0; i < p.length; i++)
      if(p[i] < 0)
        valuesT0.add(points[i] / p[i]);
      else if (p[i] > 0)
        valuesT1.add(points[i] / p[i]);
    
    float t0 = Collections.max(valuesT0);
    float t1 = Collections.min(valuesT1);
    
    if(t0 > t1){
      println("No intersection");
      return;
    }    
    Point intersectionPoint1 = new Point(p1.x + t0 * delta.x, p1.y + t0 * delta.y);
    Point intersectionPoint2 = new Point(p1.x + t1 * delta.x, p1.y + t1 * delta.y);
    println("Intersection: " + intersectionPoint1 + "; " + intersectionPoint2); 
    stroke(55, 255, 55);
    strokeWeight(4);
    line(intersectionPoint1.x, intersectionPoint1.y ,intersectionPoint2.x, intersectionPoint2.y);
  } 
}
