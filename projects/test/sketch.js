let angle = 0;

function setup() {
    let canvas = createCanvas(400, 400);
    canvas.parent('sketch-container');
}

function draw() {
    background(20);
    translate(width/2, height/2);
    rotate(angle);
    
    fill(233, 69, 96); // #e94560
    rectMode(CENTER);
    rect(0, 0, 100, 100);
    
    angle += 0.02;
}

function resetSketch() {
    angle = 0;
}