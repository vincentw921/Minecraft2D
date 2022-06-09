class DeadBlocks {
  HashMap<Block, Integer> dbs = new HashMap<Block, Integer>();
  
  void display() {
    for (Block b : dbs.keySet()) {
      b.decreaseY();
      if (b.x > world.screenPos.x && b.x < world.screenPos.x + width / SIZE + 1
        && b.y > world.screenPos.y && b.y < world.screenPos.y + height / SIZE + 1) {
        b.display(20);
      }
    }
  }

  void addBlock(Block newBlock) {
    println("ADDDING");
    for (Block b : dbs.keySet()) {
      if (newBlock.btype == b.btype && b.x > world.screenPos.x && b.x < world.screenPos.x + width / SIZE + 1 && b.y > world.screenPos.y && b.y < world.screenPos.y + height / SIZE + 1) {
        int temp = dbs.get(b);
        if (temp + 1 > 64) {
          break;
        }
        dbs.put(b, temp + 1);
        return;
      }
    }
    dbs.put(newBlock, 1);
  }
}
