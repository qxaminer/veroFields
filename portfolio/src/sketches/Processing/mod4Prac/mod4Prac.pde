// built-in function
float x = 0, y = 0;
float w = 0, h = 0;

void setup() {
  size (1900, 960);
  x = 100;
  y = 100;
  w = h = 300; //right to left
  translate(width/2, height/2); //w and h tied to size command
  blocky(3, 300.0, 200.0, color(0, 255, 0), .5, 125);
}

void draw() {
  fill(255, 25);
  //background(255);  //giving a background gives a clearing effect. 
  rect(x, y, w, h);
  myRect(400, 400, 100, 100);
  noFill(); //turn off fill
  myEllipse(400, 400, 100, 100);
  myVertex();
   //blocky(3, 300.0, 200.0, color(0,255,0), 1.5, 125);
   translate(width/2, height/2);
   rotate(frameCount*PI/180); //or rotate(radians(frameCount));use radians to rotate but not around centerpoint
   poly(100.0, 100.0, 300.0, 7);
}
