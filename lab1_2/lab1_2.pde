void setup() {
  size(1024, 1024);
  strokeWeight(5);
}

void draw() {
  float startX = width * 0.5, startY = height * 0.9, startW = width * 0.5, startH = startW * 0.2;
  float scale;
  int i = 0;
  do {
    scale = startW - i*width*0.05;
    if(i % 2 == 0)
      fill(random(0, 255), random(0, 255), random(0, 255));
    if(i % 3 == 0)
      strokeWeight(random(1, 5)*3);
    ellipse(startX, startY - i * startH, scale, startH);
    i++;
  } while (scale > startH);
  noLoop();
}

void mouseClicked() {
  redraw();
}
