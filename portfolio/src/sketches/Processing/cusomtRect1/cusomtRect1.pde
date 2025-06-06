//global scope  -  built-in function
//give them all an initial value
float x = 0, y = 0, w = 0, h = 0;
//or float x = 0, y = 0;
//float w = 0, h = 0;

//function call
void setup() {
  size(800, 800); //function called size expecting argument type float/int?
  x = 100;
  y = 100;
  y = 100;
  w = h = 300; //right to left
}
//function defintion
void draw() {
  rect(x, y, w, h);
  myRect(400,400,100,100);
  noFill(); //turn off fill for ellipse to see underlying shape
  myEllipse(400,400,100,100);
}
