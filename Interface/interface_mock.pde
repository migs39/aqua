import controlP5.*;
import java.awt.event.KeyEvent;

ControlP5 cp5;

int myColor = color(255);

int low = 15;
int high = 80;
int critical = 95;
int manual = 0;
int open = 0;
int level = 50;
int mockDistance = 15;
String sensorReading = "";
String distance = "000";
int iDistance = 0;
int emptyDistance = 30;
int fullDistance = 0;
float percentage = .5;

Textlabel lowLabel;
Textlabel highLabel;
Textlabel criticalLabel;
Button modeButton;
Textlabel waterLevel;

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
    .setText(String.format("%02d", low))
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
    .setFont(createFont("Georgia", 32));

  cp5.addButton("change")
    .setValue(0)
    .setPosition(692, 420)
    .setSize(96, 32)
    .setColorValue(0xaa000000);

  modeButton = cp5.addButton("modeButton")
    .setValue(0)
    .setPosition(692, 100)
    .setSize(96, 32)
    .setLabel(manual == 1 ? "manual" : "auto");

  cp5.addButton("open")
    .setValue(0)
    .setPosition(692, 132)
    .setSize(48, 32);

  cp5.addButton("close")
    .setValue(0)
    .setPosition(740, 132)
    .setSize(48, 32);

  waterLevel = cp5.addTextlabel("level")
    .setText("" + level)
    .setPosition(200, 222)
    .setSize(48, 36)
    .setColor(0xff0055ff)
    .setFont(createFont("Georgia", 64));
}

void draw() {
  background(myColor);
  lowLabel.draw(this);
}

public void lowUp(){
    if (low < high){
        low++;
    }
    lowLabel
    .setText(String.format("%02d", low))
    .draw(this);
}

public void lowDown(){
    if (low > 0){
        low--;
    }
    lowLabel
    .setText(String.format("%02d", low))
    .draw(this);
}

public void highUp(){
    if (high < critical){
        high++;
    }
    highLabel
    .setText(String.format("%02d", high))
    .draw(this);
}

public void highDown(){
    if (high > low){
        high = high--;
    }
    highLabel
    .setText(String.format("%02d", high))
    .draw(this);
}

public void criticalUp(){
    if (critical < 99){
        critical++;
    }
    criticalLabel
    .setText(String.format("%02d", critical))
    .draw(this);
}

public void criticalDown(){
    if (critical > high){
        critical--;
    }
    criticalLabel
    .setText(String.format("%02d", critical))
    .draw(this);
}

public void send(){
  String lowBinary = String.format("%7s", Integer.toBinaryString(low)).replaceAll(" ", "0");
  String highBinary = String.format("%7s", Integer.toBinaryString(high)).replaceAll(" ", "0");
  String criticalBinary = String.format("%7s", Integer.toBinaryString(critical)).replaceAll(" ", "0");
  println("1"+ manual + open + lowBinary + highBinary + criticalBinary);
}

public void change(){
  send();
}

public void modeButton(){
  manual = manual == 1 ? 0 : 1;
  modeButton
    .setLabel(manual == 1 ? "manual" : "auto");
}

public void open(){
  if (manual == 1){
    open = 1;
    send();
  }
}

public void close(){
  if (manual == 1){
    open = 0;
    send();
  }
}

void keyPressed(){
  switch (key) {

    case 'q': {
      try {
          sensorReading = (String.format("%03d", mockDistance) + "#");
          if(sensorReading != null) sensorReading = trim(sensorReading);
          distance = sensorReading.substring(0,sensorReading.length()-1);  
          // converte string para inteiro
          iDistance = int(distance);
          percentage = float(emptyDistance - iDistance) / float(emptyDistance - fullDistance);
          level = round(100 * (1. - percentage));
          waterLevel.setText("" + level).draw();
      }
      catch(RuntimeException e) {
          e.printStackTrace();
      }
      break;
    }

    case 'w': {
      if (mockDistance > fullDistance) mockDistance--;
      try {
          sensorReading = (String.format("%03d", mockDistance) + "#");
          if(sensorReading != null) sensorReading = trim(sensorReading);
          distance = sensorReading.substring(0,sensorReading.length()-1);  
          // converte string para inteiro
          iDistance = int(distance);
          percentage = float(emptyDistance - iDistance) / float(emptyDistance - fullDistance);
          level = round(100 * (1. - percentage));
          waterLevel.setText("" + level).draw();
      }
      catch(RuntimeException e) {
          e.printStackTrace();
      }
      break;
    }

    case 'e': {
      if (mockDistance < emptyDistance) mockDistance++;
      try {
          sensorReading = (String.format("%03d", mockDistance) + "#");
          if(sensorReading != null) sensorReading = trim(sensorReading);
          distance = sensorReading.substring(0,sensorReading.length()-1);  
          // converte string para inteiro
          iDistance = int(distance);
          percentage = float(emptyDistance - iDistance) / float(emptyDistance - fullDistance);
          level = round(100 * (1. - percentage));
          waterLevel.setText("" + level).draw();
      }
      catch(RuntimeException e) {
          e.printStackTrace();
      }
      break;    
    }

    case 'r': {
      mockDistance = int(random(fullDistance, emptyDistance));
      try {
          sensorReading = (String.format("%03d", mockDistance) + "#");
          if(sensorReading != null) sensorReading = trim(sensorReading);
          distance = sensorReading.substring(0,sensorReading.length()-1);  
          // converte string para inteiro
          iDistance = int(distance);
          percentage = float(emptyDistance - iDistance) / float(emptyDistance - fullDistance);
          level = round(100 * (1. - percentage));
          waterLevel.setText("" + level).draw();
      }
      catch(RuntimeException e) {
          e.printStackTrace();
      }
      break;
    }
  }
}