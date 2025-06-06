// Randomly parametrized rectangle program
//Vero Field, 14MAY2025

//create rect
//randomize value

//pos
float x = 0.0;
float y = 0.0;
float z = 0.0;
//dim
float w = 0.0;
float h = 0.0;
//spd
float spdX = 0.0;
float spdY = 0.0;
float spdZ = 0.0;
//color
color fillCol = color(0);
color strokeCol = color(0);

// global declarations

void setup() {
  // local declarations
  size(1960, 960, P3D);

  //dim
  w = 150;
  h = 60;
  //x = random.int(3.14);
  x = random(600);
  y = random(300, height-h);
  z = random(-200, 200);
  //z = random(100, width-rect);

  //spd
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);
  spdZ = random(-1.5, 1.5);
  //color
  fillCol = color(random(fillCol));
  strokeCol = color(random(230*.5), 160*.5, random(90*.5));
  //println(x);  // gives you a return for space
  //println(y);
  //println(z);
  //println(isOff);

  // global definitions/initializations
}

// a computer likes math.

void draw() {

  background(127);
  lights(); // Adds basic lighting so the 3-D image looks shaded
  // use stuff
  pushMatrix();
  translate(x, y, z); // Position in 3D space
  fill(fillCol);
  stroke(strokeCol);
  strokeWeight(2);
  fill(random(x));
  strokeWeight(5);
  box(w, h, 40); // Add depth to the shape (40 = z-dimension)
  popMatrix();
  
  // Animate position
  x += spdX;
  y += spdY;
  z += spdZ;
  
  // Randomly parametrized rectangle program
//Vero Field, 14MAY2025

//create rect
//randomize value

//pos
float x = 0.0;
float y = 0.0;
//dim
float w = 0.0;
float h = 0.0;
//spd
float spdX = 0.0;
float spdY = 0.0;
//color
color fillCol = color(0);
color strokeCol = color(0);
//r,g,b,alpha
//r 8-bits representing red, same g/b, alpha is 1-10
// hexadecimal - base 16 0-f
//strokeCol

// global declarations

void setup() {
  // local declarations
  size(1960, 960);

  //dim
  w = 150;
  h = 60;
  //x = random.int(3.14);
  x = random(600);
  y = random(300, height-h);
  //z = random(100, width-rect);

  //spd
  spdX = random(-1.2, 1.3);
  spdY = random(-3.2, 3.2);
  //color
  fillCol = color(random(fillCol));
  strokeCol = color(random(230*.5), 160*.5, random(90*.5));
  //println(x);  // gives you a return for space
  //println(y);
  //println(z);
  //println(isOff);

  // global definitions/initializations
}

// a computer likes math.

void draw() {

  background(127, 127, 127);
  // use stuff
  fill(random(x));
  strokeWeight(5);
  rect(x, y, w, h);
  x = x + spdX;
  x += spdX;
  y += spdY;

//add perspective
//rotateY(frameCount * 0.01); // Slow rotation
  // randomize 60xps
}
}
