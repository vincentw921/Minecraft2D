DeadBlocks deadBlocks = new DeadBlocks();
World world;
Player player;
Inventory inventory;

boolean worldLoaded = false;
boolean enterPressed = false;
String saveAs = "";
Button play;

boolean[] isPressed;
boolean[] mouse;

void setup() {
  size(1000, 1000);
  int buttonw = 800;
  int buttonh = 300;
  play = new Button(width / 2 - buttonw / 2, 100, buttonw, buttonh, color(100), color(0), "Play Now!");

  if (createInput("saves/" + saveAs) == null) {
    world = new World();
    player = new Player();
    inventory = new Inventory();
    isPressed = new boolean[5];
    mouse = new boolean[2];
    return;
  }
  Table t = loadTable("saves/" + saveAs);
  world = new World();
  TableRow worldLocation = t.getRow(0);
  world.screenPos.x = worldLocation.getFloat(0);
  world.screenPos.y = worldLocation.getFloat(1);
  player = new Player();
  TableRow playerPos = t.getRow(1);
  player.pos.x = playerPos.getFloat(0);
  player.pos.y = playerPos.getFloat(1);
  TableRow btype = t.getRow(2);
  TableRow blockHealths = t.getRow(3);
  for (int i = 0; i < world.WORLD_WIDTH * world.WORLD_HEIGHT; i++) {
    if (btype.getString(i).equals("null")) {
      world.blocks[i % world.WORLD_WIDTH][i / world.WORLD_WIDTH] = null;
      continue;
    }
    world.blocks[i % world.WORLD_WIDTH][i / world.WORLD_WIDTH] = new Block(Blocks.valueOf(btype.getString(i)));
    world.blocks[i % world.WORLD_WIDTH][i / world.WORLD_WIDTH].health = blockHealths.getFloat(i);
  }
  println(world.screenPos.x, world.screenPos.y);
  inventory = new Inventory();
  TableRow toolName = t.getRow(4);
  TableRow damage = t.getRow(5);
  TableRow health = t.getRow(6);
  TableRow Btype = t.getRow(7);
  TableRow amount = t.getRow(8);

  for (int i = 0; i < inventory.rows * inventory.cols; i++) {
    if (toolName.getString(i).equals("Inven Null")) {
      continue;
    }
    if (Btype.getString(i).equals("null")) {
      inventory.inven[i % inventory.rows][i / inventory.rows] = new Item(new Tool(toolName.getString(i), health.getInt(i), damage.getInt(i)));
    } else {
      Block temp = new Block(Blocks.valueOf(Btype.getString(i)));
      inventory.inven[i % inventory.rows][i / inventory.rows] = new Item(temp, amount.getInt(i));
    }
  }
  isPressed = new boolean[5];
  mouse = new boolean[2];
}

void draw() {
  if (!worldLoaded) {
    background(0);
    play.display();
    displayTextBox(width / 2 - 800 / 2, 500);
    if (play.beenPressed || enterPressed) {
      enterPressed = false;
      if (saveAs.length() <= 0) {
        println("Please enter a valid file name");
        return;
      }
      if (!saveAs.contains(".csv")) {
        saveAs += ".csv";
      }
      worldLoaded = true;
      setup();
    }
    return;
  }
  background(135, 206, 235);
  world.display();
  deadBlocks.display(world.screenPos.x, world.screenPos.y);
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
    if (key == '\b') {
      saveAs = saveAs.substring(0, max(0, saveAs.length() - 1));
    } else if (key == '\n') {
      enterPressed = true;
    } else {
      saveAs += key;
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
  if (!worldLoaded) {
    play.checkPress(mouseX, mouseY);
    return;
  }
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

  String[] btype = new String[world.blocks[0].length * world.blocks.length];
  Float[] healths = new Float[world.blocks[0].length * world.blocks.length];
  for (int i = 0; i < world.blocks.length; i++) {
    for (int j = 0; j < world.blocks[0].length; j++) {
      if (world.blocks[i][j] == null) {
        btype[i + j * world.blocks.length] = "null";
        continue;
      }
      healths[i + j * world.blocks.length] = world.blocks[i][j].health;
      btype[i + j * world.blocks.length] = world.blocks[i][j].btype.toString();
    }
  }
  table.addRow(btype);
  table.addRow(healths);
  String[] toolName = new String[inventory.inven.length * inventory.inven[0].length];
  Integer[] damage = new Integer[inventory.inven.length * inventory.inven[0].length];
  Float[] health = new Float[inventory.inven.length * inventory.inven[0].length];
  String[] Btype = new String[inventory.inven.length * inventory.inven[0].length];
  Integer[] amount = new Integer[inventory.inven.length * inventory.inven[0].length];

  for (int i = 0; i < inventory.inven.length; i++) {
    for (int j = 0; j < inventory.inven[0].length; j++) {
      if (inventory.inven[i][j] == null) {
        toolName[i + j * inventory.inven.length] = "Inven Null";
        continue;
      }
      if (inventory.inven[i][j].tool == null) {
        health[i + j * inventory.inven.length] = inventory.inven[i][j].block.health;
        Btype[i + j * inventory.inven.length] = inventory.inven[i][j].block.btype.toString();
        amount[i + j * inventory.inven.length] = inventory.inven[i][j].amount;
        continue;
      }
      Btype[i + j * inventory.inven.length] = "null";

      toolName[i + j * inventory.inven.length] = inventory.inven[i][j].tool.name;
      health[i + j * inventory.inven.length] = Float.valueOf(inventory.inven[i][j].tool.health);
      damage[i + j * inventory.inven.length] = inventory.inven[i][j].tool.damage;
    }
  }
  table.addRow(toolName);
  table.addRow(damage);
  table.addRow(health);
  table.addRow(Btype);
  table.addRow(amount);
  saveTable(table, "saves/" + saveAs);
  dispose();
}
