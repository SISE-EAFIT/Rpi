import processing.serial.*;

Serial port;
//Serial port2;

PrintWriter output;
int distancia1;
int distancia;
int distanciados;
int distancia2;

int auxdist;
int aux2;

int x, y , w, h, speedX, speedY;
int paddleX, paddleY, paddleW, paddleH, paddleS;
int paddleXR, paddleYR;
boolean up, down;
boolean upR, downR;

void setup(){
  port = new Serial(this, Serial.list()[0], 9600);
  //port2 = new Serial(this, Serial.list()[0], 9600); 
  
  size(500,500);

  auxdist = 0;
  aux2 = 0;

  x = width/2;
  y = height/2;
  w = 30;
  h = 30;
  speedX = 4;
  speedY = 3;
    
  rectMode(CENTER);
  paddleX = 30;
  paddleY = height/2;

  paddleXR = width-30;
  paddleYR = height/2;

  paddleW = 20;
  paddleH = 100;
  paddleS = 15;
}

void draw(){
  if(port.available() > 0){
      distancia1 = port.read();
      distancia = int(map(distancia1, 0, 90, 0, 8000));
      println(distancia); 
  }
  
//   if(port2.available() >0){
//      distanciados = port2.read();
//      distancia2 = int(map(distanciados, 0, 90, 0, 8000));
//      println(distancia2); 
//  }
    
      background(0);
      updown();
      drawCircle();
      moveCircle();
      bounceOff();

      drawPaddle();
      movePaddle();
      restrictPaddle();
      contactPaddle();   
}

void drawPaddle(){
  fill(255);
  rect(paddleX, paddleY, paddleW, paddleH);
  fill(255);
  rect(paddleXR, paddleYR, paddleW, paddleH);    
}

void movePaddle(){
 if(up){
    paddleY = paddleY - paddleS;
 } 
 if(down){
    paddleY = paddleY + paddleS;
 } 
  if(upR){
    paddleYR = paddleYR - paddleS;
 } 
 if(downR){
    paddleYR = paddleYR + paddleS;
 } 
}

void restrictPaddle(){
 if(paddleY - paddleH/2 < 0){
    paddleY = paddleY + paddleS;
 } 
  if(paddleY + paddleH/2 > height){
    paddleY = paddleY - paddleS;
 }
 
  if(paddleXR - paddleH/2 < 0){
    paddleXR = paddleXR + paddleS;
 }
 
  if(paddleXR + paddleH/2 > height){
    paddleXR = paddleXR - paddleS;
 } 
}

void contactPaddle() {
  if(x - w/2 < paddleX + paddleW/2 && y - h/2 < paddleY + paddleH/2 && y + h/2 > paddleY - paddleH/2 ){
    speedX = -speedX;
  }else if(x + w/2 > paddleXR - paddleW/2 && y - h/2 < paddleYR + paddleH/2 && y + h/2 > paddleYR - paddleH/2){
    speedX = -speedX;
  }   
}

void drawCircle(){
 fill(0,255,0);
 ellipse(x, y, w, h);  
}

void moveCircle(){
 x = x + speedX;
 y = y + speedY;
}

void bounceOff(){
  if( x > width - w/2){
     speedX = -speedX;
   }else if( x < 0 + w/2){
     speedX = -speedX;
   } 
 
  if (y > height - h/2){
    speedY = -speedY;
  } else if( y < 0 + h/2){
    speedY = -speedY;
  } 
}

void updown(){
 if(distancia > auxdist){
    up = true;
    auxdist = distancia;
 }else if(distancia < auxdist){
    down = true;
    auxdist = distancia;
 } else {
    up = false;
    down = false;
 }
 
 if(distancia2 > aux2){
    upR = true;
    aux2 = distancia2;
 }else if(distancia2 < aux2){
    downR = true;
    aux2 = distancia2;
 } else {
    upR = false;
    downR = false;
 }  
}

