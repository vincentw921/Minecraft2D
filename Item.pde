class Item {
  Block block;
  Tool tool;
  
  int amount;
  
  public Item(Block block, int amount) {
    this.block = block;
    this.amount = amount;
  }
  
  public Item(Tool tool) {
    this.tool = tool;
  }
  
  public void display(int x, int y, int size) {
    if (block == null) {
      tool.display(x,y,size);
    } else {
      block.display(x,y,size);
      text(amount, x + size - 10,y + size - 10);
    }
  }
}
