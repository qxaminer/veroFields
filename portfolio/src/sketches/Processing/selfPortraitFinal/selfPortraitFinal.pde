PImage[] imgs = new PImage[2];
int nextSwap;
int cur = 0;
//nextSwap holds the future time (in milliseconds) when 
//the next image flip should occur.
//cur tracks which image is currently being displayed — either 0 or 1.
int interval = 40;
float alphaVal = 0;
float alphaStep = 5;
//alphaVal is the current alpha (transparency) level used to tint the image.
//alphaStep controls how quickly the alpha changes — 
//this creates the pulsing effect.

void setup() {
  size(800, 600);
  imageMode(CENTER);

  imgs[0] = loadImage("sPclear.jpeg");
  imgs[1] = loadImage("selfPortFuzz.jpeg");

  nextSwap = millis() + interval;
}

void draw() {
  background(0);

  if (millis() >= nextSwap) {
    cur = 1 - cur;
    nextSwap = millis() + (int)random(60, 150);
  }

  alphaVal += alphaStep;
  if (alphaVal > 255 || alphaVal < 0) {
    alphaStep *= -1;
    alphaVal = constrain(alphaVal, 0, 255);
  }

  tint(255, alphaVal);

  float scaleFactor = min((float)width / imgs[cur].width, (float)height / imgs[cur].height);
  float imgWidth = imgs[cur].width * scaleFactor;
  float imgHeight = imgs[cur].height * scaleFactor;

  image(imgs[cur], width / 2, height / 2, imgWidth, imgHeight);
}
