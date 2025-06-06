////Color is a fundamental component of creative expression. Though it may seem that Processing has some restrictiveness when it comes to color, there are many ways to explore and utilize color variations in your program (shown in the examples below). As you become more comfortable with coding with Processing, selecting and creating colors will become more intuitive.

////  Input the code below into Processing to see different color examples:

////Color swatch squares:
//// Color Shift
//size(800, 450);
//background(50);
//noStroke();
//int spacing = 50;
//int w = (width-spacing*2)/2;
//int h = w;
//color swatch = color(100, 100, 120);

////left squares
//fill(255, 120, 0);
//rect(spacing, spacing, w, h);
//fill(swatch);
//rect(spacing+w/3, spacing+h/3, w/3, h/3);

////right squares
//fill(45, 140, 255);
//rect(w+spacing, spacing, w, h);
////fill(swatch);
//rect(w+spacing+w/3, spacing+h/3, w/3, h/3);
//Random color (rotated triangle):
////Rotated Triangle
//size(350, 350);
//background(255);
//smooth();
//strokeWeight(3);
//noFill();
//translate(width/2, height/2);
//for (int i=0; i< 20; i++) {
//  stroke(random(255), random(255), random(255));
//  triangle(-120, 120, 120, 120, 0, -120);
//  rotate(TWO_PI/20);
//}
////Color wheel:
////
////Subtractive Color Wheel
////  Ira Greenberg, January 4, 2005
////  primaries (r, y, b)
////  secondaries(g, p, o)
////  tertiary(y-o, r-o, r-p, b-p, b-g, y-g)
////  

//  int segs = 12;
//float rotAdjust = radians(360/segs/2);
//float radius = 175.0;
//float ratio = .65;
//float interval = TWO_PI/segs;
//int SHADE = 0;
//int TINT = 1;

//void setup() {
//  size(800, 400);
//  background(0);
//  smooth();
//  ellipseMode(CENTER_RADIUS);
//  noStroke();
//  createWheel(width/4, height/2, SHADE);
//  createWheel(width - width/4, height/2, TINT);
//}

//void createWheel(int x, int y, int valueShift) {
//  radius = 175;
//  ratio = .65;
//  if (valueShift == SHADE) {
//    // left wheel
//    for (int j=1; j<5; j+=1) {
//      color[]cols = {
//        color(255/j, 255/j, 0), color(255/j, (255/1.5)/j, 0), color(255/j, (255/2)/j, 0),
//        color(255/j, (255/2.5)/j, 0), color(255/j, 0, 0), color(255/j, 0, (255/2)/j),
//        color(255/j, 0, 255/j), color((255/2)/j, 0, 255/j), color(0, 0, 255/j),
//        color(0, 255/j, (255/2)/j), color(0, 255/j, 0), color((255/2)/j, 255/j, 0) };
//      for (int i=0; i< segs; i++) {
//        fill(cols[i]);
//        arc(x, y, radius, radius, interval*i+rotAdjust, interval*(i+1)+rotAdjust);
//      }
//      radius*=ratio;
//      ratio-=.1;
//    }
//  } else if (valueShift == TINT) {
//    //right wheel
//    for (float j=0; j<1.5; j+=.3) {
//      color[]cols = {
//        color(255, 255, 255*j), color(255, (255/1.5)+255*j, 255*j),
//        color(255, (255/2)+255*j, 255*j),
//        color(255, (255/2.5)+255*j, 255*j), color(255, 255*j, 255*j),
//        color(255, 255*j, (255/2)+255*j),
//        color(255, 255*j, 255), color((255/2)+255*j, 255*j, 255),
//        color(255*j, 255*j, 255),
//        color(255*j, 255, (255/2)+255*j), color(255*j, 255, 255*j),
//        color((255/2)+255*j, 255, 255*j) };
//      for (int i=0; i< segs; i++) {
//        fill(cols[i]);
//        arc(x, y, radius, radius, interval*i+rotAdjust, interval*(i+1)+rotAdjust);
//      }
//      radius*=ratio;
//      ratio-=.1;
//    }
//  }
//}
