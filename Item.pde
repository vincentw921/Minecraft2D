class Item {
  Block block;
  Tool tool;

  int amount;

  public Item(Block block, int amount) {
    this.block = block;
    this.amount = amount;
  }

  public Item(Tool tool, int amount) {
    this.tool = tool;
    this.amount = amount;
  }

  public void display(int x, int y, int size) {
    if (block == null) {
      tool.display(x, y, size - 20);
      if (tool.ttype == Tools.STICK) {
        textSize(size);
        fill(0);
        text(amount, x + size / 2, y + size - 25);
      }
    } else {
      block.display(x, y, size - 20);
      textSize(size);
      fill(0);
      text(amount, x + size / 2, y + size - 25);
    }
  }

  public void regDisplay(int x, int y, int size) {
    if (block == null) {
      tool.display(x, y, size);
    } else {
      block.display(x, y, size);
      textSize(size);
      fill(0);
      text(amount, x + size / 2, y + size - 5);
    }
  }
  public String toString() {
    if (block == null && tool != null) {
      return "TOOL";
    } else if (tool == null && block != null) {
      return "BLOCK";
    }
    return "null";
  }
  //with block.btype.toString()
  //, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,
  //with BLOCK
  //, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,, null,
}
