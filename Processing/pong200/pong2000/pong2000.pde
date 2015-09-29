// Arduino Processing Pong

// Based on Processing Pong by Tom Igoe

// This example is in the public domain.

import processing.serial.*;              // import the Serial library
import java.awt.Rectangle;               // import Java's Rectangle class

Serial myPort;        // The serial port

Rectangle leftPaddle, rightPaddle;       // Rectangles for the paddles

int paddleHeight = 50;            // vertical dimension of the paddles
int paddleWidth = 10;             // horizontal dimension of the paddles

int ballSize = 10;     // the size of the ball
int xDirection = 2;    // the ball's horizontal direction. left is –2, right is 2.
int yDirection = 2;    // the ball's vertical direction. up is –2, down is 2.
int xPos, yPos;        // the ball's horizontal and vertical positions

int leftScore = 0;      // score for left player
int rightScore = 0;     // score for right player

int fontSize = 20;      // size of the fonts on the screen

void setup() {

  size(640, 480);       // set the size of the applet window

  // initialize the paddles:
  leftPaddle = new Rectangle(50, height/2, paddleWidth, paddleHeight);
  rightPaddle = new Rectangle(width-50, height/2, paddleWidth, paddleHeight);
 
  noStroke(); // no borders on drawn shapes
  fill(255);  // drawn shapes are white

  resetBall();

  // create a font with the third font available to the system:
  PFont myFont = createFont(PFont.list()[2], fontSize);
  textFont(myFont);
    
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
}

void draw() {
  // clear the screen:
  background(0);

  // draw the paddles:
  rect(leftPaddle.x, leftPaddle.y, leftPaddle.width, leftPaddle.height);
  rect(rightPaddle.x, rightPaddle.y, rightPaddle.width, rightPaddle.height);

  // calculate the ball's position and draw it
  animateBall();

  // print the scores
  text(leftScore, fontSize, fontSize);
  text(rightScore, width-fontSize, fontSize);
}

// serialEvent  method is run automatically whenever the buffer 
// reaches the byte value set by bufferUntil():
void serialEvent(Serial thisPort) { 

  // read the serial buffer:
  String inputString = thisPort.readStringUntil('\n');

  if (inputString != null)
  {
    // trim the carrige return and linefeed from the input string:
    inputString = trim(inputString);

    // split the input string at the commas
    // and convert the sections into integers:
    int sensors[] = int(split(inputString, ','));

    // if we have received all the sensor values, use them:
    if (sensors.length == 2) {
      // scale the sliders' results to the paddles' range:
      leftPaddle.y = int(map(sensors[0], 0, 1023, 0, height - leftPaddle.height));
      rightPaddle.y = int(map(sensors[1], 0, 1023, 0, height - rightPaddle.height));
    }
  }
}

void animateBall() {
  if (leftPaddle.contains(xPos, yPos) ||    // if the ball pos is inside the left paddle
  rightPaddle.contains(xPos, yPos)) {       // or the ball pos is inside the right paddle
    xDirection = -xDirection;               // reverse the ball's X direction
  }

  // if the ball goes off the screen left:
  if (xPos < 0) 
  {     
    rightScore++;     
    resetBall();   
  }   // if the ball goes off the screen right:   
  if (xPos > width) 
  {
    leftScore++;
    resetBall();
  }
  // stop the ball going off the top or the bottom of the screen:
  if ((yPos <= 0) || (yPos >=height)) {
    // reverse the y direction of the ball:
    yDirection = -yDirection;
  }
  // update the ball position:
  xPos = xPos + xDirection;
  yPos = yPos + yDirection;

  // Draw the ball:
  rect(xPos, yPos, ballSize, ballSize);
}

void resetBall()
{
  // initialize the ball in the center of the screen:
  xPos = width/2;
  yPos = height/2;
}