/* Grid3DSketches_v2.pde
 * Mix of 2D and 3D panels: 60 random sketches in a 4×3 grid.
 * 3D panels include rotating cone, cylinder (rod), and specular sphere.
 * Panels use grayscale backgrounds with neon vertex highlights (magenta, yellow, cyan).
 * Press any key to shift grid by one column.
 */
int totalSketches = 60;
int cols = 4, rows = 3;
PGraphics[] sketches;
int offset = 0;
color[] neon = {#FF00FF, #FFFF00, #00FFFF};
void settings() {
  size(1200, 900, P3D);
}
void setup() {
  sketches = new PGraphics[totalSketches];
  for (int i = 0; i < totalSketches; i++) {
    sketches[i] = createPanel();
  }
}
void draw() {
  background(0);
  float cellW = width / float(cols);
  float cellH = height / float(rows);
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      int idx = (offset + r*cols + c) % totalSketches;
      image(sketches[idx], c*cellW, r*cellH, cellW, cellH);
    }
  }
}
void keyPressed() {
  offset = (offset + cols) % totalSketches;
}
PGraphics createPanel() {
  boolean is3D = random(1) < 0.5;
  PGraphics pg = is3D ? createGraphics(400, 300, P3D) : createGraphics(400, 300);
  pg.beginDraw();
  int bg = (int)random(50, 200);
  pg.background(bg);
  if (is3D) {
    pg.lights();
    pg.translate(pg.width*0.5, pg.height*0.5, 0);
    // Introduce axis-flip animation
    float angle = frameCount * 0.02;
    pg.rotateX(angle);
    pg.rotateY(angle * 0.5);
    pg.stroke(neon[int(random(neon.length))]);
    pg.fill(bg);
    int shapeType = int(random(3));
    switch (shapeType) {
      case 0:
        drawCone(pg, 60, 120);
        break;
      case 1:
        drawCylinder(pg, 30, 150);
        break;
      case 2:
        pg.pushStyle();
        pg.specular(255);
        pg.shininess(20);
        pg.sphere(70);
        pg.popStyle();
        break;
    }
  } else {
    // match one 2D panel with its 3D counterpart via shapeType hint
    int matchHint = int(random(3));
    int shapes = int(random(3, 8));
    pg.noFill();
    pg.stroke(random(150, 255));
    for (int i = 0; i < shapes; i++) {
      float x = random(pg.width);
      float y = random(pg.height);
      float w = random(20, pg.width*0.5);
      float h = random(20, pg.height*0.5);
      pg.strokeWeight(random(1, 4));
      switch (matchHint) {
        case 0: pg.ellipse(x, y, w, h); break;       // echo cone base circle
        case 1: pg.rect(x, y, w, h); break;          // echo cylinder face
        case 2: pg.point(x, y); break;               // echo sphere points
      }
    }
  }
  pg.endDraw();
  return pg;
}
// Draw a simple cone on pg
void drawCone(PGraphics pg, float r, float h) {
  int detail = 24;
  pg.beginShape(TRIANGLE_FAN);
  pg.vertex(0, -h*0.5, 0);
  for (int i = 0; i <= detail; i++) {
    float theta = TWO_PI * i / detail;
    float x = cos(theta) * r;
    float z = sin(theta) * r;
    pg.vertex(x, h*0.5, z);
  }
  pg.endShape();
}
// Draw a simple cylinder on pg
void drawCylinder(PGraphics pg, float r, float h) {
  int detail = 24;
  pg.beginShape(QUAD_STRIP);
  for (int i = 0; i <= detail; i++) {
    float theta = TWO_PI * i / detail;
    float x = cos(theta) * r;
    float z = sin(theta) * r;
    pg.vertex(x, -h*0.5, z);
    pg.vertex(x, h*0.5, z);
  }
  pg.endShape();
}
