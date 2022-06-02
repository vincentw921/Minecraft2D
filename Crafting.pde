public enum Crafts {
  STICKS(Tools.STICK, Blocks.TREE, Blocks.TREE);
  
  Blocks[] blockRequirements;
  Tools[] toolRequirements;
  Blocks blockResult;
  Tools toolResult;
  private Crafts(Blocks result, Blocks... requirements) {
    this.blockResult = result;
    this.blockRequirements = requirements;
  }
  private Crafts(Tools result, Blocks... requirements) {
    this.toolResult = result;
    this.blockRequirements = requirements;
  }
  private Crafts(Tools result, Blocks[] requirements, Tools[] toolRequirements) {
    this.toolRequirements = toolRequirements;
    this.blockRequirements = requirements;
    this.toolResult = result;
  }
}

class CraftingInventory {
  
}

class CraftingTable {
  
}
