class Button {
  private int x, y, w, h;
  private String text;
  private color textColor, fillColor, borderColor;
  private boolean pressed;
  private final int buttonTextSize = 30;
  private final int r = 10;

  Button(int x, int y, int w, int h, String text) {
    this(x, y, w, h, text, color(255), color(150, 210, 255), color(50, 75, 90));
  }

  Button(int x, int y, int w, int h, String text, color textColor, color fillColor, color borderColor) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.textColor = textColor;
    this.fillColor = fillColor;
    this.borderColor = borderColor;
    pressed = false;
  }

  public color getTextColor() {
    return textColor;
  }
  public color getFillColor() {
    return fillColor;
  }
  public color getBorderColor() {
    return borderColor;
  }
  public boolean getPressed() {
    return pressed;
  }
  public String getText() {
    return text;
  }

  public void setColors(color textColor, color fillColor, color borderColor) {
    this.textColor = textColor;
    this.fillColor = fillColor;
    this.borderColor = borderColor;
  }

  public void display() {
    fill(fillColor);
    stroke(borderColor);
    rect(x, y, w, h, r);
    if (mousePressed && mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      pressed = true;
      fill(255, 255, 255, 50);
      rect(x, y, w, h, r);
    } else {
      pressed = false;
    }

    fill(textColor);
    textSize(buttonTextSize);
    textAlign(CENTER);
    text(text, x + w/2, y + h/2);
  }
}
