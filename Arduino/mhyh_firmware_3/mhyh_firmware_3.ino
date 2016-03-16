#include <Adafruit_MCP4725.h>
#include <Wire.h>

//TODO: Make Voltage Accurate
//TODO: Wrap head around Units...
//TODO: Do a check to see if parameters can fit in heart beat

// SERIAL FAILED: SN/7197040


//TODO: jay for 500ohm impediance 
//TODO: sense when pacing in -> EITHER CHAMBER if it sees something between 200ms, inhibit itself on that channel 
//VA time + AV = bpm

//12 to 52 on accent, 12 on zepher... accent and above it is auto... 

// Global Contact Parameters
char handshake_bit = 'A';
bool contact = false;

//Global Running Parameters (in order of packet)
int PACKET_LENGTH = 7;
char start_bit = 's';
unsigned long bpm = 400000; //400ms
double amplitude_a = 10000;
unsigned long interval_a = 15000;
double amplitude_v = 10000;
unsigned long interval_v = 15000;

unsigned long va = 160;
unsigned long av = 840;

unsigned long av_interval = av * 1000 - 30;
unsigned long va_interval = va * 1000 - 30;



char end_bit = 'e';

//Running State
bool isRunning = false;
boolean first_print = true;

// Global DAC Helpers
unsigned long timeSinceLastBPM_us = 0;       
unsigned long timeSinceLastA_us = 0;       
unsigned long timeSinceLastV_us = 0;       
Adafruit_MCP4725 dacA;
Adafruit_MCP4725 dacV;
int DA = 0;
int DV = 1;

// Debug Pins
const int LED_PIN = 13;
int p1 = 2;
bool on1 = false;
int p2 = 3;
bool on2 = false;
int p3 = 8;
bool on3 = false;


// Setup GPIO's and Pins
void setup() {
  Serial.begin(57600);
  pinMode(p1, OUTPUT);
  pinMode(p2, OUTPUT);
  pinMode(p3, OUTPUT);
  dacA.begin(0x63);
  dacV.begin(0x62);
  initInterrupt();
}

void initInterrupt()
{
  // Initialization of interrupts for precise waveform generation
  // set timer count for 100khz (10 microsecond increments)
  cli();//stop interrupts
  TCCR1A = 0;// set entire TCCR1A register to 0
  TCCR1B = 0;// same for TCCR1B
  TCNT1  = 0;//initialize counter value to 0
  OCR1A = 19;// Approximation for 10 microSeconds.  //had to use 16 bit timer1 for this bc 1999>255, but could switch to timers 0 or 2 with larger prescaler
  //OCR1A = 1999;// = (16*10^6) / (1000*8) - 1
  TCCR1B |= (1 << WGM12);// turn on CTC mode
  TCCR1B |= (1 << CS11);  // Set CS11 bit for 8 prescaler
  TIMSK1 |= (1 << OCIE1A);// enable timer compare interrupt
  sei();//allow interrupts
}

// Interrupt at freq of about 100kHz
ISR(TIMER1_COMPA_vect) {
  timeSinceLastBPM_us      += 10;   
  timeSinceLastA_us        += 10;
  timeSinceLastV_us        += 10;
}



// Move through execution state
void loop() {

  if (on3) {
    on3 = !on3;
    digitalWrite(p3,HIGH);
  } else {
    on3 = !on3;
    digitalWrite(p3,LOW);
  }

   //checkAndDoPulse(); //Generate voltages
  VA_test();
  updateDACVoltage(0);

/*
   
   if (contact == false) { // handshake like crazy at first
     Serial.println(handshake_bit); // spam that UART line
     if (check_for_bit(handshake_bit, "HANDSHAKE")) { //handshake successful
        contact = true; 
     }
   }
   if (isRunning == false && contact == true) { 
      decode_packet(); //wait here until proper start packet is sent from processing
   } else if (isRunning == true && contact == true) { //We are ready to go!
      if (first_print == true) {
         Serial.println("arduino: RUNNING!");
         first_print = false;
      }
      checkAndDoPulse(); //Generate voltages
      updateDACVoltage(0); //Tie the DAC's down when they are not in use TODO: both dacs?
      if (check_for_bit(end_bit, "STOPPING")) { //be on the lookout for end bits
        isRunning = false;
        first_print = false;
      }  
   }
   
*/
 
}



void test_pulseEverySecond()
{
 if(timeSinceLastA_us > 1000000){
   doRampUp(20000, 20000);
   updateDACVoltage(0);
 }
 if(timeSinceLastV_us > 1000000){
   doRampUp(20000, 20000);
   updateDACVoltage(0);
 }
}

void test_simpleRampFromTimer()
{
  dacA.setVoltage(timeSinceLastA_us % 4096, false);
  dacV.setVoltage(timeSinceLastV_us % 4096, false);
}






