enum POVMode { STATIC, ANIMATED, RANDOM };
POVMode currentMode;
int modeSwitchFrame = 0;
int modeDuration = 240;  // Switch mode every 4 seconds @ 60 FPS

PVector moonCenter;
float moonRadius = 200;

PVector phobos, deimos;
float[] phobosArc = new float[2];
float[] deimosArc = new float[2];

float noiseSeedValue;

void setup() {
  size(800, 600);
  moonCenter = new PVector(width/2, height/2);
  phobos = new PVector(width/2 + 300, height/2 - 100);
  deimos = new PVector(width/2 - 350, height/2 - 120);
  
  computeVisibilityArc(phobos, phobosArc);
  computeVisibilityArc(deimos, deimosArc);

  noiseSeedValue = random(1000);
  setRandomPOV();
}

void draw() {
  background(20);
  
  // Change mode every few seconds
  if (frameCount - modeSwitchFrame > modeDuration) {
    setRandomPOV();
  }

  // Draw moon
  fill(80);
  noStroke();
  ellipse(moonCenter.x, moonCenter.y, moonRadius * 2, moonRadius * 2);
  
  // Draw phobos/deimos (may be obscured in RANDOM mode)
  if (currentMode != POVMode.RANDOM || frameCount % 30 < 15) {
    fill(150, 200, 255); ellipse(phobos.x, phobos.y, 12, 12); text("Phobos", phobos.x, phobos.y - 10);
    fill(255, 180, 255); ellipse(deimos.x, deimos.y, 12, 12); text("Deimos", deimos.x, deimos.y - 10);
  }

  // Draw arcs based on mode
  float animOffset = currentMode == POVMode.ANIMATED ? sin(frameCount * 0.05) * 0.1 : 0;

  if (currentMode != POVMode.RANDOM) {
    drawArcSegment(phobosArc, color(0, 255, 255), animOffset);
    drawArcSegment(deimosArc, color(255, 0, 255), -animOffset);
  } else {
    drawNoisyVisual();
  }

  // Highlight intersection in STATIC/ANIMATED
  if (currentMode != POVMode.RANDOM) {
    float[] intersectArc = arcIntersection(phobosArc, deimosArc);
    if (intersectArc != null) {
      drawArcSegment(intersectArc, color(0, 255, 0), 0);
      fill(255);
      text("Valid LOS zone", moonCenter.x, moonCenter.y + moonRadius + 20);
    } else {
      fill(255, 0, 0);
      text("No shared LOS from Moon", moonCenter.x, moonCenter.y + moonRadius + 20);
    }
  } else {
    fill(150);
    text("Vision scrambled by omniscient observer...", moonCenter.x, moonCenter.y + moonRadius + 20);
  }

  // Show current mode in debug
  fill(100, 255, 100);
  text("Mode: " + currentMode.toString(), width - 100, 30);
}

// Random POV controller
void setRandomPOV() {
  int r = int(random(3));
  if (r == 0) currentMode = POVMode.STATIC;
  else if (r == 1) currentMode = POVMode.ANIMATED;
  else currentMode = POVMode.RANDOM;

  modeSwitchFrame = frameCount;
}

void computeVisibilityArc(PVector target, float[] arcOut) {
  PVector toTarget = PVector.sub(target, moonCenter);
  float d = toTarget.mag();
  if (d <= moonRadius) {
    arcOut[0] = 0;
    arcOut[1] = 0;
    return;
  }
  float centerAngle = atan2(toTarget.y, toTarget.x);
  float alpha = asin(moonRadius / d);
  arcOut[0] = centerAngle - alpha;
  arcOut[1] = centerAngle + alpha;
}

void drawArcSegment(float[] arc, color c, float offset) {
  stroke(c);
  strokeWeight(4);
  noFill();
  float step = PI / 180;
  beginShape();
  for (float a = arc[0] + offset; a <= arc[1] + offset; a += step) {
    float x = moonCenter.x + cos(a) * moonRadius;
    float y = moonCenter.y + sin(a) * moonRadius;
    vertex(x, y);
  }
  endShape();
}

float[] arcIntersection(float[] arcA, float[] arcB) {
  float a1 = arcA[0], a2 = arcA[1];
  float b1 = arcB[0], b2 = arcB[1];
  float start = max(a1, b1);
  float end = min(a2, b2);
  if (start < end) return new float[]{start, end};
  return null;
}

// Scrambled visual overlay
void drawNoisyVisual() {
  loadPixels();
  for (int y = 0; y < height; y += 4) {
    for (int x = 0; x < width; x += 4) {
      float n = noise(noiseSeedValue + x * 0.02, y * 0.02, frameCount * 0.01);
      stroke(255 * n, 255 * (1 - n), 100 + 100 * n, 150);
      point(x, y);
    }
  }
}
