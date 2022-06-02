class DeadBlocks {
  HashMap<Block, Integer> dbs = new HashMap<Block, Integer>();

  void display(float x, float y) {
    for (Block b : dbs.keySet()) {
      if (b.x > x && b.x < x + width / SIZE
        && b.y > y && b.y < y + height / SIZE) {
          b.display(0,0);
      }
    }
  }
  
  void addBlock(Block newBlock) {
    for (Block b : dbs.keySet()) {
      if (newBlock.btype == b.btype) {
        dbs.put(b, dbs.get(b) + 1);
        return;
      }
    }
    dbs.put(newBlock, 1);
  }
}
