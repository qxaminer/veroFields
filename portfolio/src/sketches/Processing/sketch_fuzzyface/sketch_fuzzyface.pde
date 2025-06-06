//grayscale value determines the . size pixelrep

// Example: Draw circles whose size is based on grayscale value at each pixel
PImage img;
void setup() {
  size(400, 400);
  img = loadImage("spFuzzy.jpg"); // Replace with your image
  img.resize(width, height);
  noStroke();
}

void draw() {
  background(255);
  for (int gridX = 0; gridX < img.width; gridX++) {
    for (int gridY = 0; gridY < img.height; gridY++) {
      color c = img.get(gridX, gridY);
      float g = brightness(c); // Or use red(c) for grayscale images
      float sz = map(g, 0, 255, 2, 10); // Map grayscale to size
      fill(c);
      ellipse(gridX * 10, gridY * 10, sz, sz); // Adjust spacing as needed
    }
  }
  noLoop();
}
