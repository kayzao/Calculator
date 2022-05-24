class phoneButton {
    private PImage icon;
    private int x, y, w, h;

    private Box backing;
    private int offset;

    private int rounding = 25;

    private int pressTime = 0;
    public Boolean beenPressed = false;

    Button(int x, int y, int w, int h) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      offset = w/60;
      backing = new Box(x+offset, y+offset, w, h, color(100), color(100), rounding);
    }

    Button(int x, int y, int w, int h, PImage icon) {
      this(x, y, w, h);
      formatIcon(icon);
    }

    private void formatIcon(PImage icon) {
      icon.resize(w, h);
      icon.format = ARGB;
      icon.loadPixels();
      for (int i = 0; i <= rounding; i++) {
        for (int j = 0; j <= rounding - sqrt(pow(rounding, 2)-pow(i, 2)); j++) {
          icon.pixels[(rounding - i) * w + j] = color(0, 0);
          icon.pixels[(i + (h-1) - rounding) * w + j] = color(0, 0);
          icon.pixels[(i + (h-1) - rounding) * w + (w-1) - j] = color(0, 0);
          icon.pixels[(rounding - i - 1) * w + w + (w-1) - j] = color(0, 0);
        }
      }
      icon.updatePixels();

      this.icon = icon;
    }

    public void display() {
      noStroke();
      if (pressTime == 0) {
        backing.display();
        image(icon, x, y);
        beenPressed = false;
      } else {
        image(icon, x+offset, y+offset);
        pressTime--;
        if (pressTime == 0) {
          beenPressed = true;
        }
      }
    }

    public boolean checkPress(int x, int y) {
      if (alpha(icon.get(x-this.x, y - this.y)) > 0) {
        //println(true);
        pressTime = (int) (frameRate * .1);
        return true;
      }
      return false;
    }
  }
