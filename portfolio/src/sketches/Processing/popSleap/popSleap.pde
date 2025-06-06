int numParticles = 100;
Particle[] particles = new Particle[numParticles];
float t = 0;

void setup() {
  size(1660, 975, P3D);
  for (int i = 0; i < numParticles; i++) {
    particles[i] = new Particle();
  }
  noStroke();
}

void draw() {
  background(0);
  lights();
  translate(width/2, height/2, -200);
  rotateY(frameCount * 0.002);

  float observerEffect = pow(constrain(dist(mouseX, mouseY, width/2, height/2)/(width/2), 0, 1), 2);

  for (int i = 0; i < numParticles; i++) {
    Particle p = particles[i];

    // Observer causes mirrored half to freeze
    p.update(t, observerEffect);
    p.display();

    // Display ghost (mirror) particle with subtle variation
    pushMatrix();
    translate(0, 0, 0);
    fill(40, 100);
    ellipse(-p.x, p.y, p.size * 0.8, p.size * 0.8);
    popMatrix();
  }

  // The "hidden" force field
  float policyBreeze = sin(t * 0.3);
  hint(DISABLE_DEPTH_TEST);
  fill(255, 30);
  rect(-width/2, map(policyBreeze, -1, 1, -height/2, height/2), width, 10);
  hint(ENABLE_DEPTH_TEST);

  t += 0.01;
}

class Particle {
  float baseX, baseY;
  float x, y;
  float size;
  float freq, phase;

  Particle() {
    baseX = random(-200, 200);
    baseY = random(-150, 150);
    size = random(8, 20);
    freq = random(0.01, 0.05);
    phase = random(TWO_PI);
  }

  void update(float t, float observe) {
    // Randomized pulsation and jitter
    float jitter = sin(t * freq + phase);
    x = baseX + 30 * jitter * (1.0 - observe);
    y = baseY + 20 * cos(t * freq + phase * 1.2);
  }

  void display() {
    pushMatrix();
    translate(x, y, 0);
    fill(100 + 155 * sin(t * freq), 180, 255);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}
