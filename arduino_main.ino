/* car_control_monitor
  main arduino code
*/

#include <dht11.h>

dht11 DHT;

#define ir_sensor A0
#define voltage_pin A1
#define mq2 A2
#define DHT11_PIN A3
#define relay_main  10  //if latched ON line closed
#define relay_aux 11
#define closed  LOW
#define opened HIGH

const float battery_critic = 12.30;
const float ir_critic = 261.00;
/*
  const int crit_temp = 33;   //dht 11 temperature comparison variable              //// when using arduino with raspberry pi disable this instructions // for staand alone ,enbale
  const int crit_hum = 100; //dht11 hum **
*/
const int ondelay = 5000;// initial delay after car online cut-off *** CHANGE THIS TO 5 MIN =60*1000*5; In real-time application
const float multiplier = 0.014255487;     ///multiplier is caliberation value ..
int temp;     //current read value though dht11
int hum;    //current * * **
int ir_count = 0;     // storing the number of intercepting of ir(human presence)(encounter)
unsigned long int _delay_count = 5000;    //initial value setted up for more delay at the startup then  assigns millis(); value after each period
bool HU_stat = HIGH;  //IR signal read and above threshold count if this count is above 0(setted up) assumes human presence if presence HU_stat is HIGH
String received = "";     //for receiving string through serial from raspberry
String Stemp = "temp";    //Stemp _ S variable for storing strings inorder to match the receiving commands through uart
String Shum = "hum";
String Sir = "ir";
String Svoltage = "voltage";
String Smq2 = "mq2";
String relay_status;    /// values --closed--opened   info about relay status
void setup() {
  Serial.begin(9600);
  pinMode(relay_main, OUTPUT);
  // pinMode(relay_aux, OUTPUT);
  pinMode(ir_sensor, INPUT_PULLUP); //works analog pin ,sensor should connected with ground ,internal pull-up provided

  digitalWrite(relay_main, closed);
  relay_status = "closed";
}

void loop()
{

  float value1 = analogRead(voltage_pin);
  value1 = value1 * multiplier;                     ///multiplier is caliberation value ..
  //  Serial.print("voltage : ");
  //  Serial.println(value1);

  float value2 = analogRead(mq2);                 //value2 gives smoke/alcohol reading
  //  Serial.print("smoke/alcohol signal : ");
  //  Serial.println(value2);

  float value3 = analogRead(ir_sensor);           // value3 for detecting human presence make sure the sensor is not too far  it senses signal approx 5cm distant
  // value3 = 1024 - value3;
  //  Serial.print("ir signal : ");
  //  Serial.println(value3);

  int chk = DHT.read(DHT11_PIN);

  if (chk == DHTLIB_OK) {         ///if no error dht11 read values temp and hum (error check)
    temp = DHT.temperature;
    hum = DHT.humidity;
    //  Serial.print("Temperature : ");
    //  Serial.println(temp);
    //  Serial.print("Humidity : ");
    //  Serial.println(hum);
  }
  /*
    if (temp > crit_temp) {                                               //// when using arduino with raspberry pi disable this instructions // for staand alone ,enbale
    Serial.println("TEMPERATURE RISING ..!");  ///dht11

    }
    if (hum > crit_hum) {
    Serial.println("HUMIDITY RISING ..!");   ///dht11

    }
  */
  //  Serial.println("");

  if (millis() < _delay_count + ondelay) {
    if (ir_critic < value3)
      ir_count += 1;

    //   Serial.println("_delay_count + ondelay running..");
    //   Serial.println(ir_count);
  }

  else {
    HU_stat = (ir_count <= 0) ? LOW : HIGH;
    _delay_count = millis();
 //   Serial.println("time just finished ");                //don't care debugging purpose
 //   Serial.println(ir_count);


     if (battery_critic > value1 || !HU_stat ) {

       digitalWrite(relay_main, opened);
       relay_status = "opened";
     }

    ir_count = 0;
  }

  //if no serial available executing above code only


  if (!Serial.available())
    return;

  received = Serial.readString();

  if (received == Stemp) {
    Serial.print(temp);
  }
  else if (received == Shum) {
    Serial.print(hum);
  }
  else if (received == Svoltage) {
    Serial.print(value1);
  }
  else if (received == Smq2) {
    Serial.print(value2);
  }
  else if (received == Stemp) {
    Serial.print(temp);
  }
  else if (received == Sir) {
    Serial.print(value3);
  }
  else if (received == String("status")) {
    Serial.print(relay_status);
  }
  else {
    Serial.println(received);
    Serial.println("ir:voltage:temp:hum:mq2");
  }
//  Serial.flush();
//  Serial.println("");
}