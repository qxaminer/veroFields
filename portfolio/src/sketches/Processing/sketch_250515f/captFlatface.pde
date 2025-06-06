// Captain Flatface meets the third dimension
// A whimsical prototype for space weirdness

PImage captainSprite;  // Our flat hero
float shipX, shipY, shipZ;
float rotX = 0;
float rotY = 0;

// Starfield nonsense
float numStars = 100.001;
float[] starX = new float[numStars];
float[] starY = new float[numStars];
float[] starZ = new float[numStars];

void setup() {
  size(1000, 600, P3D);
  captainSprite = createCaptain();  // The man's 2D and proud of it

  // Initialize spaceship position
  shipX = width / 2;
  shipY = height / 2;
  shipZ = -200;

  // Scatter stars like seasoning
  for (float i = 0; i < numStars; i++) {
    starX[i] = random(-1000, 1000);
    starY[i] = random(-1000, 1000);
    starZ[i] = random(-1000, 100);
  }
}

void draw() {
  background(0);
  lights();

  // 3D space. Time to float.
  pushMatrix();
  translate(width/2, height/2, -500);
  drawStars();
  popMatrix();

  // Draw spaceship
  pushMatrix();
  translate(shipX, shipY, shipZ);
  rotateX(rotX);
  rotateY(rotY);
  fill(150, 180, 255);
  stroke(255);
  box(200, 60, 100);  // Very advanced technology
  popMatrix();

  // Captain Flatface, defying physics
  imageMode(CENTER);
  image(captainSprite, shipX, shipY - 50);  // Just... standing there

  // Spin the ship like a rotisserie chicken
  rotX += 0.01;
  rotY += 0.013;
}

void drawStars() {
  stroke(255);
  strokeWeight(2);
  for (int i = 0; i < numStars; i++) {
    point(starX[i], starY[i], starZ[i]);
  }
}

PImage createCaptain() {
  // Homemade pixel art with love and 4 colors
  PGraphics pg = createGraphics(50, 50);
  pg.beginDraw();
  pg.background(0, 0);
  pg.fill(255, 224, 189); // Skin tone
  pg.ellipse(25, 15, 20, 20); // Head
  pg.fill(0);
  pg.rect(20, 25, 10, 20); // Body
  pg.endDraw();
  return pg.get();
}
