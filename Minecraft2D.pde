World world;
Player player;
Inventory inventory;

boolean[] isPressed;

void setup(){
  size(1000, 1000);
  world = new World();
  player = new Player();
  inventory = new Inventory();
  isPressed = new boolean[5];
}

void draw(){
  background(135,206,235);
  world.display();
  player.display();
  if(!(isPressed[0] && isPressed[1])){
    if (isPressed[0]) {
      player.moveX(-0.01);
    }
    else if (isPressed[1]) {
      player.moveX(0.01);
    }
  }
  if (isPressed[2]) {
    inventory.display();
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
  if (key == ' ') {
    world.screenPos.y = world.screenPos.y - 1;
  }
  if (key == 's') {
    world.screenPos.y = world.screenPos.y + 1;
  }
  if (key == 'e') {
    isPressed[2] = !isPressed[2];
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
