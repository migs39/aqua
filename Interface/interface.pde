import controlP5.*;
import java.awt.event.KeyEvent;
import java.util.LinkedList;
import java.util.Queue;

//=============================== Serial config ==========

import processing.serial.*;      // comunicacao serial
import java.awt.event.KeyEvent;  // 
import java.io.IOException;

Serial myPortIn; // define objeto da porta serial

    String   porta = "COM19";  //acertar valor
    int   baudrate = 115200;
    float stopbits = 1.0;

    char    parityIn = 'O';
    int   databitsIn = 7;

    char    parityOut = 'N';
    int   databitsOut = 8;

//========================================================

Queue<Integer> levels = new LinkedList<Integer>();
Queue<Integer> times = new LinkedList<Integer>();
ControlP5 cp5;

int maxTimeRange = 14400;
int timeRange;
int t = 0;
int low = 15;
int high = 80;
int critical = 95;
int showLow = low;
int showHigh = high;
int showCritical = critical;
int manual = 1;
int open = 0;
int level = 50;
int mockDistance = 22;
String sensorReading = "";
String distance = "000";
int iDistance = 0;
int emptyDistance = 35;
int fullDistance = 9;
float percentage = .5;

Textlabel lowLabel;
Textlabel highLabel;
Textlabel criticalLabel;
Textlabel lowTitle;
Textlabel highTitle;
Textlabel criticalTitle;
Textlabel valveControl;
Button modeButton;
Button openButton;
Button closeButton;
Textlabel waterLevel;
Textlabel aqua;

void setup() {
  
  //============================ Ports Config ==============

  myPortIn = new Serial(this, porta, baudrate, parityIn, databitsIn, stopbits); 
  myPortIn.bufferUntil('#'); 

  myPortOut = new Serial(this, porta, baudrate, parityOut, databitsOut, stopbits); 

  //================================== Config ==============

  
  background(color(200, 220, 255));

  size(960,540);
  noStroke();
  cp5 = new ControlP5(this);

  cp5.addButton("lowUp")
    .setValue(0)
    .setPosition(254, 384)
    .setSize(16, 16)
    .setLabel("+");

  cp5.addButton("lowDown")
    .setValue(0)
    .setPosition(236, 384)
    .setSize(16, 16)
    .setLabel("-");

  lowLabel = cp5.addTextlabel("lowValue")
    .setText(String.format("%02d", showLow))
    .setPosition(232, 336)
    .setSize(48, 36)
    .setColor(0xffff5500)
    .setFont(createFont("Georgia",32));

  lowTitle = cp5.addTextlabel("lowTitle")
    .setText("Low")
    .setPosition(226, 300)
    .setSize(48, 36)
    .setColor(0x00000000)
    .setFont(createFont("Georgia", 24));

  cp5.addButton("highUp")
    .setValue(0)
    .setPosition(322, 384)
    .setSize(16, 16)
    .setLabel("+");

  cp5.addButton("highDown")
    .setValue(0)
    .setPosition(304, 384)
    .setSize(16, 16)
    .setLabel("-");

  highLabel = cp5.addTextlabel("highValue")
    .setText("" + showHigh)
    .setPosition(300, 336)
    .setSize(48, 36)
    .setColor(0xffff5500)
    .setFont(createFont("Georgia",32));

  highTitle = cp5.addTextlabel("highTitle")
    .setText("High")
    .setPosition(292, 300)
    .setSize(48, 36)
    .setColor(0x00000000)
    .setFont(createFont("Georgia", 24));

  cp5.addButton("criticalUp")
    .setValue(0)
    .setPosition(390, 384)
    .setSize(16, 16)
    .setLabel("+");

  cp5.addButton("criticalDown")
    .setValue(0)
    .setPosition(372, 384)
    .setSize(16, 16)
    .setLabel("-");

  criticalLabel = cp5.addTextlabel("criticalValue")
    .setText("" + showCritical)
    .setPosition(368, 336)
    .setSize(48, 36)
    .setColor(0xffff0000)
    .setFont(createFont("Georgia", 32));
  
  criticalTitle = cp5.addTextlabel("cricriticalTitle")
    .setText("Crit")
    .setPosition(366, 300)
    .setSize(48, 36)
    .setColor(0x00000000)
    .setFont(createFont("Georgia", 24));

  cp5.addButton("change")
    .setFont(createFont("Georgia", 16))
    .setValue(0)
    .setPosition(244, 420)
    .setSize(75, 32)
    .setColorBackground(color(0, 200, 0))
    .setColorForeground(color(50, 200, 50))
    .setColorActive(color(100, 200, 100));

  cp5.addButton("cancel")
    .setFont(createFont("Georgia", 16))
    .setValue(0)
    .setPosition(321, 420)
    .setSize(75, 32)
    .setColorBackground(color(200, 0, 0))
    .setColorForeground(color(200, 50, 50))
    .setColorActive(color(200, 100, 100));

  modeButton = cp5.addButton("modeButton")
    .setFont(createFont("Georgia", 16))
    .setValue(0)
    .setPosition(45, 362)
    .setSize(150, 44)
    .setLabel(manual == 1 ? "manual" : "auto")
    .setColorBackground(manual == 1 ?  color(150, 150, 0) : color(0, 0, 150))
    .setColorForeground(manual == 1 ?  color(175, 175, 0) : color(0, 0, 200))
    .setColorActive(manual == 1 ?  color(200, 200, 0) : color(0, 0, 255));

  valveControl = cp5.addTextlabel("valveControl")
    .setText("  Valve \nControl")
    .setPosition(60, 300)
    .setSize(48, 36)
    .setColor(0x00000000)
    .setFont(createFont("Georgia", 32));

  openButton = cp5.addButton("open")
    .setFont(createFont("Georgia", 16))
    .setValue(0)
    .setPosition(45, 408)
    .setSize(74, 44)
    .setColorBackground(manual == 1 ?  color(50, 50, 150) : color(100, 100, 100))
    .setColorForeground(manual == 1 ?  color(50, 50, 200) : color(100, 100, 100))
    .setColorActive(manual == 1 ?  color(50, 50, 255) : color(100, 100, 100));

  closeButton = cp5.addButton("close")
    .setFont(createFont("Georgia", 16))
    .setValue(0)
    .setPosition(121, 408)
    .setSize(74, 44)
    .setColorBackground(manual == 1 ?  color(50, 50, 150) : color(100, 100, 100))
    .setColorForeground(manual == 1 ?  color(50, 50, 200) : color(100, 100, 100))
    .setColorActive(manual == 1 ?  color(50, 50, 255) : color(100, 100, 100));

  waterLevel = cp5.addTextlabel("level")
    .setText("" + level + "%")
    .setPosition(810, 222)
    .setSize(48, 36)
    .setFont(createFont("Georgia", 64));
  if (level >= critical) waterLevel.setColor(0xffff0000);
  else if (level <= low || level >= high) waterLevel.setColor(0xffff5500);
  else waterLevel.setColor(color(0, 100, 255));

  aqua = cp5.addTextlabel("AQUA")
    .setText("AQUA")
    .setPosition(730, 450)
    .setFont(createFont("Georgia", 72))
    .setColor(color(0, 150, 255));

  
  frameRate(24);
}

public void draw() {
  background(200, 220, 255);
    t++;
    if (t >= 2073600) t = 0;
    drawBox(465, 110, level, t);
    //plotGraph(50, 50, 300, 200);
}

public void  drawBox(int x, int y, int level, int t){
    loadPixels();
    for (int j = 0; j <= 540; j++){
        for(int i = 0; i <= 960; i++){
            //empty box
            if((x < i) && (i <= x+5) && (y < j) && (j <= y + 310)) pixels[j*960 + i] = color(0, 0, 0);
            if((x + 335 < i) && (i <= x+340) && (y < j) && (j <= y + 310)) pixels[j*960 + i] = color(0, 0, 0);
            if((x < i) && (i <= x+340) && (y + 305 < j) && (j <= y + 310)) pixels[j*960 + i] = color(0, 0, 0);
            //dark blue wave
            if((x + 5 < i) && (i <= x+335) && (float((y + 305)*100 - (level - 2)*305) - 500*sin((i-t/4)/7) <= j*100) && (j < y + 306)) pixels[j*960 + i] = color(0, 50, 127);            
            //light blue wave
            if((x + 5 < i) && (i <= x+335) && (float((y + 305)*100 - (level - 2)*305) - 500*sin((i+t/2)/7) <= j*100) && (j < y + 306)) pixels[j*960 + i] = color(0, 100, 255);
        }
    }
    updatePixels();
}

public void lowUp(){
    if (showLow < showHigh){
        showLow++;
    }
    lowLabel
    .setText(String.format("%02d", showLow))
    .draw(this);
}

public void lowDown(){
    if (showLow > 0){
        showLow--;
    }
    lowLabel
    .setText(String.format("%02d", showLow))
    .draw(this);
}

public void highUp(){
    if (showHigh < showCritical){
        showHigh++;
    }
    highLabel
    .setText(String.format("%02d", showHigh))
    .draw(this);
}

public void highDown(){
    if (showHigh > showLow){
        showHigh--;
    }
    highLabel
    .setText(String.format("%02d", showHigh))
    .draw(this);
}

public void criticalUp(){
    if (showCritical < 99){
        showCritical++;
    }
    criticalLabel
    .setText(String.format("%02d", showCritical))
    .draw(this);
}

public void criticalDown(){
    if (showCritical > showHigh){
        showCritical--;
    }
    criticalLabel
    .setText(String.format("%02d", showCritical))
    .draw(this);
}

public void send(String type, int value){
  String message = "";
  switch (type){
    case "low":{
      message += "00";
      break;
    }
    case "high":{
      message += "01";
      break;
    }
    case "crit":{
      message += "10";
      break;
    }
    case "mode":{
      message += "11";
      switch (value){
        case 0:{ //auto
          message += "000000";
          break;
        }
        case 1:{ //manual + close
          message += "100000";
          break;
        }
        case 2:{ //manual + open
          message += "110000";
          break;
        }
      }
      output(message);
      return;
    }
    default:
      return;
  }
  value = emptyDistance - int(float(emptyDistance - fullDistance) * (float(value) / 100.0));
  message += String.format("%6s", Integer.toBinaryString(value)).replaceAll(" ", "0");
  output(message);
}

public void change(){
  if (low != showLow) send("low", showLow);
  if (high != showHigh) send("high", showHigh);
  if (critical != showCritical) send("crit", showCritical);

  low = showLow;
  high = showHigh;
  critical = showCritical;
  if (level >= critical) waterLevel.setColor(0xffff0000);
  else if (level <= low || level >= high) waterLevel.setColor(0xffff5500);
  else waterLevel.setColor(color(0, 100, 255));
}

public void cancel(){
  showLow = low;
  showHigh = high;
  showCritical = critical;
  lowLabel.setText(String.format("%02d", showLow));
  highLabel.setText(String.format("%02d", showHigh));
  criticalLabel.setText(String.format("%02d", showCritical));
}

public void modeButton(){
  manual = manual == 1 ? 0 : 1;
  if (manual == 0) send("mode", 0);
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

public void close(){
  if (manual == 1){
    open = 0;
    send("mode", 1);
  }
}

public void open(){
  if (manual == 1){
    open = 1;
    send("mode", 2);
  }
}

//========================== No Grapph Function ==========
//========================================================

//============================ Serial ====================

void output(String s) {
  myPortOut.write(Integer.parseInt(binary, 2));
}

void serialEvent (Serial myPortIn) { 
    try {
        // leitura da porta serial até o caractere '#' na variavel sensorReading
        sensorReading = myPortIn.readStringUntil('#');
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
}
//========================================================