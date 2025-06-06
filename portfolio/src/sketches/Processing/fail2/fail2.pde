int cols = 20, rows = 20, layers = 20;
float spacing = 20;
float t = 0;

void setup() {
  size(800, 800, P3D);
  noStroke();
  frameRate(60);
}

void draw() {
  background(0);
  lights();
  translate(width/2, height/2, -200);
  rotateX(-PI/6);
  rotateY(frameCount * 0.005);

  float o = 1.0 - constrain(dist(mouseX, mouseY, width/2, height/2) / (width/2), 0, 1);
  o = pow(o, 4); // exaggerate collapse zone

  for (int z = 0; z < layers; z++) {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        float px = (x - cols/2) * spacing;
        float py = (y - rows/2) * spacing;
        float pz = (z - layers/2) * spacing;

        float q = sin(t + x*0.3 + z*0.5) * cos(t + y*0.2 + z*0.1); // Q
        float pop = 0.5 + 0.5 * sin(t + x*0.2 + y*0.3 + z*0.4);     // P
        float travel = sin(t * 0.7 + x*0.1 + y*0.1);                // T
        float observe = 1.0 - o;                                    // O

        float total = pop * abs(q) * abs(travel) * observe;        // 4-vertical product

        float size = map(total, 0, 1, 2, 16);

        pushMatrix();
        translate(px, py, pz);
        fill(180 + 60 * q, 255 * pop * observe, 200 + 55 * travel * observe);
        sphere(size);
        popMatrix();
      }
    }
  }

  t += 0.01;
}
