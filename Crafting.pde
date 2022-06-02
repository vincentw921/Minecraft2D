public enum Crafts {
  PLANK(Blocks.WOOD, 4, Blocks.TREE),
  STICKS(Tools.STICK, 4, Blocks.WOOD, Blocks.WOOD),
  WOOD_PICKAXE(Tools.PICKAXE, Type.WOOD, new Blocks[] {Blocks.WOOD, Blocks.WOOD, Blocks.WOOD}, new Tools[] {Tools.STICK, Tools.STICK});
  
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

class CraftingInventory {
  
}

class CraftingTable {
  
}
