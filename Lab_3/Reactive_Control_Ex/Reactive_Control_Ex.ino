/*

  Forward Drive Reactive Control Example
  mshapiro 09282020

*/

// Driver definitions
// If you have a kit with the moto shield, set this to true
// If you have the Dual H-Bridge controller w/o the shield, set to false
#define SHIELD false

//SHIELD Pin varables - cannot be changed
#define motorApwm 3
#define motorAdir 12
#define motorBpwm 11
#define motorBdir 13

//Driver Pin variable - any 4 analog pins (marked with ~ on your board)
#define IN1 9
#define IN2 10
#define IN3 5
#define IN4 6

// Lab Specific definitions
// Defining these allows us to use letters in place of binary when
// controlling our motors
#define A 0
#define B 1
#define pushButton 2 // install a Pullup button with its output into Pin 2

// The available digital pin numbers will depend on your motor controller
// If Shield==true, do not use 3, 11, 12, or 13
// else, do not use the 4 pwm pins you chose for the breakout driver
#define LEFTBumper 3
#define RIGHTBumper 4

#define FORWARD  0
#define LEFT     1
#define RIGHT   -1

#define MilliSecondsPerDegree  10 // CHANGE ACCORDING TO YOUR BOT

// Function call shortcuts
#define LEFTTOUCH  (digitalRead(LEFTBumper))
#define RIGHTTOUCH (digitalRead(RIGHTBumper))
#define PushButtonState  (digitalRead(pushButton))

///////////////////////////////////////////////////////////
void setup() {
  // set up the motor drive ports
  motor_setup();
  // make the pushbutton's pins inputs, with internal pullup resistors:
  pinMode(pushButton, INPUT_PULLUP);
  pinMode(LEFTBumper, INPUT_PULLUP);
  pinMode(RIGHTBumper, INPUT_PULLUP);
  // initialize serial communication at 9600 bits per second (BAUD):
  Serial.begin(9600);
}
//////////////////////////////////////////////////////////
void loop() {
  int leftBumperState, rightBumperState;
  int i;
  long time;


  Serial.println("Waiting for a button push to start");
  while (digitalRead(pushButton) == 1); // this is an empty loop, so do nothing until you get a button push
  while (digitalRead(pushButton) == 0); // this is an empty loop, so do nothing until you release the button (most stable)
  Serial.println("Button pushed!");
  delay(1000);  // wait a second before going into the motion loop


  /*
     This code implements the basic drive forward
     with reactive control. It will drive forward
     as best as possible until the main push button
     is pressed.

     If a bumper is activated, it will turn in place
     30 degrees away from the the wall it hit.
  */


  while (PushButtonState == 1 ) { // button not pushed
    Serial.println("Forward");
    DriveForward();
    // do nothing until you hit a wall
    while ((leftBumperState = LEFTTOUCH) == 1 && (rightBumperState = RIGHTTOUCH) == 1);
    Stop();
    if (leftBumperState == 0) {   // we hit the leftBumper
      Serial.println("Left Bump!");
      turn(-30);
    }
    if (rightBumperState == 0) {   // we hit the leftBumper
      Serial.println("Right Bump!");
      turn(30);
    }
  }// end of motion loop

  Serial.println("That's All Folks!");
  delay(1000);
  exit(i);
} // the end


//////////////////////////////////////////////////////
void DriveForward() {
  run_motor(A, 125); //EDIT THESE to your motors
  run_motor(B, 125);
  return;
}
//////////////////////////////////////////////////////
void Stop() {
  run_motor(A, 0);
  run_motor(B, 0);
}
//////////////////////////////////////////////////////
int turn(int angle) {
  int sign = angle / abs(angle); //returns +1 if left, -1 if right
  long turntime = angle * MilliSecondsPerDegree;
  
  run_motor(A, -sign * 125); //left motor runs backwards for left turn
  run_motor(B, sign * 125); //right motor runs forwards for left turn
  delay(turntime);
  run_motor(A, 0);
  run_motor(B, 0);
  return (turntime);
}
