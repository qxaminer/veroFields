float rectX = 100;
float rectY = 100;
float rectWidth = 150;
float rectHeight = 60;

float ellipseX = 400;
float ellipseY = 200;
float ellipseSize = 100;

float sphereX, sphereY, sphereZ, sphereSize = 50;
float sphereRotationX = 0;
float sphereRotationY = 0;

float copyRectX = 125, copyRectY = 125;
float pulseAmount = 0;
boolean pulsingIn = true;

float zoomLevel = 1.0; // Starting zoom level

void setup() {
  size(800, 760, P3D); // Use 3D renderer
  sphereX = width / 2 + cos(radians(frameCount)) * 150; // Opposite of ellipse's starting point
  sphereY = height / 2 + sin(radians(frameCount)) * 150;
  sphereZ = 0; // Set a starting Z position for the sphere
  
  copyRectX = 125;
  copyRectY = 125;
}

void draw() {
  background(0);

  // Simulate mouse-controlled zooming and clicking
  simulateMouseInteraction();

  // Set up 3D camera view with zoom level
  translate(width / 2, height / 2, -zoomLevel * 100); // Zoom effect by changing camera position
  rotateX(sphereRotationX);
  rotateY(sphereRotationY);

  // Flickering Rectangle Effect (2D)
  fill(random(255), random(255), random(255), random(100, 255)); // Random color with random opacity
  rect(rectX, rectY, rectWidth, rectHeight);

  // Rotating Ellipse (Still in 2D but with rotation)
  fill(0, 255, 0); // Green color
  ellipseX = width / 2 + cos(radians(frameCount)) * 150;
  ellipseY = height / 2 + sin(radians(frameCount)) * 150;
  ellipse(ellipseX, ellipseY, ellipseSize, ellipseSize);

  // Mirrored 3D Sphere (opposite of Ellipse)
  fill(0, 0, 255); // Blue color for sphere
  pushMatrix();
  translate(sphereX, sphereY, sphereZ); // Translate to the sphere's position
  sphere(sphereSize); // Draw 3D sphere
  popMatrix();

  // Carbon-Copy of Rectangle, Pulsing and Moving Randomly in 3D space
  // Pulsing effect: Random size changes, moving toward or away from (125, 125)
  float distToCenter = dist(copyRectX, copyRectY, 125, 125);
  float scaleFactor = map(distToCenter, 0, 300, 1, 0.5); // Pulsing scale effect

  // Update rectangle movement and pulsing
  copyRectX += random(-3, 3);
  copyRectY += random(-3, 3);

  if (pulsingIn) {
    pulseAmount += 0.5; // Increase size
    if (pulseAmount > 100) pulsingIn = false;
  } else {
    pulseAmount -= 0.5; // Decrease size
    if (pulseAmount < 10) pulsingIn = true;
  }

  // Randomized grayscale fill for the pulsing rect with alpha
  fill(random(100, 255), random(100, 255), random(100, 255), random(50, 255));
  rect(copyRectX, copyRectY, rectWidth * scaleFactor + pulseAmount, rectHeight * scaleFactor + pulseAmount);
}

// Function to simulate mouse-controlled zooming and clicking
void simulateMouseInteraction() {
  // Randomize zooming in or out
  if (random(1) < 0.01) { // 1% chance to simulate zoom action
    zoomLevel += random(-0.2, 0.2); // Randomize zoom in/out
    zoomLevel = constrain(zoomLevel, 0.5, 3.0); // Constrain zoom to prevent going too close or too far
  }

  // Randomize sphere rotation
  if (random(1) < 0.02) { // 2% chance to simulate rotation change
    sphereRotationX += random(-0.05, 0.05); // Randomly adjust X rotation
    sphereRotationY += random(-0.05, 0.05); // Randomly adjust Y rotation
  }
}
