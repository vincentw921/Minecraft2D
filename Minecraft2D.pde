World world;
Player player;
Inventory inventory;

boolean[] isPressed;
boolean[] mouse;

void setup() {
  size(1000, 1000);
  world = new World();
  player = new Player();
  inventory = new Inventory();

  isPressed = new boolean[5];
  mouse = new boolean[2];
}

void draw() {
  background(135, 206, 235);
  world.display();
  player.display();
  if (!(isPressed[0] && isPressed[1])) {
    if (isPressed[0] && player.notHasLeft()) {
      player.moveX(-0.01);
    } else if (isPressed[1] && player.notHasRight()) {
      player.moveX(0.01);
    }
  }
  if (isPressed[3]) {
    if (player.hasGround()) {
      player.vel.add(0, -0.2);
    }
  }
  if (isPressed[2]) {
    inventory.display();
  }

  if (mouse[0]) {
    world.checkHit();
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
    isPressed[3] = true;
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
  if (key == ' ') {
    isPressed[3] = false;
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    mouse[0] = true;
  }
  if (mouseButton == RIGHT) {
    mouse[1] = true;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    mouse[0] = false;
  }
  if (mouseButton == RIGHT) {
    mouse[1] = false;
  }
}
