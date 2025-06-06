int gameMode = 0;  // 0 = 1st person, 1 = 2nd person, 2 = 3rd person
boolean gameOn = true;  // For the randomized 3rd person mode

// Player agents
Agent player, wingman1, wingman2, AI;

void setup() {
  size(800, 600, P3D);
  // Initialize the player agents
  player = new Agent("Player", new PVector(0, 120, 0));
  wingman1 = new Agent("Wingman 1", new PVector(100, 120, 0));
  wingman2 = new Agent("Wingman 2", new PVector(-100, 120, 0));
  AI = new Agent("AI", new PVector(0, 120, 200));

  // Switch to the initial game mode
  gameMode = 0;
}

void draw() {
  background(0);
  lights();
  translate(width / 2, height / 2, 0);
  
  // Game Mode Control
  if (gameMode == 0) {
    firstPersonMode();
  } else if (gameMode == 1) {
    secondPersonMode();
  } else if (gameMode == 2 && gameOn) {
    thirdPersonMode();
  }
}

void firstPersonMode() {
  // Player is the main agent, with 2 wingmen as support
  player.updatePosition();
  wingman1.updatePosition();
  wingman2.updatePosition();
  player.interactWithMoon();
  wingman1.interactWithMoon();
  wingman2.interactWithMoon();
  
  // Draw agents and their interactions
  player.draw();
  wingman1.draw();
  wingman2.draw();
}

void secondPersonMode() {
  // Two real-life players (IRL) vs. the AI model agent
  // In this mode, player and AI can interact differently
  player.updatePosition();
  AI.updatePosition();
  player.interactWithMoon();
  AI.interactWithMoon();
  
  // Draw agents
  player.draw();
  AI.draw();
}

void thirdPersonMode() {
  // Randomized mode with boolean "gameOn" controlling it
  if (gameOn) {
    // Game happens here
    AI.randomizedAction();
    wingman1.randomizedAction();
    wingman2.randomizedAction();
    player.randomizedAction();
    
    // Draw agents
    player.draw();
    AI.draw();
    wingman1.draw();
    wingman2.draw();
  }
}

class Agent {
  String name;
  PVector position;
  float biteSize;
  boolean correctBite;
  
  Agent(String name, PVector position) {
    this.name = name;
    this.position = position;
    this.biteSize = random(10, 50);  // Random bite size
    this.correctBite = false;
  }

  void updatePosition() {
    // Here you can map the agent's movement based on player input
    // Example: player can use the arrow keys or WASD to move agents
    if (keyPressed) {
      if (key == 'w') position.z += 2; // Move forward
      if (key == 's') position.z -= 2; // Move backward
      if (key == 'a') position.x -= 2; // Move left
      if (key == 'd') position.x += 2; // Move right
    }
  }

  void interactWithMoon() {
    // Agent's interaction with the moon-cheese and the moon’s mass
    float massImpact = biteSize * 0.1; // Impact on mass based on bite size
    if (position.z < 100) { // Assuming 100 is the "correct spot" to bite
      correctBite = true;
    } else {
      correctBite = false;
    }
  }

  void draw() {
    // Draw the agent (for simplicity, just a sphere here)
    pushMatrix();
    translate(position.x, position.y, position.z);
    fill(255, 0, 0);  // Red for player
    sphere(20);
    popMatrix();
    
    // Display info
    fill(255);
    text(name + " Bite Size: " + biteSize, position.x, position.y + 20);
  }
  
  void randomizedAction() {
    // Random actions for 3rd-person mode, based on the `gameOn` state
    if (random(1) > 0.5) {
      position.x += random(-2, 2); // Small random movement
      position.z += random(-2, 2);
    }
  }
}

void keyPressed() {
  // Switch modes based on key press
  if (key == '1') {
    gameMode = 0;  // First-person mode
  } else if (key == '2') {
    gameMode = 1;  // Second-person mode
  } else if (key == '3') {
    gameMode = 2;  // Third-person mode
  }
  
  // Toggle game on/off for the 3rd-person mode
  if (key == 't') {
    gameOn = !gameOn;
  }
}
