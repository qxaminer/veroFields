// ----  GLOBALS  ------------------------------------------------------------
float x, y, w, h;          // square position & size
float spdX, spdY;          // square velocity
color fillCol, strokeCol;  // square colors

// ellipse (‘ground‑station’) -----------------------------------------------
float ellX, ellY;
float ellSize = 100;

// circle flicker (low‑pass random) -----------------------------------------
float grayNow  = random(255);
float grayNext = random(255);
float lerpAmt  = 0.05;                   // ← tweak flicker speed
float[] speeds = {0.01, 0.05, 0.15, 0.30};

// connection / triangle -----------------------------------------------------
boolean connected     = false;          // current state
float  brightnessThreshold = 200;       // trigger level

// dynamic‑vertex helpers ----------------------------------------------------
float dynPhase = 0;                     // running angle for sine‑wave offset
float dynAmp   = 30;                    // magnitude of the wiggle

// delta‑wing (fast interceptor) --------------------------------------------
boolean wingActive  = false;            // is plane flying
PVector wingPos, wingVel, wingTarget;   // kinematics
float   wingSpeed   = 30;               // pixels per frame (fast!)

void setup() {
  size(1960, 975);
  initSquare();
  ellX = width/2;
  ellY = height/2;
}

void draw() {
  background(127);

  // ------------- 1.  update the circle brightness -------------------------
  grayNow = lerp(grayNow, grayNext, lerpAmt);

  if (abs(grayNow - grayNext) < 1) {            // reached target
    grayNext = random(255);                     // pick new brightness
    lerpAmt  = speeds[int(random(speeds.length))];
    
    // check connection trigger
    boolean newConnected = grayNext > brightnessThreshold;
    
    // spawn delta‑wing on rising edge only
    if (newConnected && !connected) spawnWing();
    connected = newConnected;
  }

  // ------------- 2.  draw the circle --------------------------------------
  fill(grayNow);
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);

  // ------------- 3.  draw / move the square ------------------------------
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);
  x += spdX;
  y += spdY;
  if (x > width || x + w < 0 || y > height || y + h < 0) initSquare();

  // ------------- 4.  dynamic triangle connection -------------------------
  if (connected) {
    // compute centres
    PVector cirCtr = new PVector(ellX, ellY);
    PVector sqCtr  = new PVector(x + w/2, y + h/2);

    // ---- dynamic vertex logic ----                                        //modelcom
    // We jitter the apex of the triangle along the square’s X‑axis using    //modelcom
    // a sine wave: offset = sin(time)*amp.  Try different dynAmp speeds.    //modelcom
    dynPhase += 0.1;                               
    float dynOffset = sin(dynPhase) * dynAmp;                           
    PVector apex = new PVector(sqCtr.x + dynOffset, sqCtr.y);  // moves sideways

    // perpendicular for circle base
    PVector v      = PVector.sub(apex, cirCtr).normalize();
    PVector perp   = new PVector(-v.y, v.x).mult(20);          // base half‑width
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

  // ------------- 5.  update & draw delta‑wing ----------------------------
  if (wingActive) {
    wingPos.add(wingVel);
    if (wingPos.dist(wingTarget) < wingSpeed) wingActive = false;

    // draw tiny delta oriented with velocity
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
}

void spawnWing() {                                           //modelcom
  /*  Creates a plane at the circle’s centre, points it at the                //modelcom
      square, calculates a velocity that will reach the target quickly, and   //modelcom
      sets wingActive so draw() will animate it every frame.                  //modelcom
  */                                                                          //modelcom
  wingPos    = new PVector(ellX, ellY);
  wingTarget = new PVector(x + w/2, y + h/2);
  PVector dir = PVector.sub(wingTarget, wingPos).normalize();
  wingVel    = dir.mult(wingSpeed);
  wingActive = true;
}
