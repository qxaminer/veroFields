int r = 0;
int g = 0;
int b = 0;
float diameter = 20;

void setup() {
  size(400, 400);
}

void draw() {
  background(255);
  
  // Define the square area
  float squareSize = 300;
  float squareX = (width - squareSize) / 2;
  float squareY = (height - squareSize) / 2;
  
  // Draw the square
  noFill();
  stroke(0);
  rect(squareX, squareY, squareSize, squareSize);
  
  // Draw the three circles inside the square
  drawCircle(squareX + squareSize / 4, squareY + squareSize / 2, r, 0, 0);
  drawCircle(squareX + squareSize / 2, squareY + squareSize / 2, 0, g, 0);
  drawCircle(squareX + 3 * squareSize / 4, squareY + squareSize / 2, 0, 0, b);
  
  // Iterate the diameter of the circles
  diameter = map(sin(frameCount * 0.05), -1, 1, 20, 80);
  
  // Increment the RGB values by 5
  r = (r + 5) % 256;
  g = (g + 5) % 256;
  b = (b + 5) % 256;
}

void drawCircle(float x, float y, int red, int green, int blue) {
  fill(red, green, blue);
  ellipse(x, y, diameter, diameter);
}
