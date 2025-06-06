PImage earthImg;
PShape earth;
float angle = 0;

// All the inline-comment jokes will live here
String[] comments = {
  "3D canvas—no two-ply needed",
  "Generate map data—sorry, no one-ply here",
  "Smooth sphere—nobody likes rough poop",
  "Make a globe-trotter sphere",
  "Color land green and water red—talk about fresh turds",
  "Black background hides all the crap",
  "Lights on—so this turd doesn’t blend in",
  "Center the world—no one likes off-center shit",
  "Spin it fast—like a high-speed dump",
  "Draw it—hope it doesn’t stink too much",
  "Turbo dump speed engaged"
};

void setup() {
  size(800, 600, P3D);                   // 3D canvas—no two-ply needed
  
  // SYNTHETIC “earth.jpg” via Perlin noise
  int w = 512, h = 256;
  earthImg = createImage(w, h, RGB);     // Generate map data—sorry, no one-ply here
  earthImg.loadPixels();
  float scale = 0.02;
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float n = noise(x * scale, y * scale);
      int col = (n > 0.5)
        ? color(0, 255, 0)               // land → green
        : color(255, 0, 0);              // water → red
      earthImg.pixels[y * w + x] = col;
    }
  }
  earthImg.updatePixels();
  
  sphereDetail(60);                       // Smooth sphere—nobody likes rough poop
  earth = createShape(SPHERE, 200);       // Make a globe-trotter sphere
  earth.setTexture(earthImg);
}

void draw() {
  background(0);                          // Black background hides all the crap
  lights();                               // Lights on—so this turd doesn’t blend in
  
  // Draw & spin Earth
  pushMatrix();
    translate(width/2, height/2);
    rotateY(angle);                      // Spin it fast—like a filthy carousel
    shape(earth);                        // Draw it—hope it doesn’t stink too much
  popMatrix();
  
  angle += 0.2;                           // Turbo dump speed engaged
  
  // Draw a nearby moon
  pushMatrix();
    translate(width/2 + 300, height/2 - 100, 0);
    fill(150);                           // Gray moon
    noStroke();
    sphere(50);
  popMatrix();
  
  // Overlay the poop-joke speech bubble
  hint(DISABLE_DEPTH_TEST);
  camera();                              // Fix 2D UI in place
  noLights();
  fill(255);
  stroke(0);
  int boxX = 500, boxY = 40;
  int boxW = 270, boxH = comments.length * 18 + 20;
  rect(boxX, boxY, boxW, boxH);
  
  fill(0);
  textSize(12);
  for (int i = 0; i < comments.length; i++) {
    text(comments[i], boxX + 10, boxY + 20 + i * 18);
  }
  hint(ENABLE_DEPTH_TEST);
}
