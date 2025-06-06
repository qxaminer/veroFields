// Global declarations
float x, y, w, h;
float spdX, spdY;
color fillCol, strokeCol;

// Ellipse position
float ellX, ellY;
float ellSize = 100;

// --- NEW low‑pass filter vars --- //modelcom
float grayNow  = random(255);   // current displayed brightness          //modelcom
float grayNext = random(255);   // next random target brightness         //modelcom
float lerpAmt  = 0.05;          // <‑‑ change this to tweak flicker speed //modelcom
// ↑ lower = slower, smoother fades | higher = snappier changes          //modelcom

void setup() {
  size(1960, 975);
  initSquare();            // Initialize the moving square

  ellX = width / 2;        // Center the ellipse
  ellY = height / 2;
}

void draw() {
  background(127);

  // --- Smooth‑random ellipse via lerp() --- //modelcom
  grayNow = lerp(grayNow, grayNext, lerpAmt);      // ease toward target       //modelcom
  if (abs(grayNow - grayNext) < 1) grayNext = random(255); // pick new target  //modelcom
  fill(grayNow);
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

  // Respawn if off screen
  if (x > width || x + w < 0 || y > height || y + h < 0) initSquare();
}

// Initialize square properties
void initSquare() {
  w = 150;
  h = 60;
  x = random(width - w);
  y = random(height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);

  if (spdX == 0 && spdY == 0) { spdX = 1; spdY = 1; }

  fillCol = color(random(255), random(255), random(255));
  strokeCol = color(random(115), 80, random(45));
}
