class DeadBlocks {
  HashMap<Block, Integer> dbs = new HashMap<Block, Integer>();

  void display(float x, float y) {
    for (Block b : dbs.keySet()) {
      if (b.playerTouching(x,y,width / 50, height / 50)) {
        b.display(20);
      }
    }
  }

  void addBlock(Block newBlock, float x, float y) {
    for (Block b : dbs.keySet()) {
      if (newBlock.btype == b.btype && newBlock.x > x && newBlock.x < x + width / SIZE && newBlock.y > y && newBlock.y < y + height / SIZE) {
        dbs.put(b, dbs.get(b) + 1);
        return;
      }
    }
    dbs.put(newBlock, 1);
  }
}
