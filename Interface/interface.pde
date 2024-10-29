import controlP5.*;

ControlP5 cp5;

int myColor = color(255);

int low = 15;
int high = 80;
int critical = 95;

Textlabel lowLabel;
Textlabel highLabel;
Textlabel criticalLabel;

void setup() {
  size(960,540);
  noStroke();
  cp5 = new ControlP5(this);

  cp5.addButton("lowUp")
    .setValue(0)
    .setPosition(664, 298)
    .setSize(16, 16)
    .setLabel("+");

  cp5.addButton("lowDown")
    .setValue(0)
    .setPosition(664, 368)
    .setSize(16, 16)
    .setLabel("-");

  lowLabel = cp5.addTextlabel("lowValue")
    .setText("" + low)
    .setPosition(652, 324)
    .setSize(48, 36)
    .setColor(0xffff5500)
    .setFont(createFont("Georgia",32));


  cp5.addButton("highUp")
    .setValue(0)
    .setPosition(732, 298)
    .setSize(16, 16)
    .setLabel("+");

  cp5.addButton("highDown")
    .setValue(0)
    .setPosition(732, 368)
    .setSize(16, 16)
    .setLabel("-");

  highLabel = cp5.addTextlabel("highValue")
    .setText("" + high)
    .setPosition(720, 324)
    .setSize(48, 36)
    .setColor(0xffff5500)
    .setFont(createFont("Georgia",32));


  cp5.addButton("criticalUp")
    .setValue(0)
    .setPosition(800, 298)
    .setSize(16, 16)
    .setLabel("+");

  cp5.addButton("criticalDown")
    .setValue(0)
    .setPosition(800, 368)
    .setSize(16, 16)
    .setLabel("-");

  criticalLabel = cp5.addTextlabel("criticalValue")
    .setText("" + critical)
    .setPosition(788, 324)
    .setSize(48, 36)
    .setColor(0xffff0000)
    .setFont(createFont("Georgia",32));
}

void draw() {
  background(myColor);
  lowLabel.draw(this);
}

public void lowUp(){
    if (low < high){
        low = low + 1;
    }
    lowLabel
    .setText("" + low)
    .draw(this);
}

public void lowDown(){
    if (low > 0){
        low = low - 1;
    }
    lowLabel
    .setText("" + low)
    .draw(this);
}

public void highUp(){
    if (high < critical){
        high = high + 1;
    }
    highLabel
    .setText("" + high);
}

public void highDown(){
    if (high > low){
        high = high - 1;
    }
    highLabel
    .setText("" + high)
    .draw(this);
}

public void criticalUp(){
    if (critical < 99){
        critical++;
    }
    criticalLabel
    .setText("" + critical)
    .draw(this);
}

public void criticalDown(){
    if (critical > high){
        critical--;
    }
    criticalLabel
    .setText("" + critical)
    .draw(this);
}