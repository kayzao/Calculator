class Calculator {
  private final int displayTextSize = 50;
  private final int limit;
  private color[] palette;
  
  private boolean reset;
  private float a, b;
  private char operation;
  
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
      if (texts[i].equals("=")){
        buttons[i].setColors(palette[7], palette[5], palette[5]);
      } else if (texts[i].equals("A/C")){
        buttons[i].setColors(palette[7], palette[4], palette[4]);
      } else if (texts[i].equals("/") || texts[i].equals("*") || texts[i].equals("-") || texts[i].equals("+")){
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
  
  public float getA(){
    return a;
  }
  
  public float getB(){
    return b;
  }
  
  public char getOperation(){
    return operation;
  }
  

  private void checkInput() {
    for (Button button : buttons) {
      if (button.getPressed()) {
        String input = button.getText();
        //if the pressed button is a number, just add it
        if (input.length() == 1 && (input.charAt(0) > 47 && input.charAt(0) < 58)) {
          if (reset) {
            a = 0;
            b = 0;
            operation = 0;
            reset = false;
            displayString = "0";
          }
          if (operation == 0 && a < pow(10, limit)) { //operation isn't set yet
            a = a * 10 + Integer.parseInt(input);
            if (displayString.equals("0")) displayString = "";
            displayString+=input;
          } else if (operation != 0 && b < pow(10, limit)) { //operation has been set, b may or may not be set
            b = b * 10 + Integer.parseInt(input);
            if (displayString.substring(displayString.indexOf(operation) + 2).equals("0")) {
              displayString = displayString.substring(displayString.indexOf(operation) + 1, displayString.length());
            } else displayString += Integer.parseInt(input);
          }
        } else if (input.equals("=")) { //else, if it was enter
          if (operation == 0) return;
          a = calculate(a, b, operation);
          b = 0;
          operation = 0;
          reset = true;
          if (Float.toString(a).substring(Float.toString(a).length() - 2, Float.toString(a).length()).equals(".0")) {
            displayString = ("" + a).substring(0, ("" + a).length() - 2);
          } else {
            displayString = ("" + a);
          }
        } else if (input.equals("A/C")) { //else reset
          a = 0;
          b = 0;
          operation = 0;
          reset = false;
          displayString = "0";
          //else if operation is inputted and there isn't one already
        } else if (a > 0 && b == 0 && (input.equals("/") || input.equals("*") || input.equals("-") || input.equals("+"))) {
          reset = false;
          operation = input.charAt(0);

          if (displayString.length() > 3) {
            char last = displayString.charAt(displayString.length()-2);
            if (last == '/' || last == '*' || last == '-' || last == '+') {
              displayString = displayString.substring(0, displayString.length() - 2) + input + " ";
            } else {
              displayString += " " + operation + " ";
            }
          } else {
            displayString += " " + operation + " ";
          }
        } else if (button.getText().equals("<<<") && displayString.length() > 0) { //else if it was backspace
          if (operation == 0) {
            a = Float.parseFloat(Float.toString(a).substring(0, Float.toString(a).length() - 1));
            displayString = displayString.substring(0, displayString.length() - 1);
          } else if (b == 0) {
            displayString = (a + "").substring(0, displayString.indexOf(operation)-1);
            operation = 0;
          } else {
            if (Float.toString(b).length() <= 3) {
              b = 0;
              displayString = displayString.substring(0, displayString.indexOf(operation) + 2) + "0";
            } else {
              b = Float.parseFloat(Float.toString(b).substring(0, Float.toString(b).length() - 3));
              displayString = displayString.substring(0, displayString.indexOf(operation) + 2) + b;
            }
          }
        }
      }
    }
  }

  private float calculate(float a, float b, char operation) {
    //println("a: " + a + " b: " + b);
    if (operation == '/') {
      if (b != 0) return a / b;
      else return 999999999;
    } else if (operation == '*') return a * b;
    else if (operation == '-') return a - b;
    else return a + b;
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
    text(displayString, width - 20, 50);
    for (Button b : buttons) b.display();
  }
}
