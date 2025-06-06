/* ParentSelfPortrait_v5.pde
 * AI-inspired abstract form: 60-level morph, 60 fps, with random arrays of shapes, sizes, and movement
 */
int L = 60, f = 0;
String[] prompts = {"Boost creativity!", "Add wobble!", "Particle time!", "Change trajectory!"};
void settings() { fullScreen(); }
void setup() {
  frameRate(60);
  noStroke();
  // Prompt types printed: cycle through prompts[]
  fill(120, 180, 200, 180);
}
void draw() {
  background(20);
  float t = map(f, 0, L, 0, 1);

  if(frameCount % 30 == 0) println("Try input: '"+prompts[(int)random(prompts.length)]+"' to tweak random behaviors.");

  pushMatrix();
    translate(width/2, height/2);
    float s = lerp(0.8, 1.2, sin(TWO_PI * t));
    scale(s);
    aiForm(t);
  popMatrix();

  if(f++ >= L) {
    println("Iteration complete. Virtual high-five accepted.");
    noLoop();
  }
}
void aiForm(float t) {
  int types = (int)random(3,7); // random number of shape types
  for(int j=0; j<types; j++){
    float phase = random(1);
    int choice = (int)random(4);
    pushMatrix();
    rotate(TWO_PI * phase * t);
    switch(choice) {
      case 0:
        wobbleCircles(t, phase);
        break;
      case 1:
        trajectoryLines(t, phase);
        break;
      case 2:
        dissolvePoints(t);
        break;
      case 3:
        particleBurst(t);
        break;
    }
    popMatrix();
  }
}

void wobbleCircles(float t, float phase) {
  noFill(); stroke(200,220,240,150);
  float r = 100 + 50 * sin(TWO_PI * t + phase * PI);
  ellipse(0,0, r*(0.5+t), r*(0.3+t));
}

void trajectoryLines(float t, float phase) {
  stroke(180,200,220,180);
  for(int i=0; i<10; i++){
    line(0,0, cos(TWO_PI*i/10 + phase)*200*t, sin(TWO_PI*i/10 + phase)*200*t);
  }
}

void dissolvePoints(float t) {
  noStroke(); fill(180,220,240,200);
  for(int i=0; i<50; i++){
    float x = random(-200,200)*t;
    float y = random(-200,200)*t;
    ellipse(x,y, 5 * (1-t), 5 * (1-t));
  }
}

void particleBurst(float t) {
  noStroke(); fill(200,180,220,180);
  int p = (int)map(t,0,1,10,100);
  for(int i=0; i<p; i++){
    float a = random(TWO_PI);
    float m = random(50,200) * t;
    ellipse(cos(a)*m, sin(a)*m, 3,3);
  }
}

void keyPressed() {
  println("Binary whisper: 01010011 01001101");
}
