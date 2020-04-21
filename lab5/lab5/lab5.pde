Snake []snakes = { new Snake(), new Snake() };
Food food;
Mushroom mushroom;
int highScore;

void setup(){
  size(1000, 600);
  frameRate(30);
  food = new Food();
  mushroom = new Mushroom();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  
  highScore = 0;
}

void draw(){
  background(250, 250, 250);
  drawScoreboard();
  
  food.display();
  mushroom.display();
  
  for (Snake snake: snakes) {
    snake.move();
    snake.display();
    
    if(dist(food.xpos, food.ypos, snake.xpos.get(0), snake.ypos.get(0)) < snake.sidelen) {
      food.reset();
      snake.addLink();
    }
    
    if(dist(mushroom.xpos, mushroom.ypos, snake.xpos.get(0), snake.ypos.get(0)) < snake.sidelen) {
      mushroom.reset();
      snake.removeLink();
    }
    
    if(snake.len > highScore){
      highScore= snake.len;
    }
  }
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == LEFT){
      snakes[0].dir = "left";
    }
    if(keyCode == RIGHT){
      snakes[0].dir = "right";
    }
    if(keyCode == UP){
      snakes[0].dir = "up";
    }
    if(keyCode == DOWN){
      snakes[0].dir = "down";
    }
  }
  switch ((""+key).toLowerCase()) {
    case "w": snakes[1].dir = "up"; break;
    case "s": snakes[1].dir = "down"; break;
    case "a": snakes[1].dir = "left"; break;
    case "d": snakes[1].dir = "right"; break;
    default: break;
  }
}


  void drawScoreboard(){ 
    // draw scoreboard
    stroke(179, 140, 198);
    fill(255, 0 ,255);
    rect(90, 70, 160, 80);
    fill(118, 22, 167);
    textSize(17);
    text("Score1: " + snakes[0].len, 70, 50);
    text("Score2: " + snakes[1].len, 70, 70);
    
    fill(118, 22, 167);
    textSize(17);
    text( "High Score: " + highScore, 70, 90);
  }

class Food{
  float xpos, ypos;
  
    //constructor
  Food(){
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
  }
    
  // functions
 void display(){
   fill(0, 255, 0);
   ellipse(xpos, ypos, 17, 17);
 }
 
  void reset(){
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
 }   
}

class Mushroom extends Food {

  Mushroom() {
    super();
  }
  
  @Override
  void display() {
    fill(255, 0, 0);
    ellipse(xpos, ypos, 17, 17);
  }
  
}

class Snake{
  
  //define varibles
  int len;
  float sidelen;
  String dir; 
  ArrayList <Float> xpos, ypos;
  
  // constructor
  Snake(){
    len = 1;
    sidelen = 17;
    dir = "right";
    xpos = new ArrayList();
    ypos = new ArrayList();  
    xpos.add(random(width));
    ypos.add(random(height));
  }
  
  
  void move(){
   for(int i = len - 1; i > 0; i = i -1 ){
    xpos.set(i, xpos.get(i - 1));
    ypos.set(i, ypos.get(i - 1));  
   } 
   if(dir == "left"){
     xpos.set(0, xpos.get(0) - sidelen);
   }
   if(dir == "right"){
     xpos.set(0, xpos.get(0) + sidelen);
   }
   
   if(dir == "up"){
     ypos.set(0, ypos.get(0) - sidelen);
  
   }
   
   if(dir == "down"){
     ypos.set(0, ypos.get(0) + sidelen);
   }
   xpos.set(0, (xpos.get(0) + width) % width);
   ypos.set(0, (ypos.get(0) + height) % height);
   
    // check if hit itself and if so cut off the tail
    if(checkHit()){
      len = 1;
      float xtemp = xpos.get(0);
      float ytemp = ypos.get(0);
      xpos.clear();
      ypos.clear();
      xpos.add(xtemp);
      ypos.add(ytemp);
    }
  }
  
  
  
  void display(){
    for(int i = 0; i <len; i++){
      stroke(179, 140, 198);
      fill(100, 0, 100, map(i-1, 0, len-1, 250, 50));
      rect(xpos.get(i), ypos.get(i), sidelen, sidelen);
    }  
  }
  
  
  void addLink(){
    xpos.add( xpos.get(len-1) + sidelen);
    ypos.add( ypos.get(len-1) + sidelen);
    len++;
  }
  
  void removeLink() {
    if (len == 1) return;
    xpos.remove(len-1);
    ypos.remove(len-1);
    len--;
  }
  
   boolean checkHit(){
    for(int i = 1; i < len; i++){
     if( dist(xpos.get(0), ypos.get(0), xpos.get(i), ypos.get(i)) < sidelen){
       return true;
     } 
    } 
    return false;
   } 
}
