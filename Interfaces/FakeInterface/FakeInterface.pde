import controlP5.*;
import java.awt.event.KeyEvent;
import java.util.LinkedList;
import java.util.Queue;

//============================ No serial config ==========
//========================================================

Queue<Integer> levels = new LinkedList<Integer>();
Queue<Integer> times = new LinkedList<Integer>();
ControlP5 cp5;

PImage img;
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
  
  //============================ No Ports Config ===========
  //========================================================
  
  background(color(200, 220, 255));

  img = loadImage("aqua.png");

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
    .setColorBackground(manual == 1 ?  color(0, 0, 150) : color(0, 0, 150))
    .setColorForeground(manual == 1 ?  color(0, 0, 200) : color(0, 0, 200))
    .setColorActive(manual == 1 ?  color(0, 0, 255) : color(0, 0, 255));

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
    .setColorBackground(manual == 1 ?  color(0, 0, 25) : color(180, 180, 180))
    .setColorForeground(manual == 1 ?  color(0, 0, 75) : color(180, 180, 180))
    .setColorActive(manual == 1 ?  color(0, 0, 125) : color(180, 180, 180))
    .setColorLabel(manual == 1 ?  color(255, 255, 255) : color(110, 110, 110));

  closeButton = cp5.addButton("close")
    .setFont(createFont("Georgia", 16))
    .setValue(0)
    .setPosition(121, 408)
    .setSize(74, 44)
    .setColorBackground(manual == 1 ?  color(0, 0, 25) : color(180, 180, 180))
    .setColorForeground(manual == 1 ?  color(0, 0, 75) : color(180, 180, 180))
    .setColorActive(manual == 1 ?  color(0, 0, 125) : color(180, 180, 180))
    .setColorLabel(manual == 1 ?  color(255, 255, 255) : color(110, 110, 110));

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
    drawAqua(671, 440, 2);
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
    .setColorBackground(manual == 1 ?  color(0, 0, 150) : color(0, 0, 150))
    .setColorForeground(manual == 1 ?  color(0, 0, 200) : color(0, 0, 200))
    .setColorActive(manual == 1 ?  color(0, 0, 255) : color(0, 0, 255));
  openButton
    .setColorBackground(manual == 1 ?  color(0, 0, 25) : color(180, 180, 180))
    .setColorForeground(manual == 1 ?  color(0, 0, 75) : color(180, 180, 180))
    .setColorActive(manual == 1 ?  color(0, 0, 125) : color(180, 180, 180))
    .setColorLabel(manual == 1 ?  color(255, 255, 255) : color(110, 110, 110));
  closeButton
    .setColorBackground(manual == 1 ?  color(0, 0, 25) : color(180, 180, 180))
    .setColorForeground(manual == 1 ?  color(0, 0, 75) : color(180, 180, 180))
    .setColorActive(manual == 1 ?  color(0, 0, 125) : color(180, 180, 180))
    .setColorLabel(manual == 1 ?  color(255, 255, 255) : color(110, 110, 110));
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

void drawAqua(int x0, int y0, int pixelSize) {
  img.loadPixels(); // Carrega os pixels da imagem
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pixelColor = img.get(x, y); // Obtém a cor do pixel
      fill(pixelColor); // Define a cor de preenchimento
      noStroke(); // Remove o contorno
      // Desenha um quadrado de pixelSize x pixelSize na posição correspondente
      rect(x0 + x * pixelSize, y0 + y * pixelSize, pixelSize, pixelSize);
    }
  }
}
//========================== graphFunctions.start ========

void plotGraph(int x0, int y0, int x, int y) {
  if (levels.size() < 2) return;  // Espera pelo menos dois pontos para desenhar
  
  // Determina os limites dos eixos
  int minTime = findMin(times);
  int maxTime = findMax(times);
  int minLevel = findMin(levels);
  int maxLevel = findMax(levels);
  
  // Define a margem e a área do gráfico
  float margin = 10; // Margem interna
  float graphWidth = x; // Largura da área do gráfico
  float graphHeight = y; // Altura da área do gráfico
  
  // Desenha os eixos
  stroke(0);
  line(x0, y0 + graphHeight, x0 + graphWidth, y0 + graphHeight);  // Eixo X
  line(x0, y0, x0, y0 + graphHeight);                               // Eixo Y
  
  // Desenha os pontos e as linhas do gráfico
  stroke(0, 0, 255);
  noFill();
  beginShape();
  int[] timeArray = toArray(times); // Converte a fila de tempos em um array
  int[] levelArray = toArray(levels); // Converte a fila de níveis em um array
  
  for (int i = 0; i < levelArray.length; i++) {
    float xPos = map(timeArray[i], minTime, maxTime, x0, x0 + graphWidth);
    float yPos = map(levelArray[i], minLevel, maxLevel, y0 + graphHeight, y0);
    vertex(xPos, yPos);  // Adiciona o ponto ao gráfico
  }
  endShape();
/**  
  // Adiciona rótulos para a escala dos eixos
  fill(0);
  textAlign(CENTER);
  text("Tempo", x0 + graphWidth / 2, y0 + graphHeight + 20); // Rótulo do eixo X
  textAlign(RIGHT);
  text("Nível", x0 - 10, y0 + graphHeight / 2);               // Rótulo do eixo Y
  
  // Mostra a escala do eixo X (tempo) nos extremos
  textAlign(CENTER);
  text(minTime, x0, y0 + graphHeight + 20);                  // Tempo mínimo
  text(maxTime, x0 + graphWidth, y0 + graphHeight + 20);    // Tempo máximo
  
  // Mostra a escala do eixo Y (nível) nos extremos
  textAlign(RIGHT);
  text(minLevel, x0 - 10, y0 + graphHeight);                 // Nível mínimo
  text(maxLevel, x0 - 10, y0);                                // Nível máximo
**/  
}


// Função para encontrar o valor mínimo em uma fila
int findMin(Queue<Integer> queue) {
  if (queue.isEmpty()) return Integer.MAX_VALUE; // Retorna o maior valor se a fila estiver vazia
  int minValue = Integer.MAX_VALUE;
  for (int level : queue) {
    if (level < minValue) {
      minValue = level;
    }
  }
  return minValue;
}

// Função para encontrar o valor máximo em uma fila
int findMax(Queue<Integer> queue) {
  if (queue.isEmpty()) return Integer.MIN_VALUE; // Retorna o menor valor se a fila estiver vazia
  int maxValue = Integer.MIN_VALUE;
  for (int level : queue) {
    if (level > maxValue) {
      maxValue = level;
    }
  }
  return maxValue;
}

// Função para converter a fila em um array
int[] toArray(Queue<Integer> queue) {
  int[] array = new int[queue.size()];
  int index = 0;
  for (int value : queue) {
    array[index++] = value;
  }
  return array;
}

//========================== graphFunctions.end ==========

//============================ Fake Serial ===============

void output(String s){
  println(s);
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
          waterLevel.setText("" + level + "%");
          if (level >= critical) waterLevel.setColor(0xffff0000);
          else if (level <= low || level >= high) waterLevel.setColor(0xffff5500);
          else waterLevel.setColor(color(0, 100, 255));

          levels.add(level);
          times.add(t);
          timeRange = t - times.peek();
          while (timeRange > maxTimeRange) {
            times.poll();
            levels.poll();
            timeRange = t - times.peek();
          }
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
          waterLevel.setText("" + level + "%");
          if (level >= critical) waterLevel.setColor(0xffff0000);
          else if (level <= low || level >= high) waterLevel.setColor(0xffff5500);
          else waterLevel.setColor(color(0, 100, 255));

          levels.add(level);
          times.add(t);
          timeRange = t - times.peek();
          while (timeRange > maxTimeRange) {
            times.poll();
            levels.poll();
            timeRange = t - times.peek();
          }
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
          waterLevel.setText("" + level + "%");
          if (level >= critical) waterLevel.setColor(0xffff0000);
          else if (level <= low || level >= high) waterLevel.setColor(0xffff5500);
          else waterLevel.setColor(color(0, 100, 255));

          levels.add(level);
          times.add(t);
          timeRange = t - times.peek();
          while (timeRange > maxTimeRange) {
            times.poll();
            levels.poll();
            timeRange = t - times.peek();
          }
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
          waterLevel.setText("" + level + "%");
          if (level >= critical) waterLevel.setColor(0xffff0000);
          else if (level <= low || level >= high) waterLevel.setColor(0xffff5500);
          else waterLevel.setColor(color(0, 100, 255));

          levels.add(level);
          times.add(t);
          timeRange = t - times.peek();
          while (timeRange > maxTimeRange) {
            times.poll();
            levels.poll();
            timeRange = t - times.peek();
          }
      }
      catch(RuntimeException e) {
          e.printStackTrace();
      }
      break;
    }
  }
}

//========================================================