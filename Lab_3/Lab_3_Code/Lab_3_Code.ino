// Include Libraries
#include <PinChangeInt.h>

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
#define pushButton 12 // install a Pullup button with its output into Pin 12
/* If you'd like to use additional buttons as bump sensors, define their pins 
 *  as descriptive names, such as bumperLeft etc. 
 */

// Drive constants - dependent on robot configuration
#define EncoderCountsPerRev 12.0
#define DistancePerRev      257.6 // mm per rev
#define DegreesPerRev       (98.4/0.85)  // degrees per revoluation

//These are to build your moves array, a la Lab 2
#define FORWARD             (304.8*1.65) // mm
#define LEFT                1
#define RIGHT              -1

// Motor Direction / Bias Fix
#define LeftMotorBias  0.98
#define RightMotorBias -1.0

// these next two are the digital pins we'll use for the encoders
// You may change these as you see fit.
#define EncoderMotorLeft  8
#define EncoderMotorRight 2

// Lab specific variables
volatile unsigned int leftEncoderCount = 0;
volatile unsigned int rightEncoderCount = 0;
int moves[] = { 
                FORWARD*2,  RIGHT,
                FORWARD,  RIGHT,
                FORWARD*2,  LEFT, 
                FORWARD*2,  LEFT,
                FORWARD
              };

// PID Control Struct, Default values are for Motor Control
struct PIDControl {
  // Gains
  float kp = 60;
  float ki = 0;
  float kd = 0;
  
  // Internal Variables
  int error_sum = 0;
  int deadband = 50;  // Minimum pwm
  int distTolerance = 0;  // Number of accepteable encoder counts from target

  // Input Variable
  int target;
  int error;

  // Output Variable
  int ret;
};

// Ziegler–Nichols method
// Left, Right, and Sync Motor Control Initialization
struct PIDControl leftControl, rightControl;


void setup() {
  // set stuff up
  Serial.begin(9600);
  Serial.println(moves[0]);
  motor_setup();
  pinMode(pushButton, INPUT_PULLUP);

  // PID Control
  leftControl.deadband = 47;
  rightControl.deadband = 59;

  // Attaching Wheel Encoder Interrupts
  Serial.print("Encoder Testing Program ");
  Serial.print("Now setting up the Left Encoder: Pin ");
  Serial.print(EncoderMotorLeft);
  Serial.println();
  pinMode(EncoderMotorLeft, INPUT); //set the pin to input
  digitalWrite(EncoderMotorLeft, HIGH); //use the internal pullup resistor
  PCintPort::attachInterrupt(EncoderMotorLeft, indexLeftEncoderCount, RISING); // attach a PinChange Interrupt to our pin on the rising edge
  // (RISING, FALLING and CHANGE all work with this library)
  
  /////////////////////////////////////////////////
  Serial.print("Now setting up the Right Encoder: Pin ");
  Serial.print(EncoderMotorRight);
  Serial.println();
  pinMode(EncoderMotorRight, INPUT);     //set the pin to input
  digitalWrite(EncoderMotorRight, HIGH); //use the internal pullup resistor
  PCintPort::attachInterrupt(EncoderMotorRight, indexRightEncoderCount, RISING); // attach a PinChange Interrupt to our pin on the rising edge

} /////////////// end of setup ////////////////////////////////////

/////////////////////// loop() ////////////////////////////////////
void loop()
{
  while (digitalRead(pushButton) == 1); // wait for button push
  while (digitalRead(pushButton) == 0); // wait for button release
  
  // Find Parameters -COMMENT AFTER VALUES ARE FOUND
  // findDeadband();
  //                   delay(1000);
  //findMotorBias();
  
  for (int i = 0; i < sizeof(moves)/2; i++) { // Loop through entire moves list
    //Serial.println(i);
    if(moves[i]==LEFT){
      turn(90);
      //Serial.print("LEFT ");
    }
    else if(moves[i]==RIGHT){
      turn(-90);
      //Serial.println("RIGHT ");
    }
    else{
      drive(moves[i]);
      //Serial.println("Forward");
    }
  }

}
//////////////////////////////// end of loop() /////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
void drive(float distance)
{

  int countsDesired;
  
  // Find the number of encoder counts based on the distance given, and the 
  // configuration of your encoders and wheels
  countsDesired = distance * EncoderCountsPerRev / DistancePerRev;

  leftControl.target = countsDesired;
  rightControl.target = countsDesired;

  // reset the current encoder counts
  leftEncoderCount = 0;
  rightEncoderCount = 0;

  // we make the errors greater than our tolerance so our first test gets us into the loop
  leftControl.error = leftControl.distTolerance + 1;
  rightControl.error =  rightControl.distTolerance + 1;

  // Begin PID control until move is complete
  while (leftControl.error > leftControl.distTolerance || rightControl.error > rightControl.distTolerance)
  {
    // according to the PID formula, what should the current PWMs be?
    leftControl = motorControl(leftControl);
    rightControl = motorControl(rightControl);

    // Debug
    //Serial.print(leftEncoderCount);
    //Serial.print("\t");
    //Serial.println(rightEncoderCount);
    
    // Set new PWMs
    run_motor(A, RightMotorBias * rightControl.ret);
    run_motor(B, LeftMotorBias * leftControl.ret);

    // Update encoder error
    leftControl.error = countsDesired - leftEncoderCount;
    rightControl.error = countsDesired - rightEncoderCount;

    delay(1);
    
  }
}

void turn(int degrees) {
  int countsDesired;
  int sign = degrees / abs(degrees); //Find if left or right
  countsDesired = abs(degrees) / DegreesPerRev * EncoderCountsPerRev;

  leftControl.target = countsDesired;
  rightControl.target = countsDesired;

  // reset the current encoder counts
  leftEncoderCount = 0;
  rightEncoderCount = 0;

  // we make the errors greater than our tolerance so our first test gets us into the loop
  leftControl.error = leftControl.distTolerance + 1;
  rightControl.error =  rightControl.distTolerance + 1;

  // Begin PID control until move is complete
  while (leftControl.error > leftControl.distTolerance || rightControl.error > rightControl.distTolerance)
  {
    // according to the PID formula, what should the current PWMs be?
    leftControl = motorControl(leftControl);
    rightControl = motorControl(rightControl);

    // Debug
    
    // Set new PWMs
    run_motor(B, -sign * LeftMotorBias * leftControl.ret);
    run_motor(A, sign * RightMotorBias * rightControl.ret);

    // Update encoder error
    leftControl.error = countsDesired - leftEncoderCount;
    rightControl.error = countsDesired - rightEncoderCount;

    delay(1);

  }
  
}

struct PIDControl motorControl(struct PIDControl control)
//  gain, deadband, and error, both are integer values
{
  if (control.error <= control.distTolerance) { // if error is acceptable, PWM = 0
    control.ret = 0;
    return control;
  }

  control.ret = (control.kp * control.error + control.ki * control.error_sum); // Proportional control
  control.error_sum += control.ret;
  
  control.ret = constrain(control.ret, control.deadband, 255); // Bind value between motor's min and max
  
  return control;
}

void findDeadband() {
  
  int i = 30;
  
  leftEncoderCount = 0;
  rightEncoderCount = 0;
  
  while(rightEncoderCount == 0) {
    i++;
    run_motor(A, i);
    run_motor(B, i);
    Serial.print(leftEncoderCount);
    Serial.print("\t");
    Serial.println(rightEncoderCount);
    delay(10);
  }

  run_motor(A, 0);
  
  Serial.print("Right Motor Deadband: ");
  Serial.println(i);

  i = 30;

  while(leftEncoderCount == 0) {
    i++;
    run_motor(B, i);
    Serial.print(leftEncoderCount);
    Serial.print("\t");
    Serial.println(rightEncoderCount);
    delay(10);
  }

  run_motor(B, 0);
  
  Serial.print("Left Motor Deadband: ");
  Serial.println(i);
}

void findMotorBias() {

  int t = 5000;

  leftEncoderCount = 0;
  rightEncoderCount = 0;
  
  run_motor(A, RightMotorBias * 255);
  run_motor(B, LeftMotorBias * 255);

  delay(t);

  run_motor(A, 0);
  run_motor(B, 0);

  Serial.println("Right (A) \t Left (B)");
  
  Serial.print(leftEncoderCount);
  Serial.print("\t");
  Serial.println(rightEncoderCount);

  Serial.print(leftEncoderCount / leftEncoderCount);
  Serial.print("\t");
  Serial.println(rightEncoderCount / leftEncoderCount);
  
  Serial.print(leftEncoderCount / rightEncoderCount);
  Serial.print("\t");
  Serial.println(rightEncoderCount / rightEncoderCount);
}

//////////////////////////////////////////////////////////

// These are the encoder interupt funcitons, they should NOT be edited

void indexLeftEncoderCount()
{
  leftEncoderCount++;
}
//////////////////////////////////////////////////////////
void indexRightEncoderCount()
{
  rightEncoderCount++;
}
