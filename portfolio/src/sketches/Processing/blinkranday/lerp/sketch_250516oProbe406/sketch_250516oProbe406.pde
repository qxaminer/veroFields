/*  MINI‑GAME v3 ‑ Added:
      ① capped “no‑rectangle” downtime  (handleRespawn re‑written)      //modelcom
      ② colour‑dependent behaviours:                                   //modelcom
         • Red‑ish rect  → drifts slowly  (lingers)                    //modelcom
         • Green‑ish rect→ when a probe gets within 10 px, rect locks  //modelcom
                           onto that probe’s velocity (“formation”)    //modelcom
         • Blue‑ish rect → pulses transparency as it moves            //modelcom
      ③ editable wing span numbers already present up top.             //modelcom
*/

 /* ===== 1. GLOBAL TUNEABLES (unchanged except comments) ============ */
float wingHalfSpan  = 18;   // half “wingspan”
float wingNoseAhead = 24;   // nose length
float wingTailBack  = 13;   // tail sweep
float wingBaseSpeed = 10;   // minimum intercept speed
float wingReturnSpeed = 18; // faster RTB → shorter quiet time        //modelcom

int escortOffsetMin=35, escortOffsetMax=55;
int orbitLoopsMin=1, orbitLoopsMax=3;
float orbitRadiusMin=30, orbitRadiusMax=60;
int fadeDurMin=60, fadeDurMax=120;
int respawnDelay=120;           // max gap between rectangles          //modelcom
int scanPulseLen=35;

/* ===== 2. GLOBAL STATE ============================================ */
float x,y,w=150,h=60, spdX,spdY;
color fillCol, strokeCol;
boolean squareVisible=true, fading=false;
float fadeSat=1, fadeAlpha=255; int fadeFrames;
int stateType;                 // 0 orbit,1 destroy,2 escort
int colorBucket;               // 0 red,1 green,2 blue/other          //modelcom
boolean greenLocked=false;                                            //modelcom

float ellX,ellY,ellSize=100;
float grayNow=random(255), grayNext=random(255), lerpAmt=0.05;
float[] speeds={0.01,0.05,0.15,0.30};
boolean connected=false;
float brightnessThreshold=200;

float dynPhase=0,dynAmp=30;
PVector base;
ArrayList<Wing> wings=new ArrayList<Wing>();

int scanPulse=0; color scanColor;
int respawnTimer=0;

/* ===== 3. HELPER FUNCTIONS ======================================== */
// compute minimum intercept speed so probe gets there in time
float computeInterceptSpeed(){
  float cx=x+w/2, cy=y+h/2;
  float tX=(spdX>0)?(width-cx)/spdX:(spdX<0)?cx/-spdX:Float.MAX_VALUE;
  float tY=(spdY>0)?(height-cy)/spdY:(spdY<0)?cy/-spdY:Float.MAX_VALUE;
  float exitT=min(tX,tY);
  float dist=dist(ellX,ellY,cx,cy);
  return max(wingBaseSpeed, dist/max(exitT,1)*1.1);
}
PVector rectCenter(){ return new PVector(x+w/2,y+h/2); }
PVector escortTarget(int side){
  PVector d=new PVector(spdX,spdY);
  if(d.mag()==0) d.set(1,0);
  d.normalize().rotate(radians(45*side))
   .mult(random(escortOffsetMin,escortOffsetMax));
  return PVector.add(rectCenter(),d);
}
void startFade(){ fading=true; fadeFrames=int(random(fadeDurMin,fadeDurMax)); }

/* ===== 4. WING CLASS ============================================== */
class Wing{
  PVector pos,vel; int mode;   // 0 orbit,1 return,2 destroy,3 escort,4 escortRet
  float angle,radius,orbitSpeed; int loopsLeft; int side;
  Wing(PVector p,int m){ pos=p.copy(); mode=m; }

  void update(){
    if(mode==0){ // ORBIT
      angle+=orbitSpeed;
      pos.set(rectCenter().x+cos(angle)*radius,
              rectCenter().y+sin(angle)*radius);
      if(angle>=TWO_PI && --loopsLeft<=0){
        mode=1; vel=PVector.sub(base,pos).setMag(wingReturnSpeed);
      }
    }else if(mode==1||mode==4){ // RETURN
      PVector dir=PVector.sub(base,pos).setMag(wingReturnSpeed);
      vel=dir; pos.add(dir);
      if(pos.dist(base)<wingReturnSpeed) wings.remove(this);
    }else if(mode==2){ // DESTROY
      pos.add(vel);
      if(pos.dist(rectCenter())<6){ startFade(); wings.remove(this); }
    }else if(mode==3){ // ESCORT flank
      PVector tgt=escortTarget(side);
      pos.add(PVector.sub(tgt,pos).mult(0.15));
      if(!squareVisible){ mode=4; vel=PVector.sub(base,pos).setMag(wingReturnSpeed);}
    }
  }
  void draw(){
    pushMatrix(); translate(pos.x,pos.y);
    rotate(atan2(vel.y,vel.x));
    fill(255,50,0); noStroke();
    beginShape();
    vertex(-wingTailBack,-wingHalfSpan);
    vertex( wingNoseAhead,0);
    vertex(-wingTailBack, wingHalfSpan);
    endShape(CLOSE);
    popMatrix();
  }
}

/* ===== 5. SETUP/DRAW ============================================== */
void setup(){
  size(1960,975); colorMode(HSB,360,100,100,255);
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

/* ===== 6. UPDATE LOGIC =========================================== */
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

  /* --- Green behaviour: lock velocity when close ----------------- */ //modelcom
  if(colorBucket==1 && !greenLocked){                                     //modelcom
    for(Wing w:wings){                                                    //modelcom
      if(w.pos.dist(rectCenter())<10){                                    //modelcom
        spdX=w.vel.x; spdY=w.vel.y; greenLocked=true; break;             //modelcom
      }                                                                   //modelcom
    }                                                                     //modelcom
  }                                                                       //modelcom

  x+=spdX; y+=spdY;
  if(x>width||x+w<0||y>height||y+h<0){ squareVisible=false; return; }

  if(fading){
    fadeSat=max(0,fadeSat-1.0/fadeFrames);
    if(fadeSat==0) fadeAlpha=max(0,fadeAlpha-255.0/fadeFrames);
    if(fadeAlpha==0){ squareVisible=false; fading=false; }
  }

  /* Blue behaviour: pulse alpha with sine ------------------------- */ //modelcom
  float localAlpha = (colorBucket==2)                                      //modelcom
                       ? (200+55*sin(frameCount*0.1))                      //modelcom
                       : fadeAlpha;                                        //modelcom

  float h0=hue(fillCol), b0=brightness(fillCol);
  color c2=color(h0, map(fadeSat,0,1,0,saturation(fillCol)),
                 map(fadeSat,0,1,0,b0), localAlpha);
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
  fill(scanPulse>0?scanColor:color(120,0,100,80));
  beginShape(); vertex(apex.x,apex.y);
  vertex(cir.x+perp.x,cir.y+perp.y);
  vertex(cir.x-perp.x,cir.y-perp.y); endShape(CLOSE);
}

void updateWings(){
  for(int i=wings.size()-1;i>=0;i--){ Wing wg=wings.get(i); wg.update(); wg.draw();}
  if(scanPulse>0 && --scanPulse==0) grayNext=random(255);
}

void handleRespawn(){                                   // RE‑WRITTEN   //modelcom
  if(squareVisible) { respawnTimer=0; return; }
  if(++respawnTimer>=respawnDelay){
    wings.clear();                                      // cull stragglers
    initSquare(); respawnTimer=0;
  }
}

/* ===== 7. ENCOUNTER & PROBES ==================================== */
void triggerEncounter(){
  scanColor=fillCol; scanPulse=scanPulseLen;
  switch(stateType){
    case 0: spawnOrbitProbe();   break;
    case 1: spawnDestroyProbe(); break;
    case 2: spawnEscortProbes(); break;
  }
}
void spawnOrbitProbe(){
  float speed=computeInterceptSpeed();
  Wing w=new Wing(base,0);
  w.radius=random(orbitRadiusMin,orbitRadiusMax);
  w.angle=atan2(rectCenter().y-base.y,rectCenter().x-base.x);
  w.orbitSpeed=random(0.05,0.12);
  w.loopsLeft=int(random(orbitLoopsMin,orbitLoopsMax+1));
  w.vel=PVector.sub(rectCenter(),base).setMag(speed); wings.add(w);
}
void spawnDestroyProbe(){
  float speed=computeInterceptSpeed();
  Wing w=new Wing(base,2);
  w.vel=PVector.sub(rectCenter(),base).setMag(speed); wings.add(w);
}
void spawnEscortProbes(){
  float speed=computeInterceptSpeed();
  for(int s=-1;s<=1;s+=2){
    Wing w=new Wing(base,3); w.side=s;
    w.vel=PVector.sub(rectCenter(),base).setMag(speed); wings.add(w);
  }
}

/* ===== 8. SPAWN RECTANGLE ======================================= */
void initSquare(){
  w=150; h=60;
  x=random(width*0.2,width*0.8);            // spawns away from edges   //modelcom
  y=random(height*0.2,height*0.8);          //                           //modelcom

  float hueVal=random(360);
  fillCol=color(hueVal,80,100);
  strokeCol=color((hueVal+180)%360,80,80);

  // ------ Colour bucket & behaviour tweaks ------------------------ //modelcom
  if(hueVal<40||hueVal>320){          // reddish                      //modelcom
    colorBucket=0; spdX=random(-0.4,0.4); spdY=random(-0.4,0.4);      // linger
  }else if(hueVal>80&&hueVal<160){    // greenish                     //modelcom
    colorBucket=1; spdX=random(-1.2,1.2); spdY=random(-1.2,1.2);
  }else{                              // blue/other                   //modelcom
    colorBucket=2; spdX=random(-1.2,1.2); spdY=random(-1.2,1.2);
  }
  if(spdX==0&&spdY==0){ spdX=0.5; spdY=0.5; }

  squareVisible=true; fading=false; fadeSat=1; fadeAlpha=255;
  stateType=int(random(3));
  wings.clear(); connected=false; greenLocked=false;
}
