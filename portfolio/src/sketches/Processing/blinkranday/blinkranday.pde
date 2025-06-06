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
  size(1960, 975);

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

  // randomize 60xps
}
