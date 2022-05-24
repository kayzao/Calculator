class Calculator {
  private boolean reset;
  private float a, b;
  private char operation;
  private final int displayTextSize = 50;
  private String displayString;

  private Button[] buttons;
  private final String[] texts = {
    "A/C",
    "7", "8", "9", "/",
    "4", "5", "6", "*",
    "1", "2", "3", "-",
    "0", "<<<", "=", "+"};

  public Calculator() {
    reset = false;
    a = 0;
    b = 0;
    operation = 0;
    displayString = "0";

    buttons = new Button[texts.length];

    int padding = 5;
    int x = padding;
    int y = 150;
    int w = (width - 5 * padding) / 4;
    int h = (height - y - 6 * padding) / 5;

    for (int i = 0; i < buttons.length; i++) {
      buttons[i] = new Button(x, y, w, h, texts[i]);
      if (texts[i].equals("=")) buttons[i].setColors(buttons[i].getTextColor(), color(255, 125, 0), buttons[i].getBorderColor());
      if (texts[i].equals("A/C")) buttons[i].setColors(buttons[i].getTextColor(), color(255, 125, 0), buttons[i].getBorderColor());

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

  private void checkInput() {
    for (Button b : buttons) {
      if (b.getPressed()) {
        String input = b.getText();

        //if the pressed button is a number, just add it
        float max = Float.MAX_VALUE;
        if (input.length() == 1 && (input.charAt(0) > 47 && input.charAt(0) < 58) && a * this.b <= max / 100) {
          if (reset) {
            a = 0;
            this.b = 0;
            operation = 0;
            reset = false;
            displayString = "0";
          }
          if (operation == 0 && a < max){
            a = a * 10 + Integer.parseInt(input);
            if(displayString.equals("0")) displayString = "";
            displayString+=input;
          } else if (this.b < max){
            this.b = this.b * 10 + Integer.parseInt(input);
            if(displayString.substring(displayString.indexOf(operation) + 2) equals("0")){
              displayString = displayString.substring(displayString.indexOf(operation) + 1, displayString.length());
            } 
            displayString+=input;
          }
        } else if (input.equals("=")) { //else, if it was enter
          if (operation == 0) return;
          a = calculate(a, this.b, operation);
          this.b = 0;
          operation = 0;
          reset = true;
          displayString = ("" + a).substring(0, ("" + a).length() - 2);
        } else if (input.equals("A/C")) { //else reset
          a = 0;
          this.b = 0;
          operation = 0;
          reset = false;
          displayString = "0";
          //else if operation is given and there isn't one already
        } else if (a > 0 && this.b == 0 && (input.equals("/") || input.equals("*") || input.equals("-") || input.equals("+"))) {
          reset = false;
          operation = input.charAt(0);
          displayString += " " + operation + " ";
        } else if (b.getText().equals("<<<") && a > 0) { //else if it was backspace
          if (operation == 0) {
            if (Float.toString(a).length() <= 3) {
              a = 0;
              displayString = "0";
            } else {
              a = Float.parseFloat(Float.toString(a).substring(0, Float.toString(a).length() - 3));
              displayString = displayString.substring(0, displayString.length() - 1);
            }
          } else if (this.b == 0) {
            displayString = (a + "").substring(0, (a + "").indexOf(operation)-1);
            operation = 0;
          } else {
            if (Float.toString(this.b).length() <= 3) {
              this.b = 0;
              displayString = displayString.substring(0, displayString.indexOf(operation) + 2) + "0";
            } else {
              this.b = Float.parseFloat(Float.toString(this.b).substring(0, Float.toString(this.b).length() - 3));
              displayString = displayString.substring(0, displayString.indexOf(operation) + 2) + this.b;
            }
          }
        }
      }
    }
  }

  private float calculate(float a, float b, char operation) {
    if (operation == '/') {
      if (b != 0) return a / b;
      else return 999999999;
    } else if (operation == '*') return a * b;
    else if (operation == '-') return a - b;
    else return a + b;
  }

  public void display() {
    /*
    String str = "";
    if (a == 0) str = "0";
    else if (operation == 0) str = a + "";
    else if (b == 0) str = a + " " + operation + " 0";
    else str = a + " " + operation + " " + b;
    */
    fill(0);
    textAlign(RIGHT);
    textSize(displayTextSize);
    text(displayString, width - 20, 50);
    for (Button b : buttons) b.display();
  }
}
