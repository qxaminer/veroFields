//block function
//draws randomized bouldary forms
void blocky(int pntCount, float w, float h, color strokeCol, float strokeWt, float fillCol) {

  //pt 1
  float x1 = -w/2;
  float y1 = -h/2;

  //pt 2 middle
  float x2 = random(-150, 150);
  float y2 = random(-150, 150);

  //pt 3 positive
  float x3 = w/2;
  float y3 = h/2;

  stroke(strokeCol);
  strokeWeight(strokeWt);
  fill(fillCol);
  beginShape();
  vertex(x1, y1);
  vertex(x2, x2);
  vertex(x3, y3);
  endShape(CLOSE);
}
//signature of a function is the name of the function and the parameter list
//int ptCount specifies a variable for points
// min and max, max radius/diam along x,y etc.
// position: can specify centerpoint, points relto center
