color backgroundColor;
boolean prevPressed;

Calculator calculator;

void setup() {
  size(350, 500);
  textAlign(CENTER);
  textSize(30);

  backgroundColor = color(200);

  calculator = new Calculator();
  prevPressed = false;
}

void draw() {
  background(backgroundColor);
  if (!mousePressed && prevPressed) calculator.checkInput();


  calculator.display();
  prevPressed = mousePressed;
}
