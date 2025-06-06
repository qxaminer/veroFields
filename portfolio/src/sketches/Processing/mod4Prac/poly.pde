//create a custom polygon (pos. radius. numpoints)
//color, strkweight, fill etc.
//float x = 0.0, y = 0.0; //determines initial position
float r = 0.0;
int ptCount = 0;

void poly(float x, float y, float r, int ptCount) {

  //draw the polygon
  float theta = 0.0;
  beginShape();

  for (int i = 0; i<ptCount; i++) {
    //float pt1X = x + cos(theta) * r;
    //float pt1Y = y + sin(theta) * r; //put expression inside call for terseness
    vertex(x + cos(theta)*r, y + sin(theta)*r);
    theta += TWO_PI/ptCount;
  }  //i j or k, i is single dimension. ; (2nd is sentinal/conditional value)

  endShape(CLOSE);
  //the cosine times radius maps polar to cartesian!
}
