int currentDemo = 0;
int maxDemos = 9; // 3 transforms × 3 shapes
float time = 0;

void setup() {
  size(800, 600);
}

void draw() {
  background(40);
  time += 0.02;
  
  // Auto-cycle every 3 seconds
  if (frameCount % 180 == 0) {
    currentDemo = (currentDemo + 1) % maxDemos;
  }
  
  // Display current demo info
  fill(255);
  text("Demo " + (currentDemo + 1) + "/9", 10, 30);
  text("Transform: " + getTransformName(currentDemo), 10, 50);
  text("Shape: " + getShapeName(currentDemo), 10, 70);
  text("Press SPACE to advance manually", 10, height - 20);
  
  // Execute current demo
  runDemo(currentDemo);
}

void runDemo(int demoNum) {
  int transformType = demoNum / 3; // 0=translate, 1=rotate, 2=scale
  int shapeType = demoNum % 3;     // 0=ellipse, 1=rect, 2=triangle
  
  pushMatrix();
  translate(width/2, height/2); // Always center first
  
  // Apply the specific transform
  switch(transformType) {
    case 0: // TRANSLATE
      demonstrateTranslate(time);
      break;
    case 1: // ROTATE  
      demonstrateRotate(time);
      break;
    case 2: // SCALE
      demonstrateScale(time);
      break;
  }
  
  // Draw the specific shape
  fill(255, 150, 100);
  stroke(255);
  strokeWeight(2);
  
  switch(shapeType) {
    case 0: // ELLIPSE
      ellipse(0, 0, 100, 100);
      break;
    case 1: // RECTANGLE
      rectMode(CENTER);
      rect(0, 0, 100, 100);
      break;
    case 2: // TRIANGLE
      drawTriangle();
      break;
  }
  
  popMatrix();
}

void demonstrateTranslate(float t) {
  // Move in a circle
  float x = cos(t) * 150;
  float y = sin(t) * 150;
  translate(x, y);
  
  // Show the path
  stroke(100);
  strokeWeight(1);
  noFill();
  ellipse(0, 0, 300, 300);
}

void demonstrateRotate(float t) {
  rotate(t);
  
  // Show rotation axis
  stroke(100);
  strokeWeight(1);
  line(-200, 0, 200, 0);
  line(0, -200, 0, 200);
}

void demonstrateScale(float t) {
  float scaleAmount = 0.5 + sin(t) * 0.4; // Scale between 0.1 and 0.9
  scale(scaleAmount);
  
  // Show scale reference
  stroke(100);
  strokeWeight(1);
  noFill();
  rect(-100, -100, 200, 200); // Reference square
}

void drawTriangle() {
  beginShape();
  vertex(0, -50);   // Top point
  vertex(43, 25);   // Bottom right
  vertex(-43, 25);  // Bottom left
  endShape(CLOSE);
}

String getTransformName(int demo) {
  String[] names = {"TRANSLATE", "ROTATE", "SCALE"};
  return names[demo / 3];
}

String getShapeName(int demo) {
  String[] names = {"ELLIPSE", "RECTANGLE", "TRIANGLE"};
  return names[demo % 3];
}

void keyPressed() {
  if (key == ' ') {
    currentDemo = (currentDemo + 1) % maxDemos;
  }
}
