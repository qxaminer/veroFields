// Global declarations
float x, y, w, h;
float spdX, spdY;
color fillCol, strokeCol;

// Ellipse position
float ellX, ellY;
float ellSize = 100;

// --- NEW noise variables --- //modelcom
float noisePos = 0;      // where we are sampling the noise field //modelcom
float noiseStep = 0.01;  // how fast the brightness drifts         //modelcom

void setup() {
  size(1960, 975);
  initSquare();          // Initialize the moving square

  // Set ellipse to a fixed position (centered)
  ellX = width / 2;
  ellY = height / 2;
}

void draw() {
  background(127);

  // --- Smooth‑grayscale Ellipse (Perlin noise) --- //modelcom
  float grayValue = noise(noisePos) * 255;   // noise() → smooth 0‑1; remap to 0‑255 //modelcom
  noisePos += noiseStep;                     // advance through noise field            //modelcom
  fill(grayValue);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // --- Moving Square (unchanged) ---
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // Update position
  x += spdX;
  y += spdY;

  // Check if square moved off screen
  if (x > width || x + w < 0 || y > height || y + h < 0) {
    initSquare();
  }
}

// Initialize square properties
void initSquare() {
  w = 150;
  h = 60;
  x = random(width - w);
  y = random(height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);

  // Avoid zero speed
  if (spdX == 0 && spdY == 0) {
    spdX = 1;
    spdY = 1;
  }

  fillCol = color(random(255), random(255), random(255));
  strokeCol = color(random(115), 80, random(45));
}
