#include <Dynamixel2Arduino.h>

#define dxlSerial Serial1
#define debugSerial Serial
const int dxlDirPin=-1; //setting the direction control pin for communication to -1 to tell library that openrb automatically switches pin
const float dxlProtocol=2.0;
const int dxl_ID1=1;
const int dxl_ID2=2;
Dynamixel2Arduino dxl(dxlSerial, dxlDirPin); //initialize dxl object 
using namespace ControlTableItem; //so you can set operating modes
int pos=2000;

void setup() { 
debugSerial.begin(115200); //initialize serial moniter
dxl.begin(57600); //match baud rate w motor
dxl.setPortProtocolVersion(2.0);
if (dxl.ping(dxl_ID1)){
  debugSerial.println("motor found"); 
  }
else {
  debugSerial.println("motor not found");
}
dxl.torqueOff(dxl_ID1);
dxl.setOperatingMode(dxl_ID1, OP_VELOCITY);
dxl.torqueOn(dxl_ID1);

dxl.torqueOff(dxl_ID2);
dxl.setOperatingMode(dxl_ID2, OP_VELOCITY);
dxl.torqueOn(dxl_ID2);

}

void loop() {

  //dxl.setGoalPosition(dxl_ID1, pos-500);
  //delay(1000);
  //pos=dxl.getPresentPosition(dxl_ID1);
  //Serial.println(pos);
  
  if (Serial.available() > 0){
    char key = Serial.read();
    //Serial.println("I got a ");
    //Serial.println(key, DEC);

    if (key == 'w'){
      Serial.println("down");
      dxl.setGoalVelocity(dxl_ID1, -300);
      delay(1000);
    }
    else if (key == 's'){
      Serial.println("up");
      dxl.setGoalVelocity(dxl_ID1, 300);
      delay(1000);
    }
    else{
      dxl.setGoalVelocity(dxl_ID1, 0);
    }


  }
  //dxl.setGoalVelocity(dxl_ID1, -300);
  //delay(2000);
  //dxl.setGoalVelocity(dxl_ID1, 0);
  //delay(2000);

}
