// Color Shift
size(800, 450);
background(50);
noStroke();
int spacing = 50;
int w = (width-spacing*2)/2;
int h = w;
color swatch = color(100, 100, 120);

//left squares
fill(255, 120, 0);
rect(spacing, spacing, w, h);
fill(swatch);
rect(spacing+w/3, spacing+h/3, w/3, h/3);

//right squares
fill(45, 140, 255);
rect(w+spacing, spacing, w, h);
fill(swatch);
rect(w+spacing+w/3, spacing+h/3, w/3, h/3);
