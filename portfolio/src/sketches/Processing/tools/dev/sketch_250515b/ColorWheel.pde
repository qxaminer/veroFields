//
 //Subtractive Color Wheel
 //Ira Greenberg, January 4, 2005
 //primaries (r, y, b)
 //secondaries(g, p, o)
 //tertiary(y-o, r-o, r-p, b-p, b-g, y-g)
 //

int segs = 12;
float rotAdjust = radians(360/segs/2);
float radius = 175.0;
float ratio = .65;
float interval = TWO_PI/segs;
int SHADE = 0;
int TINT = 1;

void setup(){
  size(800, 400);
  background(0);
  smooth();
  ellipseMode(CENTER_RADIUS);
  noStroke();
  createWheel(width/4, height/2, SHADE);
  createWheel(width - width/4, height/2, TINT);
}

void createWheel(int x, int y, int valueShift){
  radius = 175;
  ratio = .65;
  if (valueShift == SHADE){
    // left wheel
    for (int j=1; j<5; j+=1){
      color[]cols = {
        color(255/j, 255/j, 0), color(255/j, (255/1.5)/j, 0), color(255/j, (255/2)/j, 0),
        color(255/j, (255/2.5)/j, 0), color(255/j, 0, 0), color(255/j, 0, (255/2)/j),
        color(255/j, 0, 255/j), color((255/2)/j, 0, 255/j), color(0, 0, 255/j),
        color(0, 255/j, (255/2)/j), color(0, 255/j, 0), color((255/2)/j, 255/j, 0) };
      for (int i=0; i< segs; i++){
        fill(cols[i]);
        arc(x, y, radius, radius, interval*i+rotAdjust, interval*(i+1)+rotAdjust);
      }
      radius*=ratio;
      ratio-=.1;
    }
  }

  else if (valueShift == TINT){
    //right wheel
    for (float j=0; j<1.5; j+=.3){
      color[]cols = {
        color(255, 255, 255*j), color(255, (255/1.5)+255*j, 255*j),
        color(255, (255/2)+255*j, 255*j),
        color(255, (255/2.5)+255*j, 255*j), color(255, 255*j, 255*j),
        color(255, 255*j, (255/2)+255*j),
        color(255, 255*j, 255), color((255/2)+255*j, 255*j, 255),
        color(255*j, 255*j, 255),
        color(255*j, 255, (255/2)+255*j), color(255*j, 255, 255*j),
        color((255/2)+255*j, 255, 255*j) };
      for (int i=0; i< segs; i++){
        fill(cols[i]);
        arc(x, y, radius, radius, interval*i+rotAdjust, interval*(i+1)+rotAdjust);
      }
      radius*=ratio;
      ratio-=.1;
    }
  }
}
