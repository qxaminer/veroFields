//Rotated Triangle
size(350, 350);
background(255);
smooth();
strokeWeight(3);
noFill();
translate(width/2, height/2);
for (int i=0; i< 20; i++){
  stroke(random(255), random(255), random(255));
  triangle(-120, 120, 120, 120, 0, -120);
  rotate(TWO_PI/20);
}
