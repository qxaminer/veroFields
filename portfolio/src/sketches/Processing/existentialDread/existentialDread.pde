// Floating 3D box of chaos
// Vero Field, 14 MAY 2025 - rebooted with sarcasm

// Positional nonsense
float x, y, z;
// Box shape-shenanigans
float w = 150, h = 60, d = 40;  // d = depth. 3D is spicy.
// Speed demons
float spdX, spdY, spdZ;
// Colors. Who needs taste?
color fillCol, strokeCol;

void setup() {
  size(1960, 960, P3D);  // Welcome to 3D. Bring goggles.
  noSmooth();            // Pixels are friends.

  // Spawn location: somewhere... out there
  x = random(width - w);
  y = random(height - h);
  z = random(-300, 300); // Depth. Cue spooky music.

  // Random speeds. Good luck, box.
  spdX = random(-2.0, 2.0);
  spdY = random(-2.5, 2.5);
  spdZ = random(-1.5, 1.5);

  // Color roulette
  fillCol = color(random(255), random(255), random(255), 200); // Transparent enough to be mysterious
  strokeCol = color(random(120), 80, random(60));              // Pretentious palette
}

void draw() {
  background(64);   // Moody grey. Drama!
  lights();         // Because boxes deserve a spotlight

  // Matrix magic – don't forget to clean up
  pushMatrix();
  translate(x, y, z);  // Beam me to weird coordinates
  rotateY(frameCount * 0.01);  // Fancy spin. Because we can.
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(2);
  box(w, h, d);     // Behold, the cube-ish
  popMatrix();

  // Move. Bounce. Repeat forever. Like your existential dread.
  x += spdX;
  y += spdY;
  z += spdZ;

  // If you hit the wall, bounce like a 90s screensaver
  if (x < 0 || x > width - w) spdX *= -1;
  if (y < 0 || y > height - h) spdY *= -1;
  if (z < -300 || z > 300) spdZ *= -1;
}
