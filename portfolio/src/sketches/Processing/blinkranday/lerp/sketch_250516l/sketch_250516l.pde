// ----  GLOBALS  ------------------------------------------------------------
float x, y, w, h;          // square position & size
float spdX, spdY;          // square velocity
color fillCol, strokeCol;  // square colors
boolean squareVisible = true;

// ellipse (‘ground‑station’) -----------------------------------------------
float ellX, ellY;
float ellSize = 100;

// circle flicker (low‑pass random) -----------------------------------------
float grayNow  = random(255);
float grayNext = random(255);
float lerpAmt  = 0.05;
float[] speeds = {0.01, 0.05, 0.15, 0.30};

// connection / triangle -----------------------------------------------------
boolean connected     = false;
float  brightnessThreshold = 200;

// dynamic‑vertex helpers ----------------------------------------------------
float dynPhase = 0;
float dynAmp   = 30;

// delta‑wing (interceptor) --------------------------------------------------
boolean wingActive  = false;
PVector wingPos, wingVel, wingTarget;
float   wingSpeed   = 10;

// --- NEW respawn timing vars ---------------------------------------------- //modelcom
int    respawnTimer  = 0;        // counts frames while square is gone       //modelcom
int    respawnDelay  = 120;      // wait 120 frames (~2 s @60 fps)           //modelcom

void setup() {
  size(1960, 975);
  initSquare();
  ellX = width/2;
  ellY = height/2;
}

void draw() {
  background(127);

  // ---- 1. update the circle brightness -----------------------------------
  grayNow = lerp(grayNow, grayNext, lerpAmt);

  if (abs(grayNow - grayNext) < 1) {
    grayNext = random(255);
    lerpAmt  = speeds[int(random(speeds.length))];

    boolean newConnected = grayNext > brightnessThreshold;

    // spawn wing only if we just turned on connection AND square exists
    if (newConnected && !connected && squareVisible) spawnWing();
    connected = newConnected;
  }

  // ---- 2. draw the circle -------------------------------------------------
  fill(grayNow);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // ---- 3. draw / move the square -----------------------------------------
  if (squareVisible) {
    fill(fillCol);
    stroke(strokeCol);
    strokeWeight(5);
    rect(x, y, w, h);

    x += spdX;
    y += spdY;
    if (x > width || x + w < 0 || y > height || y + h < 0) initSquare();
  }

  // ---- 4. dynamic triangle connection ------------------------------------
  if (connected && squareVisible) {
    PVector cirCtr = new PVector(ellX, ellY);
    PVector sqCtr  = new PVector(x + w/2, y + h/2);

    // dynamic apex wiggle
    dynPhase += 0.1;
    float dynOffset = sin(dynPhase) * dynAmp;
    PVector apex = new PVector(sqCtr.x + dynOffset, sqCtr.y);

    PVector v      = PVector.sub(apex, cirCtr).normalize();
    PVector perp   = new PVector(-v.y, v.x).mult(20);
    PVector p2     = PVector.add(cirCtr, perp);
    PVector p3     = PVector.sub(cirCtr, perp);

    noStroke();
    fill(0, 255, 0, 80);
    beginShape();
    vertex(apex.x, apex.y);
    vertex(p2.x,  p2.y);
    vertex(p3.x,  p3.y);
    endShape(CLOSE);
  }

  // ---- 5. update & draw delta‑wing ---------------------------------------
  if (wingActive) {
    wingPos.add(wingVel);
    if (wingPos.dist(wingTarget) < wingSpeed) {       // contact achieved
      wingActive    = false;
      squareVisible = false;                          // hide rectangle
      connected     = false;                          // drop connection
      respawnTimer  = 0;                              // start countdown  //modelcom
    }

    pushMatrix();
    translate(wingPos.x, wingPos.y);
    rotate(atan2(wingVel.y, wingVel.x));
    fill(255, 50, 0);
    noStroke();
    beginShape();
    vertex(-12, -6);
    vertex(14, 0);
    vertex(-12,  6);
    endShape(CLOSE);
    popMatrix();
  }

  // ---- 6. respawn logic ---------------------------------------------------
  if (!squareVisible && !wingActive) {                // wing finished
    respawnTimer++;                                   // count frames
    if (respawnTimer >= respawnDelay) {               // enough time passed
      initSquare();                                   // new random square
      respawnTimer = 0;
    }
  }
}

// ------------------  HELPER FUNCTIONS  -------------------------------------

void initSquare() {
  w = 150; h = 60;
  x = random(width - w);
  y = random(height - h);
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);
  if (spdX == 0 && spdY == 0) { spdX = 1; spdY = 1; }
  fillCol   = color(random(255), random(255), random(255));
  strokeCol = color(random(115), 80, random(45));
  squareVisible = true;                               // show square again
}

void spawnWing() {
  wingPos    = new PVector(ellX, ellY);
  wingTarget = new PVector(x + w/2, y + h/2);
  PVector dir = PVector.sub(wingTarget, wingPos).normalize();
  wingVel    = dir.mult(wingSpeed);
  wingActive = true;
}
