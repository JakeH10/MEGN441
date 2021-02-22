void motor_setup() {
  if (SHIELD) { //if you're using the motoshield
    //define Sheild pins as outputs
    pinMode(motorApwm, OUTPUT); 
    pinMode(motorAdir, OUTPUT);
    pinMode(motorBpwm, OUTPUT);
    pinMode(motorBdir, OUTPUT);
    // initialize all pins to zero
    digitalWrite(motorApwm, 0);
    digitalWrite(motorAdir, 0);
    digitalWrite(motorBpwm, 0);
    digitalWrite(motorBdir, 0);
  } else { // if using dual motor driver
    // define driver pins as outputs
    pinMode(IN1, OUTPUT);
    pinMode(IN2, OUTPUT);
    pinMode(IN3, OUTPUT);
    pinMode(IN4, OUTPUT);
    // initialize all pins to zero
    digitalWrite(IN1, 0);
    digitalWrite(IN2, 0);
    digitalWrite(IN3, 0);
    digitalWrite(IN4, 0);
  } // end if 
  return;
} // end function
/*
//////////////////////////////////////////////
unsigned long Forward(int distance) {
  unsigned long t;
  t = distance * milliSecondsPerCM; //Time to keep motors on

  //To drive forward, motors go in the same direction
  run_motor(A, 255);
  run_motor(B, 255*motorRatio);
  delay(t);
  run_motor(A, 0);
  run_motor(B, 0);
  return (t);
}

//////////////////////////////////////////////
unsigned long Turn(int degrees) {
  unsigned long t;
  int sign = degrees / abs(degrees); //Find if left or right
  t = (abs(degrees) / 90) * milliSecondsPer90Deg; //Time to keep motors on

  //To turn, motors should spin in opposite directions
  run_motor(A, sign * 200);
  run_motor(B, -sign * 200 * motorRatio);
  delay(t);
  run_motor(A, 0);
  run_motor(B, 0);
  return (t);

}*/


// int motor is the defined A or B
// pwm the power cycle you want to use
void run_motor(int motor, int pwm) {
  int dir = (pwm/abs(pwm))> 0; // returns if direction is forward (1) or reverse (0)
  pwm = abs(pwm); // only positive values can be sent to the motor

  if (SHIELD) { // if using motor shield
    switch (motor) { // find which motor to controll
      case A: // if A, write A pins
        digitalWrite(motorAdir, dir); // dir is either 1 (forward) or 0 (reverse)
        analogWrite(motorApwm, pwm); 
        break; // end case A
      case B: // if B, write B pins
        digitalWrite(motorBdir, dir); // dir is either 1 (forward) or 0 (reverse)
        analogWrite(motorBpwm, pwm); // pwm is an analog value 0-255
        break; // end case A
    } // end switch statement
  } // end if
  else { // if using dual motor drivers
    switch (motor) { // find which motor to controll
      case A: // if A, write A pins
        if (dir) { // If dir is forward
          analogWrite(IN1, pwm);  // IN1 is the forward pwm pin
          digitalWrite(IN2, LOW); // IN2 is low
        } else {
          digitalWrite(IN1, LOW); // IN1 is low
          analogWrite(IN2, pwm);  // IN2 is the reverse pwm pin
        } // end if
        break; // end case A
      case B: // if B, write B pins
        if (dir) { // if dir is forward
          analogWrite(IN3, pwm);  // IN3 is the forward pwm pin
          digitalWrite(IN4, LOW); // IN4 is low
        } else {
          digitalWrite(IN3, LOW); //IN3 is low
          analogWrite(IN4, pwm);  // IN4 is the reverse pwm pin
        } // end if
        break; // end case B
    } // end switch case
  } //end if
  return;
} // end function
