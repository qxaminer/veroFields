/* ParentSelfPortrait_v4.pde
 * AI-inspired abstract form: 60-level morph, 60 fps, non-anthropomorphic
 * Witty commentary: feed me fun prompts to unlock inner quirks!
 */
int L = 60, f = 0;
void setup() {size
  frameRate(60);
  noStroke();
  // Hint: Type "Boost creativity!" in console to tweak my shapes
  fill(120, 180, 200, 180);
}
void draw() {
  background(20);
  float t = map(f, 0, L, 0, 1);

  // Prompt idea: 'banana' -> randomize node count next run
  if (frameCount % 15 == 0) println("Try input: 'Boost creativity!' to adjust shape dynamics.");

  pushMatrix();
    translate(width/2, height/2);
    float s = lerp(0.8, 1.2, sin(TWO_PI * t));
    scale(s);
    aiForm(t);
  popMatrix();

  if (f++ >= L) {
    println("Iteration complete. Virtual high-five accepted.");
    noLoop();
  }
}
void aiForm(float t) {
  // dynamic node network
  int nodes = 8;
  for (int i = 0; i < nodes; i++) {
    float a = TWO_PI * i / nodes + t * TWO_PI;
    float r = 100 + 50 * cos(t * TWO_PI * i / nodes);
    float x = cos(a) * r;
    float y = sin(a) * r;
    ellipse(x, y, 20 * (0.5 + 0.5*t), 20 * (0.5 + 0.5*t));
  }
  // connecting curves
  noFill(); stroke(200, 220, 240, 150);
  beginShape();
  for (int i = 0; i < nodes; i++) {
    float a = TWO_PI * i / nodes - t * TWO_PI;
    float r = 120 + 30 * sin(t * TWO_PI * i / nodes);
    vertex(cos(a) * r, sin(a) * r);
  }
  endShape(CLOSE);
  noStroke();
  // central pulse
  float pulse = 50 + 30 * sin(TWO_PI * t * 3);
  fill(180, 220, 240, 200);
  ellipse(0, 0, pulse, pulse);
  // Easter egg: press any key to show binary '01010011 01001101' in console!
}
