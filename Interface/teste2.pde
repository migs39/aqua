
int t = 0;
void setup() {
  size(960,540);
  noStroke();
  background(color(255, 0, 0));
  loadPixels();
  updatePixels();
  frameRate(24);
}

public void draw() {
    t++;
    if (t == 439823) t = 0;
    drawBox(100, 100, 50, t);
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
            if((x + 5 < i) && (i <= x+335) && (float((y + 305)*100 - (level - 2)*305) - 500*sin((i+t/2)/7) <= j*100) && (j < y + 306)) pixels[j*960 + i] = color(100, 100, 255);
            if((x + 5 < i) && (i <= x+335) && (y <= j) && (j*100 < float((y + 305)*100 - (level - 2)*305) - 500*sin((i+t/2)/7))) pixels[j*960 + i] = color(255, 255, 255);
        }
    }
    updatePixels();
}