class Inventory {
  final int rows = 5;
  final int cols = 6;
  final int invenWidth = width - 300;
  final int invenHeight = 5 * invenWidth / 6;
  Item[][] inven;
  int[] selected;
  color border;
  color inside;
  boolean selecting;

  int leftX = (width - invenWidth) / 2;
  int rightX = width - leftX;
  int topY = (height - invenHeight) / 2;
  int bottomY = height - topY;
  int cellWidth = (rightX - leftX) / cols;
  int cellHeight = (bottomY - topY) / rows;

  public Inventory() {
    border = color(150);
    inside = color(200, 200, 200, 200);
    inven = new Item[rows][cols];
    selected = new int[2];
    //addItem(new Item(new Block(Blocks.TREE), 5));
    //inven[0][0] = new Item(new Block(Blocks.TREE), 5);
  }

  public void display() {
    fill(inside);
    stroke(border);
    strokeWeight(6);
    
    rect(leftX, topY, invenWidth, invenHeight, 23);

    stroke(border);
    strokeWeight(3);
    if(selecting){
      fill(color(50, 255, 50, 100));
      noStroke();
      //if(selected[0] == 0 && selected[1] == 0){
      rect(leftX + (selected[1]) * cellWidth, topY + (selected[0]) * cellHeight, cellWidth, cellHeight);
      //}
    }
    for (int r = 1; r < rows + 1; r++) {
      for (int c = 1; c < cols + 1; c++) {
        stroke(border);
        strokeWeight(3);
        //vertical line
        line(leftX + c * cellWidth, topY, leftX + c * cellWidth, bottomY);
        //horizontal line
        line(leftX, topY + r * cellHeight, rightX, topY + r * cellHeight);
        if (inven[r-1][c-1] == null) {
          continue;
        }
        inven[r-1][c-1].display(leftX + (c-1) * cellWidth, topY + (r-1) * cellHeight, (bottomY - topY) / rows);
      }
    }
  }

  public void addItem(Item item) {
    int curItem; 
    for (curItem = 0; curItem < inven.length * inven[0].length; curItem++) {
      if (inven[curItem / cols][curItem % cols] == null) {
        break;
      }
    }
    if (item.block == null) {
      inven[curItem / cols][curItem % cols] = item;
    } else {
      boolean hasblockalready = false;
      for (int items = 0; items < curItem; items++) {
        if (inven[items / cols][items % cols].block != null
          && inven[items / cols][items % cols].block.btype == item.block.btype) {
          hasblockalready = true;
          inven[items / cols][items % cols].amount += item.amount;
          if (inven[items / cols][items % cols].amount > 64) {
            inven[items / cols][items % cols].amount = 64;
            addItem(new Item(inven[items / cols][items % cols].block, inven[items / cols][items % cols].amount - 64));
          }
        }
      }
      if (!hasblockalready) {
        inven[curItem / cols][curItem % cols] = item;
      }
    }
  }

  public boolean isFull() {
    for (int i = 0; i < inven.length; i++) {
      for (int j = 0; j < inven[0].length; j++) {
        if (inven[i][j] == null) return false;
      }
    }
    return true;
  }

  public void remove(int pos) {
    inven[pos % cols][pos / cols] = null;
  }

  public void move(int pos, int otherPos) {
    Item temp = null;
    if (inven[otherPos % cols][otherPos / cols] != null) {
      temp = inven[otherPos % cols][otherPos / cols];
    }
    inven[otherPos % cols][otherPos / cols] = inven[pos % cols][pos / cols];
    inven[pos % cols][pos / cols] = temp;
  }
  
  public String print() {
    String s = "";
    for (int i = 0; i < inven.length * inven[0].length; i++) {
      //println(i);
      if (inven[i / cols][i % cols] == null) {
        s += ", null";
        continue;
      }
      s += ", " + inven[i / cols][i % cols].toString();
    }
    return s;
  }

  public void setSelected(int x, int y) {
    if(selecting){
      
      int[] temp = getCell(x, y);
      selecting = false;
      if(temp[0] != -1 && temp[1] != -1){
        //swap selected[0], selected[1] with cells at x, y
        Item tempItem = inven[selected[0]][selected[1]];
        inven[selected[0]][selected[1]] = inven[temp[0]][temp[1]];
        inven[temp[0]][temp[1]] = tempItem;
      } 
      selected = new int[]{-1, -1};

    } else {
      selected = getCell(x, y);
      if(selected[0] != -1 && selected[1] != -1){
        selecting = true;
      }
    }
  }
  private int[] getCell(int x, int y) {
    for(int row = 1; row <= rows; row++){
      for(int col = 1; col <= cols; col++){
        if(x < col * cellWidth + leftX && x > col * cellWidth + leftX - cellWidth && y < row * cellHeight + topY && y > row * cellHeight + topY - cellHeight){
          return new int[]{row - 1, col - 1};
        }
      }
    }
    return new int[]{-1, -1};
  }
}
