
import processing.serial.*;      // comunicacao serial
import java.awt.event.KeyEvent;  // 
import java.io.IOException;

Serial myPort; // define objeto da porta serial

    String   porta = "COM27";  //acertar valor
    int   baudrate = 115200;
    float stopbits = 1.0;
    char    parity = 'N';
    int   databits = 8;

void serialEvent(){
    println(1);
}
