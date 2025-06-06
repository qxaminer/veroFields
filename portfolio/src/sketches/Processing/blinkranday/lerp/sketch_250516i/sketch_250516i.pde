// Global declarations
float x, y, w, h;
float spdX, spdY;
color fillCol, strokeCol;

// Ellipse position
float ellX, ellY;
float ellSize = 100;

// --- Low‑pass filter vars (circle flicker) ---
float grayNow  = random(255);
float grayNext = random(255);
float lerpAmt  = 0.05;                   // vary to tweak flicker speed         //modelcom
float[] speeds = {0.01, 0.05, 0.15, 0.30};

// --- NEW connection logic vars ---                                            //modelcom
boolean connected = false;               // whether to draw the triangle        //modelcom
float brightnessThreshold = 200;         // ↑ change this trigger threshold     //modelcom
float baseHalfWidth = 20;                // half‑width of the triangle’s base   //modelcom

void setup() {
  size(1960, 975);
  initSquare();

  ellX = width / 2;
  ellY = height / 2;
}

void draw() {
  background(127);

  // --- Smooth‑random ellipse via lerp() ---
  grayNow = lerp(grayNow, grayNext, lerpAmt);

  if (abs(grayNow - grayNext) < 1) {                   // reached target
    grayNext = random(255);                            // pick new brightness
    lerpAmt  = speeds[int(random(speeds.length))];     // pick new speed
    connected = grayNext > brightnessThreshold;        // set connection flag  //modelcom
  }

  fill(grayNow);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // --- Moving Square ---
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // --- Transparent connecting triangle ---                                     //modelcom
  if (connected) {                                                              //modelcom
    PVector sqCtr = new PVector(x + w/2, y + h/2);                              //modelcom
    PVector cirCtr = new PVector(ellX, ellY);                                   //modelcom
    PVector v = PVector.sub(sqCtr, cirCtr).normalize();                         //modelcom
    PVector perp = new PVector(-v.y, v.x).mult(baseHalfWidth);                  //modelcom
    PVector p2 = PVector.add(cirCtr, perp);                                     //modelcom
    PVector p3 = PVector.sub(cirCtr, perp);                                     //modelcom

    noStroke();                                                                 //modelcom
    fill(0, 255, 0, 80);  // translucent green                                  //modelcom
    beginShape();                                                             
    vertex(sqCtr.x, sqCtr.y);      // apex at square center
    vertex(p2.x,   p2.y);          // base point 1 at circle
    vertex(p3.x,   p3.y);          // base point 2 at circle
    endShape(CLOSE);
  }                                                                           //modelcom

  // Update square position
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
