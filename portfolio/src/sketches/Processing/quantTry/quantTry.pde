int cols = 20;
int rows = 20;
int layers = 20;
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

  for (int z = 0; z < layers; z++) {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        float px = (x - cols/2) * spacing;
        float py = (y - rows/2) * spacing;
        float pz = (z - layers/2) * spacing;

        // Composite wave: like policy + travel matrix
        float q = sin(t + x*0.3 + z*0.5) * cos(t + y*0.2 + z*0.1);
        float pop = 0.5 + 0.5 * sin(t + x*0.2 + y*0.3 + z*0.4); // fake pop fluctuation
        float size = map(pop * abs(q), 0, 1, 2, 16);

        pushMatrix();
        translate(px, py, pz);
        fill(120 + 100*q, 255 * pop, 200 + 50*sin(q*PI));
        sphere(size);
        popMatrix();
      }
    }
  }

  t += 0.01;
}
