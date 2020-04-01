enum MovingType { LINEAR, SINUSOIDAL, CIRCULAR }
static final int SPEED_UP_KEY = 43, SLOW_DOWN_KEY = 45, LINEAR_KEY = 108, SINUSOIDAL_KEY = 115, CIRCULAR_KEY = 99;
final float R = 200, C_X = 320, C_Y = 240, AMPLITUDE = 50, FREQUENCY = 0.05;

class Logo {
  private float x;
  private float y;
  private float w;
  private float h;
  
  private PShape leftPart;
  private PShape rightPart;
  private PShape body;
  private PShape logo;
  
  private MovingType type = MovingType.LINEAR;
  
  private int negation = 1;
  private int negationY = 1;
  
    
  Logo(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    logo = createShape(GROUP);
    
    strokeWeight(20);
    strokeJoin(ROUND);    
    
    initLeftPart();
    initRightPart();
    initBody();

    logo.addChild(leftPart);
    logo.addChild(rightPart);
    logo.addChild(body);
  }
  
  
  void move(float speed) {
    switch (type) {
        case LINEAR:
          move(speed, speed);
          break;
        case SINUSOIDAL:
          moveSinusoidal(speed);
          break;
        case CIRCULAR:
          moveCircular(speed);
          break;
    }
  }
  
  private void move(float speedX, float speedY) {
    if (getX() + getW() > width || getX() < 10)  negation *= -1;
    if (getY() + getH() > height || getY() < 10) negationY *= -1;
    x += speedX * negation;
    y += speedY * negationY;
    draw();
  }
  
  private void moveCircular(float speed) {
    x += negation * speed;
    y = roundEq(x, negation);
    draw();
    if (x - C_X > (R-speed) || x - C_X < -R) {
      negation *= -1;
    }
  }
  
  private void moveSinusoidal(float speed) {
    x += negation * speed;
    y = AMPLITUDE * cos(FREQUENCY * x) + height/2;
    draw();
    if (x + getW() > width || x < 0) negation *= -1;
  }
  
  void draw() {
    shape(logo, x, y);
  }
    
  private void initBody() {
    stroke(color(200, 0, 0));
    body = createShape();
    body.beginShape();
    body.fill(color(200, 0, 0));
    body.vertex(w, 2*h);
    body.quadraticVertex(2*w, 4*h, 3*w, 2*h);
    body.vertex(2*w, h);
    body.vertex(w, 2*h);
    body.endShape();
  }
  
  private void initLeftPart() {
    stroke(color(255, 165, 0));
    leftPart = createShape();
    leftPart.beginShape();
    leftPart.fill(color(255, 165, 0));
    leftPart.vertex(0, 0);
    leftPart.vertex(w, 2*h);
    leftPart.vertex(2*w, h);
    leftPart.vertex(0, 0);
    leftPart.endShape();
  }
  
  private void initRightPart() {
    stroke(color(128, 0, 128));
    rightPart = createShape();
    rightPart.beginShape();
    rightPart.fill(color(128, 0, 128));
    rightPart.vertex(2*w, h);
    rightPart.vertex(3*w, 2*h);
    rightPart.vertex(4*w, 0);
    rightPart.vertex(2*w, h);
    rightPart.endShape();
  }
  
  float getH() { return 4*h + 10; }
  float getW() { return 4*w + 10; }
  float getX() { return x; }
  float getY() { return y; }
  void setMovingType(MovingType type) { this.type = type; }
}

boolean isMoving = true;
Logo []logos = { null, null, null, null, null };
float x, y;

void setup() {
  size(1280, 720);
  background(255);
  frameRate(60);

  x = C_X - R;
  y = roundEq(x, 1);
  
  logos[0] = new Logo(x, y, 50, 42);
  logos[0].draw();
  
  logos[1] = new Logo(x + 200, y, 50, 42);
  logos[1].setMovingType(MovingType.SINUSOIDAL);
  logos[1].draw();
  
  logos[2] = new Logo(x + 200, y + 100, 50, 42);
  logos[2].setMovingType(MovingType.CIRCULAR);
  logos[2].draw();
  
  logos[3] = new Logo(x + 200, y - 50, 50, 42);
  logos[3].setMovingType(MovingType.SINUSOIDAL);
  logos[3].draw();
  
  logos[4] = new Logo(400, 300, 50, 42);
  logos[4].draw();
  
  noLoop();
}

float speed = 3;
MovingType type = MovingType.LINEAR;

void draw() {
  background(255);
  for (Logo logo : logos) {
    if (logo != null)
      logo.move(speed);
  }
}

void mousePressed() {
  toggleLoop();
}

void toggleLoop() {
  if (isMoving)
    loop();
  else
    noLoop();
  isMoving = !isMoving;
}

synchronized void keyTyped() {
  if(int(key) == SPEED_UP_KEY) {
      speedUp();
  }
  
  if(int(key) == SLOW_DOWN_KEY) {
      slowDown();
  }  
  
  if(int(key) == LINEAR_KEY)
    type = MovingType.LINEAR;
  else if(int(key) == CIRCULAR_KEY)
    type = MovingType.CIRCULAR;
  else if(int(key) == SINUSOIDAL_KEY)
    type = MovingType.SINUSOIDAL; 
    
  println("Moving type is " + type);
  println("Speed is " + speed);
}

synchronized void speedUp() {
  if(speed < 200) {
    speed *= 1.05;
  } else {
    print("Reached max speed - 200");
  }
}

synchronized void slowDown() {
  speed *= 0.95;
}

float roundEq(float x, int negation) {
  Double pos = (double)sqrt(R*R - pow(x - C_X, 2)) * negation;
  return (float)(C_Y + (Double.isNaN(pos) ? 0 : pos));
}
