import controlP5.*;
import java.awt.event.KeyEvent;

ControlP5 cp5;

int t = 0;
int low = 15;
int high = 80;
int critical = 95;
int manual = 1;
int open = 0;
int level = 50;
int mockDistance = 15;
String sensorReading = "";
String distance = "000";
int iDistance = 0;
int emptyDistance = 35;
int fullDistance = 9;
float percentage = .5;

Textlabel lowLabel;
Textlabel highLabel;
Textlabel criticalLabel;
Button modeButton;
Button openButton;
Button closeButton;
Textlabel waterLevel;

void setup() {
  
  background(color(200, 220, 255));

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
    .setColorBackground(color(0, 200, 0))
    .setColorForeground(color(50, 200, 50))
    .setColorActive(color(100, 200, 100));


  modeButton = cp5.addButton("modeButton")
    .setValue(0)
    .setPosition(692, 100)
    .setSize(96, 31)
    .setLabel(manual == 1 ? "manual" : "auto")
    .setColorBackground(manual == 1 ?  color(150, 150, 0) : color(0, 0, 150))
    .setColorForeground(manual == 1 ?  color(175, 175, 0) : color(0, 0, 200))
    .setColorActive(manual == 1 ?  color(200, 200, 0) : color(0, 0, 255));

  openButton = cp5.addButton("open")
    .setValue(0)
    .setPosition(692, 132)
    .setSize(47, 31)
    .setColorBackground(manual == 1 ?  color(50, 50, 150) : color(150, 150, 150))
    .setColorForeground(manual == 1 ?  color(50, 50, 200) : color(150, 150, 150))
    .setColorActive(manual == 1 ?  color(50, 50, 255) : color(150, 150, 150));

  closeButton = cp5.addButton("close")
    .setValue(0)
    .setPosition(741, 132)
    .setSize(47, 31)
    .setColorBackground(manual == 1 ?  color(50, 50, 150) : color(150, 150, 150))
    .setColorForeground(manual == 1 ?  color(50, 50, 200) : color(150, 150, 150))
    .setColorActive(manual == 1 ?  color(50, 50, 255) : color(150, 150, 150));

  waterLevel = cp5.addTextlabel("level")
    .setText("" + level)
    .setPosition(200, 222)
    .setSize(48, 36)
    .setColor(0xff0055ff)
    .setFont(createFont("Georgia", 64));
  

  frameRate(24);
}

public void draw() {
    t++;
    if (t == 439823) t = 0;
    drawBox(100, 100, level, t);
}

public void  drawBox(int x, int y, int level, int t){
    loadPixels();
    for (int j = 0; j <= 540; j++){
        for(int i = 0; i <= 960; i++){
            //empty box
            if((x < i) && (i <= x+5) && (y < j) && (j <= y + 310)) pixels[j*960 + i] = color(0, 0, 0);
            if((x + 335 < i) && (i <= x+340) && (y < j) && (j <= y + 310)) pixels[j*960 + i] = color(0, 0, 0);
            if((x < i) && (i <= x+340) && (y + 305 < j) && (j <= y + 310)) pixels[j*960 + i] = color(0, 0, 0);
            //light blue wave
            if((x + 5 < i) && (i <= x+335) && (float((y + 305)*100 - (level - 2)*305) - 500*sin((i+t/2)/7) <= j*100) && (j < y + 306)) pixels[j*960 + i] = color(0, 100, 255);
            if((x + 5 < i) && (i <= x+335) && (y <= j) && (j*100 < float((y + 305)*100 - (level - 2)*305) - 500*sin((i+t/2)/7)) && (j<=y+305)) pixels[j*960 + i] = color(200, 220, 255);;
        }
    }
    updatePixels();
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
        high--;
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
    .setLabel(manual == 1 ? "manual" : "auto")
    .setColorBackground(manual == 1 ?  color(150, 150, 0) : color(0, 0, 150))
    .setColorForeground(manual == 1 ?  color(200, 200, 0) : color(0, 0, 200))
    .setColorActive(manual == 1 ?  color(255, 255, 0) : color(0, 0, 255));
  openButton
    .setColorBackground(manual == 1 ?  color(50, 50, 150) : color(150, 150, 150))
    .setColorForeground(manual == 1 ?  color(50, 50, 200) : color(150, 150, 150))
    .setColorActive(manual == 1 ?  color(50, 50, 255) : color(150, 150, 150));
  closeButton
    .setColorBackground(manual == 1 ?  color(50, 50, 150) : color(150, 150, 150))
    .setColorForeground(manual == 1 ?  color(50, 50, 200) : color(150, 150, 150))
    .setColorActive(manual == 1 ?  color(50, 50, 255) : color(150, 150, 150));
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