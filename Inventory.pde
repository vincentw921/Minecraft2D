class Inventory {
  final int rows = 5;
  final int cols = 6;   
  final int invenWidth = width - 300;
  final int invenHeight = 5 * invenWidth / 6;
  Block[][] inven;
  color border;
  color inside;

  Inventory(){
    border = color(150);
    inside = color(200, 200, 200, 200);
    inven = new Block[rows][cols];
  }

  public void display(){
    fill(inside);
    stroke(border);
    strokeWeight(6);
    int leftX = (width - invenWidth) / 2;
    int rightX = width - leftX;
    int topY = (height - invenHeight) / 2;
    int bottomY = height - topY;
    rect(leftX, topY, invenWidth, invenHeight, 23);

    stroke(border);
    strokeWeight(3);
    int cellWidth = (rightX - leftX) / (cols + 1);
    int cellHeight = (bottomY - topY) / (rows + 1);
    for(int r = 1; r < rows + 1; r++){
      for(int c = 1; c < cols + 1; c++){
        //vertical line
        line(leftX + c * cellWidth, topY, leftX + c * cellWidth, bottomY);
        //horizontal line
        line(leftX, topY + r * cellHeight, rightX, topY + r * cellHeight);
      }
    }
  }
    
}
