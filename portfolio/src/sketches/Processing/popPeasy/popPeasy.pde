int cols = 100;  // longitude divisions
int rows = 50;   // latitude divisions
float[][] pop;   // population intensity (0 to 1)

void setup() {
  size(800, 600, P3D);
  pop = new float[cols][rows];
  noStroke();
  frameRate(60);

  // Simulated population heatmap values
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float lat = map(j, 0, rows-1, -PI/2, PI/2);
      float lon = map(i, 0, cols-1, -PI, PI);
      pop[i][j] = popDensity(lat, lon);  // fake heat
    }
  }
}

void draw() {
  background(0);
  lights();
  translate(width/2, height/2);
  rotateY(frameCount * 0.01);  // auto-rotation

  float r = 150;

  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      beginShape(QUADS);
      for (int ii = 0; ii <= 1; ii++) {
        for (int jj = 0; jj <= 1; jj++) {
          int x = i + ii;
          int y = j + jj;

          float theta = map(x, 0, cols, 0, TWO_PI);
          float phi = map(y, 0, rows, 0, PI);

          float px = r * sin(phi) * cos(theta);
          float py = r * cos(phi);
          float pz = r * sin(phi) * sin(theta);

          float val = pop[x % cols][y % rows];
          fill(map(val, 0, 1, 0, 255), 80, 255 - map(val, 0, 1, 0, 255));
          vertex(px, py, pz);
        }
      }
      endShape();
    }
  }
}

float popDensity(float lat, float lon) {
  // Simulated clusters (equator boost + urban spikes)
  float equatorBias = exp(-pow(lat, 2) * 3);
  float hotspot = sin(3 * lon) * cos(2 * lat);
  return constrain((0.5 + 0.5 * hotspot) * equatorBias, 0, 1);
}
