float angle;

void setup() {
  size(400, 400);
  angle = 0;
  background(255);
  rectMode(CENTER);
  noStroke();
}

void draw() {
  // Clear screen with white
  fill(255);
  rect(200, 200, 400, 400); // white background

  // OUTER blue square
  fill(0, 180, 200);
  rect(200, frameCount % height, 360, 360); // use modulo to keep within bounds

  // MIDDLE 1 - light green growing vertically
  fill(65, 200, 135);
  rect(200, 220, 290, frameCount % height);

  // MIDDLE 2 - dark green moving horizontally
  fill(98, 140, 106);
  rect(frameCount % width, 235, 210, 210);

  // INNER - rotating dark transparent square
  pushMatrix(); 
  translate(200, 255); // move origin to center of rotating square
  rotate(radians(angle));
  fill(20, 20, 20, 125);
  rect(0, 0, 140, 140); // draw centered on new origin
  popMatrix();

  // Increase angle
  angle += 1;
}

void mousePressed() {
  println("(" + mouseX + ", " + mouseY + ")");
  println("ode to the square");

  fill(0);
  textSize(25);
  textAlign(CENTER, CENTER);
  text("rotating squares", 250, 100);
  
  save("homage2squalbers.png");
}
