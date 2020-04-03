PImage apple, pen;
double BLUR_SENSIVITY = 80;

void setup() {
  size(600, 600);
  apple = loadImage("apple.png");
  pen = loadImage("pen.png");
  noSmooth();
}

void draw() {
  PImage applepen = diffImages(pen, apple); // накладання зображень 
  applepen = mirrorDiagonally(applepen); // відображення по діагоналі  
  applepen = blurImage(apple, 5); // розмиття на 5*5
  //applepen = apple; // оригінальне зображення
  image(applepen, 0, 0);
  noLoop();
}

synchronized PImage diffImages(PImage img1, PImage img2) {
  PImage resImage = createImage(img1.width, img1.height, 0);
  resImage.loadPixels();
  int a, b;
  for (int i = 0; i < resImage.pixels.length; i++) {
    a = img2.pixels[i];
    b = img1.pixels[i];
    if (a == 0)
      continue;
    resImage.pixels[i] = color(red(a) - red(b), green(a) - green(b), blue(a) - blue(b));
  }
  resImage.updatePixels();
  return resImage;
}

synchronized PImage mirrorDiagonally(PImage img) {
  PImage resImage = createImage(img.width, img.height, 0);
  resImage.loadPixels();
  int size = resImage.pixels.length;
  for (int i = 0; i < size; i++) {
    resImage.pixels[size-i-1] = img.pixels[i];
  }
  resImage.updatePixels();
  return resImage;
}

synchronized PImage blurImage(PImage img, int rate) {
  PImage resImage = createImage(img.width, img.height, 0);
  resImage.loadPixels();
  int koef = floor(rate/2);  

  final int H = img.height;
  final int W = img.width;

  for (int x = koef; x < W; x++) // проходимось по кожному пікселю всього зображення
    for (int y = koef; y < H; y++) {
      int newPixelRed = 0, newPixelGreen = 0, newPixelBlue = 0;
      for (int i = -koef; i <= koef; i++) // проходимось по всім "сусідам" пікселя
        for (int j = -koef; j <= koef; j++) {
          newPixelRed += red(img.pixels[x + i + (y + j) * (W - koef)]);
          newPixelGreen += green(img.pixels[x + i + (y + j) * (W - koef)]);
          newPixelBlue += blue(img.pixels[x + i + (y + j) * (W - koef)]);
        }
        newPixelRed = (int)(newPixelRed / (rate*rate) + 0.9);
        newPixelGreen = (int)(newPixelGreen / (rate*rate) + 0.9);
        newPixelBlue = (int)(newPixelBlue / (rate*rate) + 0.9);
        // // розкоментуй цей рядок, якщо хочеш на виході мати png (тобто без рамки)
        //if (!(newPixelRed < BLUR_SENSIVITY && newPixelGreen < BLUR_SENSIVITY && newPixelBlue < BLUR_SENSIVITY))       
        resImage.pixels[x + y * (W - koef)] = color(newPixelRed, newPixelGreen, newPixelBlue);
    }

  resImage.updatePixels();
  return resImage;
}
