public enum Tools {
  PICKAXE("pick"),
  AXE("axe"),
  SHOVEL("shovel"),
  SWORD("sword"),
  STICK("stick");
  
  String name;
  private Tools(String name) {
    this.name = name;
  }
}

public enum Type {
  WOOD("wood", 500, 5),
  STONE("stone", 1000, 5),
  IRON("iron", 10000, 5),
  GOLD("gold", 10, 5),
  DIAMOND("diamond", 10, 5);
  
  String name;
  int damage;
  int health;
  private Type(String name, int damage, int health) {
    this.name = name;
    this.damage = damage;
    this.health = health;
  }
}

class Tool {
  final int IMAGE_SIZE = 50;
  final PVector pos = new PVector(width / 2, height / 2 + 25 + 75);;
  String name;
  
  Tools ttype;
  Type tmaterial;
  int damage;
  int health;
  PImage image;
  public Tool(Tools tool, Type material) {
    this.ttype = tool;
    tmaterial = material;
    if (material == null) {
      material = Type.WOOD;
    }
    this.name = tool.name + material.name;
    this.image = loadImage("images/" + tool.name + material.name + ".png");
    this.health = material.health;
    this.damage = material.damage;
  }
  
  public Tool(String img, int health, int damage) {
    this.name = img;
    this.image = loadImage(img);
    this.damage = damage;
    this.health = health;
  }
  
  public void display() {
    image(image, pos.x, pos.y, IMAGE_SIZE, IMAGE_SIZE);
  }
  
  public void display(float x, float y, float size) {
    image(image, x, y, size, size);
  }
}
