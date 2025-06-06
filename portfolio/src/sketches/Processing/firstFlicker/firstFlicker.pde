//El Vertex
void setup(){
size(800,400);
  background(255);  //background if we want to do animation rgb 2^8*3 + alpha value
  //draw a 4 pointed shape that is sort of square but has some variation
  //vertex draws points.  beginShape - endShape  all 3 work together
  //calling a function within a function where inside happens before outside
  beginShape();
  
  vertex(100, 100);
  vertex(300, 300);
  vertex(300, 300);
  vertex(random(180, 220), random(180, 220)); 
  
  endShape();
}
//static images
void draw(){
  background(255);  //background if we want to do animation rgb 2^8*3 + alpha value
  //draw a 4 pointed shape that is sort of square but has some variation
  //vertex draws points.  beginShape - endShape  all 3 work together
  //calling a function within a function where inside happens before outside
  beginShape();
  
  vertex(100, 100);
  vertex(300, 300);
  vertex(300, 300);
  vertex(random(180, 220), random(180, 220)); 
  
  endShape();
}
