/* Grid3DAnalogs.pde
 * Cycles through analogs of geometric and organic forms: 60 panels in 4×3 grid.
 * New 3D shapes: torus, pyramid, Möbius strip. 2D analogs echo contour or shadow.
 * Random grayscale backgrounds; neon highlights on edges or vertices.
 * Auto-shift grid every 2 seconds; key press also advances.
 */
int total = 60, cols = 4, rows = 3;
PGraphics[] panels;
int offset = 0;
color[] neon = {#FF00FF, #FFFF00, #00FFFF};
float lastShift;

void settings() {
  size(1200, 900, P3D);
}
void setup() {
  panels = new PGraphics[total];
  for(int i=0;i<total;i++) panels[i]=createPanel();
  lastShift = millis();
}
void draw(){
  if(millis()-lastShift>2000){ offset=(offset+cols)%total; lastShift=millis(); }
  background(0);
  float cw = width/float(cols), ch=height/float(rows);
  for(int r=0;r<rows;r++)for(int c=0;c<cols;c++){
    int idx=(offset+r*cols+c)%total;
    image(panels[idx],c*cw,r*ch,cw,ch);
  }
}
void keyPressed(){ offset=(offset+cols)%total; }

PGraphics createPanel(){
  boolean is3D = random(1)<0.5;
  PGraphics g = is3D?createGraphics(400,300,P3D):createGraphics(400,300);
  g.beginDraw();
  int bg=int(random(50,200)); g.background(bg);
  g.noFill(); g.stroke(neon[int(random(neon.length))]); g.strokeWeight(2);
  if(is3D){
    g.lights(); g.translate(g.width/2,g.height/2,0);
    float a=millis()*0.0005;
    g.rotateY(a); g.rotateX(a*0.7);
    switch(int(random(3))){
      case 0: drawTorus(g,60,20); break;
      case 1: drawPyramid(g,100,80); break;
      case 2: drawMobius(g,80,10); break;
    }
  } else {
    // 2D analog: silhouette or cross-section
    int choice=int(random(3));
    switch(choice){
      case 0: // torus ring
        g.ellipse(g.width/2,g.height/2,150,150);
        g.ellipse(g.width/2,g.height/2,100,100);
        break;
      case 1: // pyramid silhouette
        g.beginShape();
        g.vertex(200,100); g.vertex(300,300);
        g.vertex(100,300); g.endShape(CLOSE);
        break;
      case 2: // Möbius twist curve
        for(int i=0;i<200;i++){
          float t=i*PI/100;
          float x=200+100*cos(t);
          float y=150+50*sin(t)*sin(t);
          g.point(x,y);
        }
        break;
    }
  }
  g.endDraw(); return g;
}

void drawTorus(PGraphics g,float R,float r){int u=30,v=15;
  g.beginShape(POINTS);
  for(int i=0;i<u;i++)for(int j=0;j<v;j++){
    float theta=TWO_PI*i/u, phi=TWO_PI*j/v;
    float x=(R+r*cos(phi))*cos(theta);
    float y=(R+r*cos(phi))*sin(theta);
    float z=r*sin(phi);
    g.vertex(x,y,z);
  } g.endShape();
}
void drawPyramid(PGraphics g,float base,float h){
  g.beginShape(TRIANGLES);
  // 4 faces
  float b2=base/2;
  PVector top=new PVector(0,-h/2,0);
  PVector[]corners={new PVector(-b2,h/2,-b2),new PVector(b2,h/2,-b2),new PVector(b2,h/2,b2),new PVector(-b2,h/2,b2)};
  for(int i=0;i<4;i++){
    PVector c1=corners[i],c2=corners[(i+1)%4];
    g.vertex(top.x,top.y,top.z);
    g.vertex(c1.x,c1.y,c1.z);
    g.vertex(c2.x,c2.y,c2.z);
  }
  g.endShape();
}
void drawMobius(PGraphics g,float R,float w){
  int steps=200;
  g.beginShape(LINES);
  for(int i=0;i<steps;i++){
    float t=TWO_PI*i/steps;
    float x=(R + w*cos(t/2))*cos(t);
    float y=(R + w*cos(t/2))*sin(t);
    float z=w*sin(t/2);
    g.vertex(x,y,z);
  } g.endShape();
}
