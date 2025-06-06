int counties = 10;
int timeSteps = 100;
float[][] P = new float[counties][timeSteps];  // Population matrix
float[][] T = new float[counties][timeSteps];  // Travel/shift matrix
float[][] Q = new float[counties][timeSteps];  // Policy influence matrix

void setup() {
  size(800, 400);
  frameRate(10);

  // Initialize P with starting populations
  for (int i = 0; i < counties; i++) {
    float pop = random(5000, 50000); // start with some population
    for (int j = 0; j < timeSteps; j++) {
      P[i][j] = pop;
      T[i][j] = random(-0.02, 0.02); // net % travel per timestep
      Q[i][j] = random(-1, 1);       // effect modifier (e.g. policy boost or restriction)
    }
  }
}

int t = 0;

void draw() {
  background(0);
  if (t < timeSteps - 1) {
    // Update population based on T and Q
    for (int i = 0; i < counties; i++) {
      float delta = P[i][t] * T[i][t] * (1 + Q[i][t]);
      P[i][t+1] = constrain(P[i][t] + delta, 0, 100000);  // keep within bounds
    }
    t++;
  }

  // Visualize population distribution as heat map
  float cellW = width / float(timeSteps);
  float cellH = height / float(counties);
  
  for (int i = 0; i < counties; i++) {
    for (int j = 0; j <= t; j++) {
      float intensity = map(P[i][j], 0, 100000, 0, 255);
      fill(intensity, 180, 255 - intensity);
      noStroke();
      rect(j * cellW, i * cellH, cellW, cellH);
    }
  }
}
