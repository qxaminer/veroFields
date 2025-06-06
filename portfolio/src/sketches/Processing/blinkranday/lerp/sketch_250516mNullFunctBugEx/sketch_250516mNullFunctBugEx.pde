/*  MULTI‑STATE “GROUND‑STATION” MINI‑GAME
    ---------------------------------------------------------------
    Circle = base station (grayscale radar dish)
    Rectangle = passing object with one of 3 hidden “states”
        0 → ORBIT   (green tag)  – probe flies a few loops then returns
        1 → DESTROY (red tag)    – probe hits, rectangle desaturates & fades
        2 → ESCORT  (blue tag)   – probe splits into two flankers @ ±45°
                                    that escort until the rectangle exits
    Triangle = live data link (changes colour during scan phase)
    ---------------------------------------------------------------
    Tuneables marked with //modelcom
*/

// ===== GLOBAL TYPES =======================================================

class Wing {
  PVector pos, vel;
  int mode;              // 0 orbit,1 return,2 destroy,3 escort,4 escortRet
  float angle, radius, orbitSpeed;
  int   loopsLeft;
  int   side;            // -1 or +1 for escort flank
  Wing(PVector p, int m) { pos = p.copy(); mode = m; }
  void update() {
    if (mode == 0) {                       // ORBIT
      angle += orbitSpeed;
      pos.set(rectCenter().x + cos(angle)*radius,
              rectCenter().y + sin(angle)*radius);
      if (angle >= TWO_PI && --loopsLeft <= 0) mode = 1;     // to RETURN
    } else if (mode == 1 || mode == 4) {    // RETURN (single or escort)
      PVector dir = PVector.sub(base, pos).setMag(wingReturnSpeed);
      pos.add(dir);
      if (pos.dist(base) < wingReturnSpeed) wings.remove(this);
    } else if (mode == 2) {                 // DESTROY (ram straight)
      pos.add(vel);
      if (pos.dist(rectCenter()) < 6) {            // impact
        startFade();                               // desaturate & fade
        wings.remove(this);                        // probe destroyed
      }
    } else if (mode == 3) {                 // ESCORT
      PVector tgt = escortTarget(side);
      pos.add(PVector.sub(tgt, pos).mult(0.15));   // ease toward flank
      if (!squareVisible) mode = 4;                // rectangle gone → return
    }
  }
  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    if (mode==0||mode==2||mode==1||mode==4) rotate(atan2(vel.y, vel.x));
    else if (mode==3) rotate(atan2(spdY, spdX));   // face travel dir
    fill(255, 50, 0);
    noStroke();
    beginShape();
    vertex(-9, -4); vertex(12, 0); vertex(-9, 4);
    endShape(CLOSE);
    popMatrix();
  }
}

// ===== GLOBAL VARS ========================================================
float x, y, w=150, h=60, spdX, spdY;
color fillCol, strokeCol;
boolean squareVisible = true;
int    stateType;                 // 0 orbit   1 destroy   2 escort

float ellX, ellY, ellSize = 100;
float grayNow=random(255), grayNext=random(255), lerpAmt=0.05;
float[] speeds = {0.01, 0.05, 0.15, 0.30};
boolean connected=false;
float brightnessThreshold = 200;

float dynPhase=0, dynAmp=30;
PVector base;

ArrayList<Wing> wings = new ArrayList<Wing>();

// fade vars
boolean fading=false; float fadeSat=1, fadeAlpha=255; int fadeFrames;
// scan‑pulse vars
int scanPulse=0; color scanColor;

// tuneables ---------------------------------------------------------------
// (play with these)
float wingSpeed        = 10;     // straight‑line speed
float wingReturnSpeed  = 12;     // speed when heading back to base
int   escortOffsetMin  = 35, escortOffsetMax = 55;
int   orbitLoopsMin=1, orbitLoopsMax=3;
float orbitRadiusMin=30, orbitRadiusMax=60;
int   fadeDurMin=60, fadeDurMax=120;
int   respawnDelay = 120;
int   scanPulseLen = 35;

int respawnTimer=0;

void setup(){
  size(1960,975);
  colorMode(HSB,360,100,100,255);          // easier hue work
  base = new PVector(width/2, height/2);
  ellX = base.x; ellY = base.y;
  initSquare();
}

void draw(){
  background(0,0,50);                      // neutral gray backdrop

  updateCircle();
  updateSquare();
  updateTriangle();
  updateWings();
  handleRespawn();
}

// ===== UPDATE SECTIONS ====================================================

void updateCircle(){
  // flicker
  grayNow = lerp(grayNow, grayNext, lerpAmt);
  if (abs(grayNow-grayNext)<1){
    grayNext = random(255);
    lerpAmt  = speeds[int(random(speeds.length))];
    boolean trig = grayNext>brightnessThreshold;
    if(trig && !connected && squareVisible) triggerEncounter();
    connected = trig && squareVisible;
  }
  // draw circle (flash scan colour if active)
  if(scanPulse>0) fill(scanColor); else fill(grayNow);
  noStroke();
  ellipse(ellX,ellY,ellSize,ellSize);
}

void updateSquare(){
  if(!squareVisible) return;
  // move
  x+=spdX; y+=spdY;
  // wrap
  if(x>width || x+w<0 || y>height || y+h<0){ squareVisible=false; return; }
  // fade logic
  if(fading){
    fadeSat = max(0, fadeSat-1.0/fadeFrames);
    if(fadeSat==0) fadeAlpha = max(0, fadeAlpha-255.0/fadeFrames);
    if(fadeAlpha==0){ squareVisible=false; fading=false; }
  }
  // draw
  color c = fillCol;
  float h0 = hue(c), b0 = brightness(c);
  color c2 = color(h0, map(fadeSat,0,1,0,saturation(c)), map(fadeSat,0,1,0,b0), fadeAlpha);
  fill(c2); stroke(strokeCol); strokeWeight(5);
  rect(x,y,w,h);
}

void updateTriangle(){
  if(!connected||!squareVisible) return;
  PVector cir=new PVector(ellX,ellY), sq=rectCenter();
  dynPhase+=0.1; float off=sin(dynPhase)*dynAmp;
  PVector apex = new PVector(sq.x+off, sq.y);
  PVector v=PVector.sub(apex,cir).normalize(), perp=new PVector(-v.y,v.x).mult(20);
  noStroke();
  if(scanPulse>0) fill(scanColor,150); else fill(120,255,0,80); //modelcom
  beginShape();
  vertex(apex.x,apex.y); vertex(cir.x+perp.x,cir.y+perp.y); vertex(cir.x-perp.x,cir.y-perp.y);
  endShape(CLOSE);
}

void updateWings(){
  for(int i=wings.size()-1;i>=0;i--){
    Wing wg=wings.get(i);
    wg.update(); wg.draw();
  }
  if(scanPulse>0 && --scanPulse==0) grayNext=random(255); // end flash
}

void handleRespawn(){
  if(squareVisible) return;
  if(wings.size()>0) return;          // wait till probes back/gone
  respawnTimer++;
  if(respawnTimer>=respawnDelay){ initSquare(); respawnTimer=0; }
}

// ===== ENCOUNTER LOGIC ====================================================

void triggerEncounter(){
  switch(stateType){
    case 0: spawnOrbitProbe(); break;
    case 1: spawnDestroyProbe(); break;
    case 2: spawnEscortProbes(); break;
  }
  // once probe deployed we send colour sample
  scanColor=fillCol; scanPulse=scanPulseLen;      // circle flashes
}

void spawnOrbitProbe(){
  Wing w = new Wing(base,0);
  w.radius     = random(orbitRadiusMin, orbitRadiusMax);
  w.angle      = atan2(rectCenter().y-base.y, rectCenter().x-base.x);
  w.orbitSpeed = random(0.05,0.12);
  w.loopsLeft  = int(random(orbitLoopsMin, orbitLoopsMax+1));
  w.vel        = PVector.sub(rectCenter(),base).setMag(wingSpeed);
  wings.add(w);
}

void spawnDestroyProbe(){
  Wing w = new Wing(base,2);
  w.vel = PVector.sub(rectCenter(),base).setMag(wingSpeed);
  wings.add(w);
}

void spawnEscortProbes(){
  for(int s=-1;s<=1;s+=2){
    Wing w = new Wing(base,3);
    w.side=s;
    wings.add(w);
  }
}

void startFade(){                                 // desaturate rectangle
  fading=true;
  fadeFrames = int(random(fadeDurMin,fadeDurMax));
}

// ===== HELPERS ============================================================

void initSquare(){
  w=150; h=60;
  x=random(width-w); y=random(height-h);
  spdX=random(-1.2,1.3); spdY=random(-3.2,3.2);
  if(spdX==0&&spdY==0){ spdX=1; spdY=1; }
  fillCol = color(random(360), 80, 100);
  strokeCol=color(random(360),80,80);
  squareVisible=true; fading=false; fadeSat=1; fadeAlpha=255;
  stateType = int(random(3));                    // pick behaviour bucket
  wings.clear(); connected=false;                // reset probes / link
}

PVector rectCenter(){ return new PVector(x+w/2,y+h/2); }
PVector escortTarget(int side){
  PVector dir=new PVector(spdX,spdY);
  if(dir.mag()==0) dir=new PVector(1,0);
  dir.normalize();
  dir.rotate(radians(45*side));                 // ±45°
  dir.mult(random(escortOffsetMin,escortOffsetMax));
  return PVector.add(rectCenter(),dir);
}
