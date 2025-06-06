void myVertex() {
  beginShape(); //optional params
  vertex(100, 100);
  vertex(300, 300);
  vertex(random(180, 290), random(180, 290));
  endShape(CLOSE); //optional params
}
