PImage earthImg;
PShape earth;
float angle = 0;

void setup() {
  size(800, 600, P3D);                    // 3D canvas—no two-ply needed
  earthImg = loadImage("earth.jpg");      // load the world map (sorry, no one-ply here)
  
  sphereDetail(50);                       // make it smooth—nobody likes rough poop
  earth = createShape(SPHERE, 200);       // create a sphere “globe-trotter”
  earth.setTexture(earthImg);             // slap the map on like bad bathroom décor
}

void draw() {
  background(0);                          // black hole vibes—hiding all the crap
  lights();                               // turn on lights so this turd doesn’t blend in
  translate(width/2, height/2);           // center the globe—no one likes off-center shit
  rotateY(angle);                         // spin that dirty world like a filthy carousel
  shape(earth);                           // draw it—hope it doesn’t stink too much
  angle += 0.01;                          // slow and steady, like a well-timed dump
}
