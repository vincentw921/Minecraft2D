World world;
Player player;
Inventory inventory;

String[] qwerty = {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "ENTER", "Z", "X", "C", "V", "B", "N", "M", "BACKSPACE"};
boolean worldLoaded;
String saveAs = "text";

boolean[] isPressed;
boolean[] mouse;

void setup() {
  size(1000, 1000);
  worldLoaded = false;
  try {
    Table t = new Table(new File(saveAs));
    TableRow worldLocation = t.getRow(0);
  }
  catch(IOException i) {
    println("File not found");
  }
  world = new World();
  player = new Player();
  inventory = new Inventory();

  isPressed = new boolean[5];
  mouse = new boolean[2];
}

void draw() {
  if (!worldLoaded) {
  }
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
      player.vel.set(player.vel.x, 0);
      player.vel.add(0, -0.2);
    }
  }
  if (player.hasTopBlock()) {
    player.vel.set(player.vel.x, 0);
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
  if (!worldLoaded) {
    if (key == '\n') {
    }
    return;
  }
  if (key == 'a') {
    isPressed[0] = true;
  }
  if (key == 'd') {
    isPressed[1] = true;
  }
  if (key == 'w') {
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
  if (key == 'w') {
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

void exit() {
  Table table = new Table();

  table.addRow(new Float[] {world.screenPos.x, world.screenPos.y});
  table.addRow(new Float[] {player.pos.x, player.pos.y});

  Integer[] c = new Integer[world.blocks[0].length * world.blocks.length];
  for (int i = 0; i < world.blocks.length; i++) {
    for (int j = 0; j < world.blocks[0].length; j++) {
      if (world.blocks[i][j] == null) {
        c[i + j * world.blocks.length] = -1;
        continue;
      }
      c[i + j * world.blocks.length] = world.blocks[i][j].c;
    }
  }
  table.addRow(c);
  String[] toolName = new String[inventory.inven.length * inventory.inven[0].length];
  Integer[] damage = new Integer[inventory.inven.length * inventory.inven[0].length];
  Float[] health = new Float[inventory.inven.length * inventory.inven[0].length];
  Integer[] col = new Integer[inventory.inven.length * inventory.inven[0].length];

  for (int i = 0; i < inventory.inven.length; i++) {
    for (int j = 0; j < inventory.inven[0].length; j++) {
      if (inventory.inven[i][j] == null) {
        continue;
      }
      if (inventory.inven[i][j].tool == null) {
        health[i + j * inventory.inven.length] = inventory.inven[i][j].block.health;
        col[i + j * inventory.inven.length] = inventory.inven[i][j].block.c;
        continue;
      }
      toolName[i + j * inventory.inven.length] = inventory.inven[i][j].tool.name;
      health[i + j * inventory.inven.length] = Float.valueOf(inventory.inven[i][j].tool.health);
      damage[i + j * inventory.inven.length] = inventory.inven[i][j].tool.damage;
    }
  }
  table.addRow(toolName);
  table.addRow(damage);
  table.addRow(health);
  table.addRow(col);
  saveTable(table, "saves/" + saveAs + ".csv");
  dispose();
}
