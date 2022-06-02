class Button {
  private PImage icon, dicon, oicon;
  public int x, y, w, h;
  public int rounding = 10;
  public int pressTime = 0;
  public Boolean beenPressed = false;

  public String iconText = "";
  private color fill, textColor;

  public Boolean centered = true;
  public Boolean side = true;
  public int dark = 40;

  private Button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  Button(int x, int y, int w, int h, PImage icon) {
    this(x, y, w, h);
    oicon = icon;
    // dicon is a darked version of the icon, made beforehand in the constructor to increase run speed.
    dicon = createImage(w, h, ARGB);
    formatIcon(icon, true);
  }

  Button(int x, int y, int w, int h, color fill, color textColor, String text) {
    this(x, y, w, h);
    this.fill = fill;
    this.iconText = text;
    this.textColor = textColor;
    icon = createImage(w, h, ARGB);
    formatIcon(icon, false);
  }

  // Adds rounded corners to a PImage
  public void formatIcon(PImage icon, Boolean useImage) {
    dicon = createImage(w, h, ARGB);
    icon.resize(w, h);
    icon.format = ARGB;
    dicon.format = ARGB;
    icon.loadPixels();
    dicon.loadPixels();
    if (!useImage) {
      for (int i = 0; i < w*h; i++) {
        icon.pixels[i] = fill;
      }
    }
    // Basic formulas for rounded edges with a modified circle formula.
    for (int i = 0; i <= rounding; i++) {
      for (int j = 0; j <= rounding - sqrt(pow(rounding, 2)-pow(i, 2)); j++) {
        icon.pixels[(rounding - i) * w + j] = color(0, 0);
        icon.pixels[(i + (h-1) - rounding) * w + j] = color(0, 0);
        icon.pixels[(i + (h-1) - rounding) * w + (w-1) - j] = color(0, 0);
        icon.pixels[(rounding - i - 1) * w + w + (w-1) - j] = color(0, 0);
      }
    }
    // Make darker pixels for dicon
    for (int i = 0; i < w*h; i++) {
      dicon.pixels[i] = color(
        red(icon.pixels[i]) - (dark < red(icon.pixels[i]) ? dark : red(icon.pixels[i])),
        green(icon.pixels[i]) - (dark < green(icon.pixels[i]) ? dark : green(icon.pixels[i])),
        blue(icon.pixels[i]) - (dark < blue(icon.pixels[i]) ? dark : blue(icon.pixels[i])),
        alpha(icon.pixels[i])
        );
    }
    icon.updatePixels();
    dicon.updatePixels();

    this.icon = icon;
  }

  public void display() {
    noStroke();
    if (centered) {
      textAlign(CENTER);
    } else {
      if (side) {
        textAlign(LEFT);
      } else {
        textAlign(RIGHT);
      }
    }
    imageMode(CORNER);
    textSize(h/3);
    fill(textColor);
    // If the button is not pressed, don't display dicon, else, display dicon.
    if (pressTime == 0) {
      image(icon, x, y);
      beenPressed = false;
    } else {
      image(dicon, x, y);
      // Lower presstime.
      pressTime--;
      if (pressTime == 0) {
        beenPressed = true;
      }
    }

    if (centered) {
      text(iconText, x+w/2, y+h/2 + (textAscent() + textDescent())/2*.4);
    } else {
      if (side) {
        text(iconText, x+w/25, y+h/2 + (textAscent() + textDescent())/2*.4);
      } else {
        text(iconText, x+w-w/25, y+h/2 + (textAscent() + textDescent())/2*.4);
      }
    }
  }

  // To be used in mousePressed() or mouseReleased()
  // Should take in mouseX and mouseY
  public void checkPress(int x, int y) {
    if (alpha(icon.get(x-this.x, y - this.y)) > 0) {
      //println(true);
      pressTime = (int) (frameRate);
      // return true
    }
    // return false;
  }
}

class Box {
  private int x, y, w, h;
  public color fill, edge;
  public color shift;

  private int rounding;

  Box(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  Box(int x, int y, int w, int h, color fill, color edge, int rounding) {
    this(x, y, w, h);
    this.fill = fill;
    this.shift = fill;
    this.edge = edge;
    this.rounding = rounding;
  }

  // Draw a rounded box.
  public void display() {
    rectMode(CORNER);
    fill(shift);
    if (shift != fill) {
      shift = color(red(shift) + (red(fill)-red(shift)) * .15, green(shift) + (green(fill)-green(shift)) * .15, blue(shift) + (blue(fill)-blue(shift)) * .15);
      if (abs(red(fill)-red(shift)) + abs(green(fill)-green(shift)) + abs(blue(fill)-blue(shift)) < 15) {
        shift = fill;
      }
    }
    stroke(edge);
    rect(x, y, w, h, rounding);
  }
}

class TextBox {
  public int x, y, w, h;
  private Box background;
  private int textSize;

  private int placeCounter = 0;
  private int maxChar;

  private color textColor;
  private Boolean selected = false;

  public int enterLines = 0;
  public int textLines = 1;
  private float textLen = 0;

  public String text = "";
  public String preview = "";
  public int rounding = 0;
  public Boolean displayCounter = false;
  public int xBorder, yBorder;

  private int point;
  public int addedChars = 0;

  TextBox(int textSize, int x, int y, int w, int h, color inside, color border, int rounding) {
    background = new Box(x, y, w, h, inside, border, rounding);
    this.textSize = textSize;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    xBorder = w/10;
    yBorder = h/10;
  }
  TextBox(int maxChar, int textSize, int x, int y, int w, int h, color inside, color border, color textColor, int rounding) {
    this(textSize, x, y, w, h, inside, border, rounding);
    this.maxChar = maxChar;
    this.textColor = textColor;
  }

  public void display() {
    // Set info
    textSize(textSize);
    background.display();

    // Blinking cursor
    placeCounter = (int)((placeCounter + 1) % (frameRate));
    String place = placeCounter > frameRate/2 ? "" : "|";

    // Don't display cursor if not selected.
    if (!selected) {
      place = "";
    }

    // If theres no text, display the preview text or nothing.
    if (text.equals("") && !selected) {
      fill(color(red(textColor), green(textColor), blue(textColor), 100));
      text(preview, x+xBorder/2, y+yBorder/2, w-xBorder, h-yBorder);
    } else { // If there is text, display it.
      fill(textColor);
      text(text, x+xBorder/2, y+yBorder/2, w-xBorder, h-yBorder);
      // Display cursor at end of text. (This was a lot of math and testing, currently fixed: 19 Major Oddities over 12 Hours)
      // Hopefully that's all it takes.
      text(place, x+xBorder/2 + textLen, y+yBorder/2 + (textAscent() + textDescent()) * 1.275 * (textLines-1), w, h-yBorder);
    }

    // If displayCounter is true, show the total number of letters the user can use, and how many they have used.
    if (displayCounter) {
      textSize(textSize-14);
      String textCounter = (text.length() + addedChars) + "/" + maxChar;
      text(textCounter, x+w - textWidth(textCounter) - xBorder/2, y+h - yBorder/2);
    }
  }

  public void updateCursor() {
    // Updates the cursor position.
    textLines = getTextLines(text);
    textLen = getTextLength(text);
  }

  // Gets the length of the last line of the wrapped string.
  public float getTextLength(String str) {
    return getTextHelper(str, true);
  }

  // Gets the number of lines in the wrapped string.
  public int getTextLines(String str) {
    int numLines = 1;

    String[] e = str.split("\n");
    for (int i = 0; i < e.length; i++) {
      numLines += (int) getTextHelper(e[i], false);
    }
    return numLines + enterLines;
  }

  // Returns text information
  private float getTextHelper(String str, Boolean getLength) {
    // If the string ends with newLine or there is no string, textLength is equal to zero.
    if (getLength && str.endsWith("\n") || str.length() == 0) {
      return 0;
    }
    String[] e = str.split("\n");
    String[] s = e[e.length-1].split(" ");
    float currLen = 0;

    textSize(textSize);
    int numLines = 0;
    int spaceCount = 1;
    if (e[e.length-1].length() > 0 && (e[e.length-1].charAt(0) != ' ')) {
      spaceCount++;
      // Counts the number of groups of spaces to create a space array to account for them when .split() is used.
    }
    for (int i = 0; i<e[e.length-1].length(); i++) {
      // Count last group of spaces.
      if (e[e.length-1].charAt(i) == ' ' && i+1 < e[e.length-1].length() && e[e.length-1].charAt(i+1) != ' ') {
        spaceCount++;
      }
    }

    // Count the number of spaces in each group of spaces.
    int[] spaces = new int[spaceCount];
    for (int i = 0; i<spaces.length; i++) {
      spaces[i] = 0;
    }
    spaceCount = 0;
    if (e[e.length-1].length() > 0 && e[e.length-1].charAt(0) != ' ') {
      spaceCount++;
    }

    for (int i = 0; i<e[e.length-1].length(); i++) {
      if (e[e.length-1].charAt(i) == ' ') {
        spaces[spaceCount]++;
      }
      if (e[e.length-1].charAt(i) == ' ' && i+1 < e[e.length-1].length() && e[e.length-1].charAt(i+1) != ' ') {
        spaceCount++;
      }
    }

    // Debugging info.
    // println("Space Groups: " + spaceCount);
    // for(int i = 0; i<spaces.length; i++){
    //   print(spaces[i] + " ");
    // }
    // println("");

    // Add the length of the first group of spaces.
    for (int k = 0; k<spaces[0]; k++) {
      currLen += textWidth(" ");
      if (currLen > w-xBorder) {
        numLines++;
        currLen = 0;
        break;
      }
    }

    // Begin checking rest of text.
    for (int j = 1; j<spaces.length; j++) {
      // Account for .split() messing with groups of spaces.
      int upCount = 0;
      for (int k = 0; k<j; k++) {
        if (spaces[k] > 1) {
          upCount += spaces[k] -1;
        }
      }
      if (spaces[0] > 0) {
        upCount++;
      }

      // Add length of words one by one.
      float temp = currLen;
      currLen += textWidth(s[j-1 + upCount]);
      // If it's greater than what can fit, it's the next line.
      if (currLen > w-xBorder) {
        currLen = textWidth(s[j-1 + upCount]);
        numLines++;
        // If it's still greater, the word is longer than a line, and is wrapping by itself.
        if (currLen > w-xBorder) {
          if (j-1+upCount != 0) {
            float t = 0;
            for (int k = 0; k < s[j-1 + upCount].length(); k++) {
              t += textWidth(s[j-1 + upCount].charAt(k));
            }
            if (t < w-xBorder) {
              numLines--;
            }
          } else {
            numLines--;
          }
          // numLines--;
          currLen = 0;
          // Begin counting from the beginning of the word, but by letter (this is how they wrap).
          for (int k = 0; k < s[j-1 + upCount].length(); k++) {
            currLen += textWidth(s[j-1 + upCount].charAt(k));
            if (currLen > w-xBorder) {
              currLen = textWidth(s[j-1 + upCount].charAt(k));
              numLines++;
            }
          }
        }
      }

      for (int k = 0; k<spaces[j]; k++) {
        // Add length of space groups.
        currLen += textWidth(" ");
        if (currLen > w-xBorder) {
          numLines++;
          currLen = 0;
          break;
        }
      }
    }

    // Return current information.
    if (getLength) {
      return currLen;
    }
    return numLines;
  }

  public void checkKeyPress(int key) {
    textSize(textSize);
    // Don't take in key if the box isn't selected.
    if (selected) {
      // Check if it's on the keyboard and not special, as well as if the amount of text does not surpass maxChar.
      if ((key >= 32 && key <= 176) && text.length() + addedChars < maxChar) {
        // If the text cannot fit in the box, don't put it in.
        if ((getTextLines(text + (char) key)) > round((h-yBorder) / ((textAscent() + textDescent()) * 1.275))) {
          // println("first went off");
          return;
        }
        // Otherwise, add it to text.
        text += (char) key;
      }
      // Backspace function
      if (key == 8 && text.length() > 0) {
        if (text.endsWith("\n")) {
          // This is done so all of "\n" gets removed
          text = text.substring(0, text.length()-1);
          enterLines--;
        } else if (text.endsWith(" ")) {
          float temp=textLen;
          while (textLen == temp) {
            text = text.substring(0, text.length()-1);
            updateCursor();
          }
        } else {
          text = text.substring(0, text.length()-1);
        }
      }
      // Checks if enter should be allowed at a given point.
      if (key == 10  && text.length() + addedChars < maxChar && (getTextLines(text + (char) key)) + 1 <= round((h-yBorder) / ((textAscent() + textDescent()) * 1.275))) {
        text += "\n";
        enterLines++;
      }
    }
    // Update cursor position.
    updateCursor();
  }

  public void checkMousePress(int x, int y) {
    // Checks if the mouse is in the box.
    // To be used in mousePressed() or mouseReleased().
    if (x >= this.x && x <= this.x + this.w && y >= this.y && y <= this.y + this.h) {
      // setLine(x, y);
      // insertAtPoint('-');
      selected = true;
      return;
    }
    selected = false;
  }

  // Had an idea for being able to edit any part. Didn't pan out.

  // public void setLine(int mX, int mY){
  //   if(text.length() > 0){
  //     textSize(textSize);
  //     int posY = mY - y + yBorder/2;
  //     stroke(255);
  //     line(0, y + posY, width, y + posY);
  //     int mLine = round(posY / ((textAscent() + textDescent()) * 1.55));
  //     int mLength = mX - x - xBorder/2;
  //     updateCursor();
  //     for(int i = 0; i<text.length(); i++){
  //       Boolean onLine = false;
  //       if(mLine == getTextLines(text.substring(0, i))){
  //         onLine = true;
  //         Boolean noEnter = false;
  //         float temp1 = getTextLength(text.substring(0, i));
  //         float temp2 = getTextLength(text.substring(0, i + 1 < text.length() ? i+1 : text.length()));
  //         if(temp1 + (temp2-temp1)/2 > mLength){
  //           // println(text.charAt(i-1 > 0 ? i-1 : 0));
  //           point = i > 0 ? i : 0;
  //           return;
  //         }
  //       }
  //       if(onLine){
  //         point = text.length();
  //         return;
  //       }
  //     }
  //   }
  //   println(-1);
  //   point = -1;
  //   println("");
  // }

  // public void insertAtPoint(char c){
  //   if(point == -1){
  //     text = "" + c;
  //     return;
  //   }
  //   text = text.substring(0, point) + c + text.substring(point, text.length());
  // }
}
