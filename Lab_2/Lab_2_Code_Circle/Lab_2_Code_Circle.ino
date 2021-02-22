
/* Dead Reckoning
  20200117
  Program to get the ardbot to drive a predefined path
  jsteele, mshapiro, klarsen
*/

// Complete Tasks in Initial_Robot_Testing.ino first!!

/* Program TODO LIST
  1) Change the milliSecondsPerCM constant to the value you found in testing
  2) Change the milliSecondsPer90Deg constant to the value you found in testing
  3) Change the PWM of the forward function to the values you found in testing
  4) Write code for the button pause functionality
  5) Write your own turn function

  Note: type // to make a single line comment
        Comments are for the future you to understand how you wrote your code
*/

#define SHIELD false


// Preprocessor Definitions
#define FORWARD  0
#define LEFT     1
#define RIGHT   -1
#define pushButton 12
#define A        1
#define B        2
#define pwmA    3
#define dirA    12
#define pwmB    11
#define dirB    13

//SHIELD Pin varables
#define motorApwm 3
#define motorAdir 12
#define motorBpwm 11
#define motorBdir 13

//Driver Pin variable
#define IN1 9
#define IN2 10
#define IN3 5
#define IN4 6

// the following converts centimeters into milliseconds as long datatype
#define milliSecondsPerCM  35 //CHANGE THIS ACCORDING TO YOUR BOT
#define milliSecondsPer90Deg 371 //371 //CHANGE THIS ACCORDNING TO YOUR BOT

// the itemized list of moves for the robot as a 1D array
// this setup assumes that all the turns are 90 degrees and that all motions are pairs of drives and turns.
int moves[] = {140, LEFT, 90, RIGHT, 60, RIGHT, 180, RIGHT, 100, LEFT, 60, RIGHT, 100, RIGHT, 150, RIGHT};

void setup() {
  // set up the motor drive ports
  pinMode(pwmA, OUTPUT);
  pinMode(dirA, OUTPUT);
  pinMode(pwmB, OUTPUT);
  pinMode(dirB, OUTPUT);
  // make the pushbutton's pin an input:
  pinMode(pushButton, INPUT_PULLUP); //CHANGE TO INPUT_PULLUP
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

void loop() {
  int i, dist, dir;
  long time;
  while (digitalRead(pushButton) == 1);
  while (digitalRead(pushButton) == 0);
  //This for loop steps (or iterates) through the array 'moves'
  for (i = 0; i < 4; i++) {

    while (digitalRead(pushButton) == 1);

    Arc(-120);
    Arc(60);
    Arc(60);
    Arc(-120);

  } // end of for loop

} // the end

//////////////////////////////////////////////
unsigned long Arc(int dia) {
  unsigned long t;
  float scale;
  t = milliSecondsPerCM * abs(dia) * 3.14 / 2;
  int sign = dia / abs(dia); //Find if left or right

  if (abs(dia) == 120) scale = 0.75;
  else scale = 0.48;
  
  if (sign == 1) {
    run_motor(A, 200 * scale); //change PWM to your calibrations
    run_motor(B, 200); //change PWM to your calibrations
  } else {
    run_motor(A, 200); //change PWM to your calibrations
    run_motor(B, 200 * scale); //change PWM to your calibrations
  }

  //To turn, motors should spin in opposite directions

  delay(t);
  run_motor(A, 0);
  run_motor(B, 0);
  return (t);

}
