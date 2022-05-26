class Calculator {
  private final int displayTextSize = 50;
  private final int limit;
  private color[] palette;

  private boolean reset;
  private String a, b;
  private char operation;

  private Button[] buttons;
  private final String[] texts = {
    "A/C",
    "7", "8", "9", "/",
    "4", "5", "6", "*",
    "1", "2", "3", "-",
    "0", "<<<", "=", "+"};

  public Calculator() {
    reset = false;
    a = "0";
    b = "0";
    operation = 0;
    limit = 10;

    /* 0 = keypad background color
     * 1 = answer background color
     * 2 = number button color
     * 3 = function color
     * 4 = A/C color
     * 5 = equal sign color
     * 6 = main text color (number text, answer text)
     * 7 = secondary text color (functions, A/C)
     */
    palette = new color[8];
    palette[0] = #1B1B1E;
    palette[1] = #30323C;
    palette[2] = #22232A;
    palette[3] = #A3ABC0;
    palette[4] = #FFD5FF;
    palette[5] = #D8E1FF;
    palette[6] = #D2D1D5;
    palette[7] = #070D20;

    buttons = new Button[texts.length];

    int padding = 7;
    int x = padding;
    int y = 150;
    int w = (width - 5 * padding) / 4;
    int h = (height - y - 6 * padding) / 5;

    for (int i = 0; i < buttons.length; i++) {
      buttons[i] = new Button(x, y, w, h, texts[i]);
      if (texts[i].equals("=")) {
        buttons[i].setColors(palette[7], palette[5], palette[5]);
      } else if (texts[i].equals("A/C")) {
        buttons[i].setColors(palette[7], palette[4], palette[4]);
      } else if (texts[i].equals("/") || texts[i].equals("*") || texts[i].equals("-") || texts[i].equals("+")) {
        buttons[i].setColors(palette[7], palette[3], palette[3]);
      } else {
        buttons[i].setColors(palette[6], palette[2], palette[2]);
      }
      if (i == 0) { //move to next row after /
        x = padding;
        y += h + padding;
      } else {
        if (i % 4 == 0) { //new row
          x = padding;
          y += h + padding;
        } else {
          x += w + padding; //next column
        }
      }
    }
  }

  public String getA() {
    return a;
  }

  public String getB() {
    return b;
  }

  public char getOperation() {
    return operation;
  }

  private String displayString() {
    if (a.length() > 2) {
      if (a.indexOf(".0") == a.length()-2) {
        a = a.substring(0, a.length()-2);
      }
    }

    if (a.equals("Infinity")) {
      a = "ERROR";
      reset = true;
      return "ERROR";
    } else if (operation == 0) {
      return a;
    } else if (b.equals("0")) {
      return a + " " + operation + " ";
    } else {
      return a + " " + operation + " " + b;
    }
  }

  private void reset() {
    a = "0";
    b = "0";
    operation = 0;
    reset = false;
  }

  void checkInput() {
    /* PLAN:
     * Keep track of the two inputted numbers as Strings
     * To calculate, just convert the strings to floats, and then do math
     */
    for (Button button : buttons) {
      if (button.getPressed()) {
        String input = button.getText();
        if (reset) reset();
        //If input is number
        if (input.length() == 1 && (input.charAt(0) > 47 && input.charAt(0) < 58)) {
          if (operation == 0 && a.length() < limit) { //if a is being edited
            if (a.equals("0")) a = "";
            a += input;
          } else if (operation != 0 && b.length() < limit) { //else, b is being edited
            if (b.equals("0")) b = "";
            b += input;
          }
        } else if (input.equals("A/C")) {
          reset();
        } else if (input.equals("/") || input.equals("*") || input.equals("-") || input.equals("+")) {
          if (a.equals("0")) return;
          operation = input.charAt(0);
        } else if (input.equals("<<<")) {
          if (operation == 0) {
            if (a.length() > 1) {
              a = a.substring(0, a.length() - 1);
            } else {
              a = "0";
            }
          } else if (b.equals("0")) {
            operation = 0;
          } else {
            if (b.length() > 1) {
              b = b.substring(0, b.length() - 1);
            } else {
              b = "0";
            }
          }
        } else if (input.equals("=")) {
          if (operation == 0 || b.equals("0")) return;
          if (b.equals("0") && operation == 0) { //if divide by 0 error
            a = "Infinity";
          } else {
            a = str(calculate(float(a), float(b), operation));
          }
          b = "0";
          operation = 0;
        }
      }
    }
  }

  float calculate(float a, float b, char operation) {
    if (operation == '/') {
      return a / b;
    } else if (operation == '*') {
      return a * b;
    } else if (operation == '-') {
      return a - b;
    } else {
      return a + b;
    }
  }

  public void display() {
    //background of keypad
    fill(palette[0]);
    noStroke();
    rect(0, 0, width, height);

    //background of answer
    fill(palette[1]);
    rect(0, -height / 2, width, height / 2 + 130, 20);

    //print answers + buttons
    fill(palette[6]);
    textAlign(RIGHT);
    textSize(displayTextSize);
    text(displayString(), width - 20, 50);
    for (Button b : buttons) b.display();
  }
}
