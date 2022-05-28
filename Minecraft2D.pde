World world;
Player player;

boolean[] isPressed;

void setup(){
  size(1000, 1000);
  world = new World();
  player = new Player();
  isPressed = new boolean[5];
}

void draw(){
  background(135,206,235);
  world.display();
  player.display();
  if(!(isPressed[0] && isPressed[1])){
    if (isPressed[0]) {
      player.moveX(-0.2);
    }
    else if (isPressed[1]) {
      player.moveX(0.2);
    }
  } 

  player.run();
}

void keyPressed() {
  if (key == 'a') {
    isPressed[0] = true;
  }
  if (key == 'd') {
    isPressed[1] = true;
  }
}

void keyReleased() {
  if (key == 'a') {
    isPressed[0] = false;
  }
  if (key == 'd') {
    isPressed[1] = false;
  }
}
