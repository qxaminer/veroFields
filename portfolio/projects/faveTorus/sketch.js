let angle = 0;

function setup() {
    let canvas = createCanvas(800, 600, WEBGL);
    canvas.parent('sketch-container');
    colorMode(HSB, 255);
    noStroke();
}

function draw() {
    background(0);
    lights();
    
    push();
    rotateX(angle * 0.3);
    rotateY(angle * 0.7);
    
    // Draw the torus
    let torusRadius = 120;
    let tubeRadius = 40;
    let detail = 40;
    
    for (let i = 0; i < detail; i++) {
        let phi = map(i, 0, detail, 0, TWO_PI);
        for (let j = 0; j < detail; j++) {
            let theta = map(j, 0, detail, 0, TWO_PI);
            
            let x = (torusRadius + tubeRadius * cos(theta)) * cos(phi);
            let y = (torusRadius + tubeRadius * cos(theta)) * sin(phi);
            let z = tubeRadius * sin(theta);
            
            push();
            translate(x, y, z);
            
            // Color based on position
            let hue = map(sin(theta + angle), -1, 1, 0, 255);
            fill(hue, 200, 255);
            
            sphere(3);
            pop();
        }
    }
    pop();
    
    angle += 0.02;
}

function resetSketch() {
    angle = 0;
}