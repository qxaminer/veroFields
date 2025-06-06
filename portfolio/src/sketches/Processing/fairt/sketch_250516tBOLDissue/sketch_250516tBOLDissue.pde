/*  COLOUR‑ADD PROBE DEMO  —  FINAL   (Processing 4.x)

    Click the red, green, or blue button (top‑left) to launch a probe that
    adds +25 to that colour channel of the roaming rectangle on impact.
    Press 'E' for a brief rainbow burst from the circle.

    Twain‑esque aside:
      “ Truth is mighty and will prevail. There is nothing
        wrong with this, except that it ain’t always so.”   */

import processing.core.PConstants;   // for the BOLD constant

// ========================= 1. GLOBAL TUNEABLES ============================
float wingHalfSpan  = 18;
float wingNoseAhead = 24;
float wingTailBack  = 13;
float wingBaseSpeed = 10;
float wingReturnSpeed = 18;

int fadeDurMin = 60, fadeDurMax = 120;
int respawnDelay = 120;           // max gap (frames) between rectangles
int scanPulseLen = 35;

// ========================= 2. GLOBAL STATE ===============================
float x, y, w = 150, h = 60, spdX, spdY;

color fillCol, strokeCol;
boolean squareVisible = true, fading = false;
float fadeSat = 1, fadeAlpha = 255; int fadeFrames;
boolean greenLocked = false;

float ellX, ellY, ellSize = 100;   // >>> declared early  <<<

float grayNow = random(255), grayNext = random(255), lerpAmt = 0.05;
float[] speeds = {0.01, 0.05, 0.15, 0.30};
boolean connected = false;
float brightnessThreshold = 200;

ArrayList<Wing> wings = new ArrayList<Wing>();

int scanPulse = 0; color scanColor;
int respawnTimer = 0;

// dialogue
String probeMsg = "", circleMsg = "";
boolean rectRGBReported = false, circleResponded = false;

// player UI
int selectedChannel = -1;                         // 0 = R, 1 = G, 2 = B
color[] btnColors = {
  color(0,   80, 100),
  color(120, 80, 100),
  color(240, 80, 100)
};
PVector[] btnPos = {
  new PVector(330, 12),
  new PVector(370, 12),
  new PVector(410, 12)
};

// easter egg
int eggTimer = 0;   // frames remaining of rainbow burst

// ========================= 3. SETUP =======================================
void setup() {
  size(960, 540);                     // fits most screens
  colorMode(HSB, 360, 100, 100, 255);
  ellX = width / 2;
  ellY = height / 2;
  initSquare();
}

// ========================= 4. MAIN LOOP ===================================
void draw() {
  background(0, 0, 50);

  updateCircle();
  updateSquare();
  updateTriangle();
  updateWings();
  handleRespawn();

  drawDialogueBoxes();
  drawButtons();
  rainbowBurst();        // easter‑egg effect
}

// ========================= 5. CIRCLE & TRIANGLE ===========================
void updateCircle() {
  grayNow = lerp(grayNow, grayNext, lerpAmt);
  if (abs(grayNow - grayNext) < 1) {
    grayNext = random(255);
    lerpAmt  = speeds[int(random(speeds.length))];
    if (grayNext > brightnessThreshold && !connected && squareVisible) {
      probeMsg        = "Probe: request RGB…";
      circleMsg       = "";
      rectRGBReported = false;
      circleResponded = false;
      connected       = true;
    }
  }

  fill((eggTimer > 0) ? random(360) : grayNow);   // rainbow burst
  noStroke();
  ellipse(ellX, ellY, ellSize, ellSize);
}

void updateTriangle() {
  if (!connected || !squareVisible) return;

  PVector cir = new PVector(ellX, ellY);
  PVector sq  = rectCenter();
  float off   = sin(frameCount * 0.1) * 25;

  PVector apex = new PVector(sq.x + off, sq.y);
  PVector v    = PVector.sub(apex, cir).normalize();
  PVector perp = new PVector(-v.y, v.x).mult(20);

  noStroke();
  fill(scanPulse > 0 ? scanColor : color(120, 0, 100, 80));
  beginShape();
  vertex(apex.x, apex.y);
  vertex(cir.x + perp.x, cir.y + perp.y);
  vertex(cir.x - perp.x, cir.y - perp.y);
  endShape(CLOSE);
}

// ========================= 6. RECTANGLE ==================================
void updateSquare() {
  if (!squareVisible) return;

  // lock onto green probe velocity if close
  if (!greenLocked) {
    for (Wing w : wings) {
      if (w.channel == 1 && w.pos.dist(rectCenter()) < 10) {
        spdX = w.vel.x; spdY = w.vel.y;
        greenLocked = true;
      }
    }
  }

  x += spdX; y += spdY;
  if (x > width || x + w < 0 || y > height || y + h < 0) {
    squareVisible = false; return;
  }

  // stroke flicker (0, 125, 255)
  int[] vals = {0, 125, 255};
  strokeCol = color(0, 0, vals[(frameCount / 2) % 3] * 100.0 / 255);

  if (fading) {
    fadeSat   = max(0, fadeSat   - 1.0 / fadeFrames);
    if (fadeSat == 0) fadeAlpha = max(0, fadeAlpha - 255.0 / fadeFrames);
    if (fadeAlpha == 0) { squareVisible = false; fading = false; }
  }

  float localAlpha = (selectedChannel == 2)
                     ? (200 + 55 * sin(frameCount * 0.1))
                     : fadeAlpha;

  color c2 = color(
    red(fillCol),
    green(fillCol),
    blue(fillCol),
    localAlpha
  );

  fill(c2);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);

  // dialogue once per scan
  if (connected && !rectRGBReported) {
    probeMsg = "Rect RGB: [" +
                int(red(fillCol)) + "," +
                int(green(fillCol)) + "," +
                int(blue(fillCol)) + "]";
    rectRGBReported = true;
  }
  if (rectRGBReported && !circleResponded && wings.isEmpty()) {
    circleMsg = "Circle: ready for next infusion.";
    circleResponded = true;
  }
}

// ========================= 7. WINGS ======================================
class Wing {
  PVector pos, vel;
  int channel;        // 0 = R, 1 = G, 2 = B

  Wing(int ch) {
    channel = ch;
    pos     = new PVector(ellX, ellY);
    float speed = computeInterceptSpeed();
    vel     = PVector.sub(rectCenter(), pos).setMag(speed);
  }

  void update() {
    pos.add(vel);
    if (pos.dist(rectCenter()) < 6) {
      // add +25 to rectangle channel
      float r = red(fillCol), g = green(fillCol), b = blue(fillCol);
      if (channel == 0) r = min(r + 25, 255);
      if (channel == 1) g = min(g + 25, 255);
      if (channel == 2) b = min(b + 25, 255);
      fillCol = color(r, g, b);

      println("Captain: Channel " + channel +
              " probe impact – colour rising!");
      wings.remove(this);
    }
  }

  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(atan2(vel.y, vel.x));

    if (channel == 0)      fill(0,   80, 100);
    else if (channel == 1) fill(120, 80, 100);
    else                   fill(240, 80, 100);

    noStroke();
    beginShape();
    vertex(-wingTailBack, -wingHalfSpan);
    vertex( wingNoseAhead,  0);
    vertex(-wingTailBack,  wingHalfSpan);
    endShape(CLOSE);
    popMatrix();
  }
}

void updateWings() {
  for (int i = wings.size() - 1; i >= 0; i--) {
    wings.get(i).update();
    wings.get(i).draw();
  }
}

// ========================= 8. RESPAWN ====================================
void handleRespawn() {
  if (squareVisible) { respawnTimer = 0; return; }
  if (++respawnTimer >= respawnDelay) {
    wings.clear();
    initSquare();
    respawnTimer = 0;
  }
}

// ========================= 9. INIT NEW RECTANGLE ==========================
void initSquare() {
  w = 150; h = 60;
  x = random(width  * 0.3, width  * 0.7);
  y = random(height * 0.3, height * 0.7);

  float hueVal = random(360);
  fillCol  = color(hueVal, 80, 100);
  strokeCol = color(0, 0, 100);

  spdX = random(-0.8, 0.8);
  spdY = random(-0.8, 0.8);
  if (spdX == 0 && spdY == 0) { spdX = 0.4; spdY = 0.4; }

  squareVisible     = true;
  fading            = false;
  fadeSat           = 1;
  fadeAlpha         = 255;
  probeMsg          = "";
  circleMsg         = "";
  rectRGBReported   = false;
  circleResponded   = false;
  greenLocked       = false;
  selectedChannel   = -1;
}

// ========================= 10. UI  =======================================
void drawDialogueBoxes() {
  textAlign(LEFT, TOP);
  textSize(16);
  textStyle(PConstants.BOLD);

  fill(0, 0, 100); stroke(0, 0, 100);
  rect(10, 10, 300, 40, 4);
  rect(10, 60, 300, 40, 4);

  fill(0);
  text(probeMsg,  16, 16);
  text(circleMsg, 16, 66);
}

void drawButtons() {
  for (int i = 0; i < 3; i++) {
    fill(btnColors[i]);
    noStroke();
    ellipse(btnPos[i].x + 10, btnPos[i].y + 10, 20, 20);
    fill(0);
    textSize(12);
    text("+25", btnPos[i].x - 4, btnPos[i].y + 24);
  }
}

// ========================= 11. INPUT  ====================================
void mousePressed() {
  for (int i = 0; i < 3; i++) {
    if (dist(mouseX, mouseY, btnPos[i].x + 10, btnPos[i].y + 10) < 10) {
      selectedChannel = i;
      launchProbe(i);
      return;
    }
  }
}

void keyPressed() {
  if (key == 'e' || key == 'E') {
    eggTimer = 180;            // rainbow for 3 s at 60 fps
    println("DFW‑style footnote: *BOING*");
  }
}

// ========================= 12. HELPERS ===================================
float computeInterceptSpeed() {
  float dist = dist(ellX, ellY, rectCenter().x, rectCenter().y);
  return max(wingBaseSpeed, dist / 60.0);  // reach in ~1 s
}

void launchProbe(int ch) {
  wings.add(new Wing(ch));
  probeMsg  = "Probe-" + ch + " launched.";
  circleMsg = "";
}

PVector rectCenter() { return new PVector(x + w / 2, y + h / 2); }

void rainbowBurst() {
  if (eggTimer > 0) {
    eggTimer--;
    stroke(random(360), 80, 100, 120);
    strokeWeight(10);
    noFill();
    float pulsate = 20 * sin(eggTimer * 0.2);
    ellipse(ellX, ellY, ellSize + pulsate, ellSize + pulsate);
  }
}
