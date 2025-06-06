// Variables to keep track of agent positions (players and AI)
PVector playerPos, wingman1Pos, wingman2Pos, moonPos;
float moonRadius = 120;  // Moon's radius, where the cheese lies
boolean biteCorrect = false;  // Is the bite at the right spot?

// Color transition for the shimmering pink Easter egg
int baseColor = color(255, 0, 255);  // Pink in RGB
int hexColor = color(0xFF00FF);      // Same pink in Hex
float colorSwitchSpeed = 0.02f;      // Speed of the color change

// FPS Randomization variables
float minFPS = 15;  // Minimum FPS (slow)
float maxFPS = 60;  // Maximum FPS (normal)
float currentFPS = 30; // Start in the middle

void setup() {
  size(800, 600);
  
  // Initial positions of the player, wingmen, and moon
  playerPos = new PVector(width / 2, height / 2 + 50);
  wingman1Pos = new PVector(width / 2 - 100, height / 2 + 50);
  wingman2Pos = new PVector(width / 2 + 100, height / 2 + 50);
  moonPos = new PVector(width / 2, height / 2);
  
  // We’ll set the camera for 3D, but we're in 2D for now
  camera(width / 2, height / 2, (height/2) / tan(PI*30.0 / 180.0), width / 2, height / 2, 0, 0, 1, 0);
  
  // Set the initial FPS
  frameRate(currentFPS);
}

void draw() {
  background(0);  // Dark sky for our moon to float in
  
  // Time to shine with Mark Twain's wisdom, right here:
  // "We should be careful what we ask for, because we might just end up with a big bite of moon-cheese."
  
  // Draw the moon
  drawMoon();

  // Randomly swap between RGB and Hex Easter egg
  shimmerPinkColor();

  // Draw the agents (players)
  drawAgent(playerPos, color(255, 0, 0));  // Red for player
  drawAgent(wingman1Pos, color(0, 255, 0));  // Green for wingman 1
  drawAgent(wingman2Pos, color(0, 0, 255));  // Blue for wingman 2
  
  // Allow the player to move with arrow keys
  moveAgent(playerPos, wingman1Pos, wingman2Pos);
  
  // Simulate the bite interaction (and if it’s correct or not)
  simulateBite();
  
  // Randomize FPS with smooth transitions
  randomizeFPS();
}

// Draw the moon
void drawMoon() {
  fill(200, 200, 255);  // Soft moon glow
  ellipse(moonPos.x, moonPos.y, moonRadius*2, moonRadius*2);  // The moon
  
  // Let's add a little moon cheese spot for fun (at the center of the moon)
  fill(255, 255, 0);
  ellipse(moonPos.x, moonPos.y, 30, 30);  // Moon-cheese spot
  
  // Maybe the cheese will wobble if the bite is wrong...
  if (!biteCorrect) {
    moonPos.x += random(-2, 2);
    moonPos.y += random(-2, 2);
  }
}

// Drawing the agents (players)
void drawAgent(PVector pos, color col) {
  fill(col);
  noStroke();
  ellipse(pos.x, pos.y, 30, 30);  // Draw player as a circle
}

// Let the player (and wingmen) move with the arrow keys
void moveAgent(PVector playerPos, PVector wingman1Pos, PVector wingman2Pos) {
  // Player movement
  if (keyPressed) {
    if (keyCode == LEFT) playerPos.x -= 5;
    if (keyCode == RIGHT) playerPos.x += 5;
    if (keyCode == UP) playerPos.y -= 5;
    if (keyCode == DOWN) playerPos.y += 5;
  }
  
  // Wingman movement (just follow the player for simplicity)
  wingman1Pos.x = playerPos.x - 100;
  wingman2Pos.x = playerPos.x + 100;
}

// Simulate the monster's bite and check if it's correct
void simulateBite() {
  // A bite is considered "correct" if the player is within 50px of the moon's center
  if (dist(playerPos.x, playerPos.y, moonPos.x, moonPos.y) < 50) {
    biteCorrect = true;
    fill(255);
    text("Correct Bite!", moonPos.x, moonPos.y - 50);
  } else {
    biteCorrect = false;
    fill(255, 0, 0);
    text("Wrong Bite!", moonPos.x, moonPos.y - 50);
  }
}

// Shimmering pink Easter egg: RGB vs Hex
void shimmerPinkColor() {
  float lerpFactor = (sin(frameCount * colorSwitchSpeed) + 1) / 2;  // Smooth oscillation
  
  // Mix between the two color formats: RGB & Hex
  int colorValue = lerpColor(baseColor, hexColor, lerpFactor);
  
  // Display the color on screen
  fill(colorValue);
  noStroke();
  rect(10, 10, 100, 100);  // Draw a small square with the shimmering color
}

// Randomize FPS smoothly for a seizure-free effect
void randomizeFPS() {
  // Randomize FPS within the constrained range (15 to 60)
  currentFPS = lerp(currentFPS, random(minFPS, maxFPS), 0.05);
  frameRate(currentFPS);  // Update the frame rate
  
  // Optional: Print out current FPS to monitor the randomness
  println("Current FPS: " + int(currentFPS));
}
