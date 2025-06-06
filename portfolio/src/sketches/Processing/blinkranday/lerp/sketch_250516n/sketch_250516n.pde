/*  ─────────────────────────────────────────────────────────────────────────
    MINI–GAME (full sketch) – with guaranteed‑intercept speed and editable  
    wing geometry.   Changes vs. last build are marked //modelcom          
    ─────────────────────────────────────────────────────────────────────────
*/

// ===== 1. GLOBAL TUNEABLE CONSTANTS =======================================

// --- Wing geometry (triangle shape) ----------------------------- //modelcom
float wingHalfSpan  = 18;   // half “wingspan” of delta (px)        //modelcom
float wingNoseAhead = 24;   // nose length ahead of CG              //modelcom
float wingTailBack  = 13;   // tail sweep distance                  //modelcom

// --- Speeds ------------------------------------------------------ //modelcom
float wingBaseSpeed    = 10;  // minimum launch speed               //modelcom
float wingReturnSpeed  = 12;  // speed when RTB                     //modelcom

// --- Gameplay variety --------------------------------------------
int   escortOffsetMin  = 35, escortOffsetMax = 55;
int   orbitLoopsMin=1, orbitLoopsMax=3;
float orbitRadiusMin=30, orbitRadiusMax=60;
int   fadeDurMin=60, fadeDurMax=120;
int   respawnDelay = 120;
int   scanPulseLen = 35;

// ===== 2. GLOBAL STATE VARS ======================================
float x, y, w=150, h=60, spdX, spdY;
color fillCol, strokeCol;
boolean squareVisible = true;
int    stateType;                     // 0 orbit, 1 destroy, 2 escort

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

// respawn
int respawnTimer=0;

// ===== 3. HELPER FUNCTIONS  ======================================

// compute dynamic intercept speed so probe reaches rect before edge //modelcom
float computeInterceptSpeed(){                                       //modelcom
  float cx=x+w/2, cy=y+h/2;                                          // center
  float tX = (spdX>0)?(width-cx)/spdX:(spdX<0)?cx/-spdX:Float.MAX_VALUE;
  float tY = (spdY>0)?(height-cy)/spdY:(spdY<0)?cy/-spdY:Float.MAX_VALUE;
  float rectExitTime = min(tX,tY);                                   // soonest
  float dist   = dist(ellX,ellY,cx,cy);
  return max(wingBaseSpeed, dist/max(rectExitTime,1)*1.1);           // +10 %
}

// rectangle centre
PVector rectCenter(){ return new PVector(x+w/2,y+h/2); }

// target flank position for escort probe
PVector escortTarget(int side){
  PVector dir=new PVector(spdX,spdY);
  if(dir.mag()==0) dir.set(1,0);
  dir.normalize().rotate(radians(45*side))
      .mult(random(escortOffsetMin,escortOffsetMax));
  return PVector.add(rectCenter(),dir);
}

// start desaturation / fade
void startFade(){
  fading=true;
  fadeFrames=int(random(fadeDurMin,fadeDurMax));
}

// ===== 4. WING CLASS  ============================================
class Wing{
  PVector pos, vel;
  int mode;          // 0 orbit,1 return,2 destroy,3 escort,4 escortRet
  float angle,radius,orbitSpeed;
  int   loopsLeft;
  int   side;        // flank side for escort

  Wing(PVector p,int m){ pos=p.copy(); mode=m; }

  void update(){
    if(mode==0){ // ORBIT
      angle+=orbitSpeed;
      pos.set(rectCenter().x+cos(angle)*radius,
              rectCenter().y+sin(angle)*radius);
      if(angle>=TWO_PI && --loopsLeft<=0){
        mode=1;
        vel=PVector.sub(base,pos).setMag(wingReturnSpeed);  // vel for RTB //modelcom
      }
    }else if(mode==1||mode==4){ // RETURN
      PVector dir=PVector.sub(base,pos).setMag(wingReturnSpeed);
      vel=dir; pos.add(dir);
      if(pos.dist(base)<wingReturnSpeed) wings.remove(this);
    }else if(mode==2){ // DESTROY
      pos.add(vel);
      if(pos.dist(rectCenter())<6){
        startFade(); wings.remove(this);
      }
    }else if(mode==3){ // ESCORT
      PVector tgt=escortTarget(side);
      pos.add(PVector.sub(tgt,pos).mult(0.15));
      if(!squareVisible){ mode=4; vel=PVector.sub(base,pos).setMag(wingReturnSpeed); }
    }
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(atan2(vel.y,vel.x));          // orient nose along velocity //modelcom
    fill(255,50,0); noStroke();
    beginShape();                        // delta drawn from globals   //modelcom
    vertex(-wingTailBack,-wingHalfSpan);
    vertex( wingNoseAhead,0);
    vertex(-wingTailBack, wingHalfSpan);
    endShape(CLOSE);
    popMatrix();
  }
}

// ===== 5. SETUP & DRAW  ==========================================
void setup(){
  size(1960,975);
  colorMode(HSB,360,100,100,255);
  base=new PVector(width/2,height/2);
  ellX=base.x; ellY=base.y;
  initSquare();
}

void draw(){
  background(0,0,50);
  updateCircle();
  updateSquare();
  updateTriangle();
  updateWings();
  handleRespawn();
}

// ===== 6. UPDATE SECTIONS  =======================================
void updateCircle(){
  grayNow=lerp(grayNow,grayNext,lerpAmt);
  if(abs(grayNow-grayNext)<1){
    grayNext=random(255); lerpAmt=speeds[int(random(speeds.length))];
    boolean trig=grayNext>brightnessThreshold;
    if(trig&&!connected&&squareVisible) triggerEncounter();
    connected=trig&&squareVisible;
  }
  fill(scanPulse>0?scanColor:color(grayNow));
  noStroke(); ellipse(ellX,ellY,ellSize,ellSize);
}

void updateSquare(){
  if(!squareVisible) return;
  x+=spdX; y+=spdY;
  if(x>width||x+w<0||y>height||y+h<0){ squareVisible=false; return;}
  if(fading){
    fadeSat=max(0,fadeSat-1.0/fadeFrames);
    if(fadeSat==0) fadeAlpha=max(0,fadeAlpha-255.0/fadeFrames);
    if(fadeAlpha==0){ squareVisible=false; fading=false; }
  }
  float h0=hue(fillCol),b0=brightness(fillCol);
  color c2=color(h0,map(fadeSat,0,1,0,saturation(fillCol)),
                 map(fadeSat,0,1,0,b0),fadeAlpha);
  fill(c2); stroke(strokeCol); strokeWeight(5); rect(x,y,w,h);
}

void updateTriangle(){
  if(!connected||!squareVisible) return;
  PVector cir=new PVector(ellX,ellY), sq=rectCenter();
  dynPhase+=0.1; float off=sin(dynPhase)*dynAmp;
  PVector apex=new PVector(sq.x+off,sq.y);
  PVector v=PVector.sub(apex,cir).normalize();
  PVector perp=new PVector(-v.y,v.x).mult(20);
  noStroke();
  fill(scanPulse>0?scanColor:color(120,255,0,80));
  beginShape();
  vertex(apex.x,apex.y);
  vertex(cir.x+perp.x,cir.y+perp.y);
  vertex(cir.x-perp.x,cir.y-perp.y);
  endShape(CLOSE);
}

void updateWings(){
  for(int i=wings.size()-1;i>=0;i--){ Wing wg=wings.get(i); wg.update(); wg.draw(); }
  if(scanPulse>0 && --scanPulse==0) grayNext=random(255);
}

void handleRespawn(){
  if(squareVisible||wings.size()>0) return;
  if(++respawnTimer>=respawnDelay){ initSquare(); respawnTimer=0; }
}

// ===== 7. ENCOUNTER LOGIC  ======================================
void triggerEncounter(){
  scanColor=fillCol; scanPulse=scanPulseLen;
  switch(stateType){
    case 0: spawnOrbitProbe();   break;
    case 1: spawnDestroyProbe(); break;
    case 2: spawnEscortProbes(); break;
  }
}

// --- probe spawners with dynamic speed --------------------------- //modelcom
void spawnOrbitProbe(){
  float launch=computeInterceptSpeed();
  Wing w=new Wing(base,0);
  w.radius=random(orbitRadiusMin,orbitRadiusMax);
  w.angle=atan2(rectCenter().y-base.y,rectCenter().x-base.x);
  w.orbitSpeed=random(0.05,0.12);
  w.loopsLeft=int(random(orbitLoopsMin,orbitLoopsMax+1));
  w.vel=PVector.sub(rectCenter(),base).setMag(launch);
  wings.add(w);
}
void spawnDestroyProbe(){
  float launch=computeInterceptSpeed();
  Wing w=new Wing(base,2);
  w.vel=PVector.sub(rectCenter(),base).setMag(launch);
  wings.add(w);
}
void spawnEscortProbes(){
  float launch=computeInterceptSpeed();
  for(int s=-1;s<=1;s+=2){
    Wing w=new Wing(base,3);
    w.side=s;
    w.vel=PVector.sub(rectCenter(),base).setMag(launch); // used for draw orient
    wings.add(w);
  }
}

// ===== 8. INIT NEW RECTANGLE  ====================================
void initSquare(){
  w=150; h=60;
  x=random(width-w); y=random(height-h);
  spdX=random(-1.2,1.3); spdY=random(-3.2,3.2);
  if(spdX==0&&spdY==0){ spdX=1; spdY=1; }
  fillCol=color(random(360),80,100);
  strokeCol=color(random(360),80,80);
  squareVisible=true; fading=false; fadeSat=1; fadeAlpha=255;
  stateType=int(random(3)); wings.clear(); connected=false;
}
