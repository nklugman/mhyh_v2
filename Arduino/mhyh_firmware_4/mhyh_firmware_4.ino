#include <Adafruit_MCP4725.h>
#include <Wire.h>

Adafruit_MCP4725 vRefDac;
#define DATAOUT 11//MOSI
#define DATAIN 12//MISO - not used, but part of builtin SPI
#define SPICLOCK  13//sck
#define SLAVESELECT0 10//ss

unsigned long timeSinceLastBPM_us = 0;       
unsigned long timeSinceLastA_us = 0;       
unsigned long timeSinceLastV_us = 0;  

int i = 0;

//Running State
bool isRunning = false;
boolean first_print = true;
int PACKET_LENGTH = 7;
char start_bit = 's';
unsigned long bpm = 400000; //400ms
double amplitude_a = 4095;
unsigned long interval_a = 15000;
double amplitude_v = 4095;
unsigned long interval_v = 15000;
unsigned long av_interval = 80000;
unsigned long va_interval = 200000;

void setup() {
  // put your setup code here, to run once:
  vRefDac.begin(0x62);
   SPI_setup();
  Serial.begin(9600);
}

void loop() {
 vRefDac.setVoltage(50, false); 

/*
 i++;
 Serial.println(i);
 write_note(i);
 if(i>=4096) {
  i=0; 
 }
*/
 VA_test();
 write_note(0);
  //test_pulseEverySecond();
}

void write_note(int i) {
  write_valueY(i);
  write_valueX(i);
}

void SPI_setup(){

  byte clr;
  pinMode(DATAOUT, OUTPUT);
  pinMode(SPICLOCK,OUTPUT);
  pinMode(SLAVESELECT0,OUTPUT);
  digitalWrite(SLAVESELECT0,HIGH); //disable device
  initInterrupt();

  SPCR = (1<<SPE)|(1<<MSTR) | (0<<SPR1) | (0<<SPR0);
  clr=SPSR;
  clr=SPDR;
  delay(10);
}

// write out through DAC A
void write_valueX(int sample)
{
  byte dacSPI0 = 0;
  byte dacSPI1 = 0;
  dacSPI0 = (sample >> 8) & 0x00FF; //byte0 = takes bit 15 - 12
  dacSPI0 |= (1 << 7);    // A/B: DACa or DACb - Forces 7th bit  of    x to be 1. all other bits left alone.
  dacSPI0 |= 0x10;
  dacSPI1 = sample & 0x00FF; //byte1 = takes bit 11 - 0
  dacSPI0 |= (1<<5);  // set gain of 1
  digitalWrite(SLAVESELECT0,LOW);
  SPDR = dacSPI0;        // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  SPDR = dacSPI1;
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  digitalWrite(SLAVESELECT0,HIGH);
}

// write out through DAC B
void write_valueY(int sample)
{
  // splits int sample in to two bytes
  byte dacSPI0 = 0;
  byte dacSPI1 = 0;
  dacSPI0 = (sample >> 8) & 0x00FF; //byte0 = takes bit 15 - 12
  dacSPI0 |= 0x10;
  
  dacSPI1 = sample & 0x00FF; //byte1 = takes bit 11 - 0
  dacSPI0 |= (1<<5);  // set gain of 1
  
  digitalWrite(SLAVESELECT0,LOW);
  SPDR = dacSPI0;       // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  SPDR = dacSPI1;
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  digitalWrite(SLAVESELECT0,HIGH);
}

void test_pulseEverySecond()
{
 if(timeSinceLastA_us > 1000000){
   doRampUp(1000, 200000);
   write_valueX(0);
 }
 if(timeSinceLastV_us > 1000000){
   doRampUp(1000, 200000);
   write_valueY(0);
 }
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


