public enum Crafts {
  PLANK(Blocks.WOOD, 4, Blocks.TREE),
    STICKS(Tools.STICK, 4, Blocks.WOOD, Blocks.WOOD),
    WOOD_PICKAXE(Tools.PICKAXE, Type.WOOD, new Blocks[] {Blocks.WOOD, Blocks.WOOD, Blocks.WOOD}, new Tools[] {Tools.STICK, Tools.STICK}),
    WOOD_AXE(Tools.AXE, Type.WOOD, new Blocks[] {Blocks.WOOD, Blocks.WOOD, Blocks.WOOD}, new Tools[] {Tools.STICK, Tools.STICK}),
    WOOD_SHOVEL(Tools.SHOVEL, Type.WOOD, new Blocks[] {Blocks.WOOD}, new Tools[] {Tools.STICK, Tools.STICK}),
    WOOD_SWORD(Tools.SWORD, Type.WOOD, new Blocks[] {Blocks.WOOD, Blocks.WOOD}, new Tools[] {Tools.STICK}),
    
  STONE_PICKAXE(Tools.PICKAXE, Type.STONE, new Blocks[] {Blocks.STONE, Blocks.STONE, Blocks.STONE}, new Tools[] {Tools.STICK, Tools.STICK}),
    STONE_AXE(Tools.AXE, Type.STONE, new Blocks[] {Blocks.STONE, Blocks.STONE, Blocks.STONE}, new Tools[] {Tools.STICK, Tools.STICK}),
    STONE_SHOVEL(Tools.SHOVEL, Type.STONE, new Blocks[] {Blocks.STONE}, new Tools[] {Tools.STICK, Tools.STICK}),
    STONE_SWORD(Tools.SWORD, Type.STONE, new Blocks[] {Blocks.STONE, Blocks.STONE}, new Tools[] {Tools.STICK}),
    
  IRON_PICKAXE(Tools.PICKAXE, Type.IRON, new Blocks[] {Blocks.IRON, Blocks.IRON, Blocks.IRON}, new Tools[] {Tools.STICK, Tools.STICK}),
    IRON_AXE(Tools.AXE, Type.IRON, new Blocks[] {Blocks.IRON, Blocks.IRON, Blocks.IRON}, new Tools[] {Tools.STICK, Tools.STICK}),
    IRON_SHOVEL(Tools.SHOVEL, Type.IRON, new Blocks[] {Blocks.IRON}, new Tools[] {Tools.STICK, Tools.STICK}),
    IRON_SWORD(Tools.SWORD, Type.IRON, new Blocks[] {Blocks.IRON, Blocks.IRON}, new Tools[] {Tools.STICK}),
    
  DIAMOND_PICKAXE(Tools.PICKAXE, Type.DIAMOND, new Blocks[] {Blocks.DIAMOND, Blocks.DIAMOND, Blocks.DIAMOND}, new Tools[] {Tools.STICK, Tools.STICK}),
    DIAMOND_AXE(Tools.AXE, Type.DIAMOND, new Blocks[] {Blocks.DIAMOND, Blocks.DIAMOND, Blocks.DIAMOND}, new Tools[] {Tools.STICK, Tools.STICK}),
    DIAMOND_SHOVEL(Tools.SHOVEL, Type.DIAMOND, new Blocks[] {Blocks.DIAMOND}, new Tools[] {Tools.STICK, Tools.STICK}),
    DIAMOND_SWORD(Tools.SWORD, Type.DIAMOND, new Blocks[] {Blocks.DIAMOND, Blocks.DIAMOND}, new Tools[] {Tools.STICK});

  Blocks[] blockRequirements;
  Tools[] toolRequirements;

  Blocks blockResult;
  Tools toolResult;
  Type toolType;

  int resultAmount;

  private Crafts(Blocks result, int amount, Blocks... requirements) {
    this.blockResult = result;
    this.blockRequirements = requirements;
    this.resultAmount = amount;
  }
  private Crafts(Tools result, int amount, Blocks... requirements) {
    this.toolResult = result;
    this.resultAmount = amount;
    this.blockRequirements = requirements;
  }
  private Crafts(Tools result, Type toolType, Blocks[] requirements, Tools[] toolRequirements) {
    this.toolRequirements = toolRequirements;
    this.blockRequirements = requirements;
    this.toolType = toolType;
    this.toolResult = result;
  }
}

class Crafting {
  final int CRAFTING_WIDTH = 800;
  final int CRAFTING_HEIGHT = 800;
  final int RECIPE_HEIGHT = 150;
  final PVector screenOffset = new PVector(100, 100);

  int offset;

  Crafts[] crafts = Crafts.values();

  public Crafting() {
    offset = 0;
  }

  public void display() {
    fill(200);
    int name = 50;
    rect(this.screenOffset.x, this.screenOffset.y, CRAFTING_WIDTH, CRAFTING_HEIGHT, 23);
    for (int i = 0; i < CRAFTING_HEIGHT - RECIPE_HEIGHT; i += RECIPE_HEIGHT) {
      if (offset + i / RECIPE_HEIGHT >= crafts.length || offset + i / RECIPE_HEIGHT < 0) {
        continue;
      }
      Crafts c = crafts[offset + i / RECIPE_HEIGHT];
      fill(name * i / RECIPE_HEIGHT + 50);
      noStroke();
      rect(screenOffset.x, screenOffset.y + i, CRAFTING_WIDTH, RECIPE_HEIGHT, 50);
      textSize(50);
      fill(0);
      text(c.toString(), screenOffset.x + 200, screenOffset.y + 20 + i + RECIPE_HEIGHT / 2);
      float xOff = screenOffset.x + 400;
      if (c.blockRequirements != null) {
        for (Blocks b : c.blockRequirements) {
          Block temp = new Block(b);
          temp.display(xOff, screenOffset.y + i + RECIPE_HEIGHT - 30 - RECIPE_HEIGHT / 2, 30);
          xOff += 40;
        }
      }
      if (c.toolRequirements != null) {
        for (Tools t : c.toolRequirements) {
          Tool temp = new Tool(t, Type.WOOD);
          temp.display(xOff, screenOffset.y + i + RECIPE_HEIGHT - 30 - RECIPE_HEIGHT / 2, 30);
          xOff += 40;
        }
      }
    }
  }
  public void checkRecipe() {
    if (!(mouseX > screenOffset.y && mouseX < screenOffset.y + CRAFTING_WIDTH)) {
      return;
    }
    int recipe = offset + int((mouseY - screenOffset.y) / RECIPE_HEIGHT);
    if (recipe >= crafts.length || recipe < 0) {
      return;
    }
    Crafts using = crafts[recipe];
    if (!inventory.remove(using.blockRequirements, using.toolRequirements)) {
      println("Missing Ingredient");
      return;
    }
    if (using.blockResult == null) {
      inventory.addItem(new Item(new Tool(using.toolResult, using.toolType), using.resultAmount));
    } else {
      inventory.addItem(new Item(new Block(using.blockResult), using.resultAmount));
    }
  }
}


/*
HashSet<Integer> used = new HashSet<Integer>();
 if (using.blockRequirements != null) {
 for (Blocks b : using.blockRequirements) {
 if (!inventory.contains(b)) {
 println("Missing Ingredient");
 return;
 }
 }
 }
 if (using.toolRequirements != null) {
 for (Tools t : using.toolRequirements) {
 if (!inventory.contains(t)) {
 println("Missing Ingredient");
 return;
 }
 }
 }
 */
