double amp = 0;
long width = 0;
int DAC = 0;
long rampUpTime;
long rampDownTime;
unsigned long startTime_us;
bool has_beat_v = false;

float maxOutVoltage_mV = 30.00;// Measured at a scope with 950 Ohms between V_in and V_out, and 68 Ohms between V_out and ground.
float maxDACVoltage_mV = 5000.0;
float voltageFactor = 178.57;// The scope reading differ from the calculations.  Using mean scope readings over 200 samples.

int last_a_debug = 0;
int last_v_debug = 0;
int last_b_debug = 0;
int DA = 0;
int DV = 1;

// BPM
// A
// AV INTERVAL
// V
// BPM

//A 
//AV INTERVAL
//V
//VA INTERVAL
//A

//A WIDTH + AV INTERVAL + V WIDTH + VA INTERVAL = BPM 



bool has_beat_a = false;

void VA_test() {
  unsigned long v_start = interval_a+av_interval;
  unsigned long a_restart = v_start+interval_v+va_interval;

  if (timeSinceLastA_us >= a_restart && has_beat_a == false) {
    timeSinceLastA_us = 0;
    doSquare(DA); //busy loop for interval_a
    has_beat_a = true;
  }
  if (has_beat_a == true && timeSinceLastA_us >= v_start) {
    doSquare(DV); //busy loop for interval_v
    has_beat_a = false;
  }
}

// Top level PC69 Generator Function
void doPC69(int cur_DAC) { 
  //on2 = !on2;
  //digitalWrite(p2, on2);  
  DAC = cur_DAC;
  if (cur_DAC == DA) {
     amp = amplitude_a;
     width = interval_a; 
  } else {
     amp = amplitude_v;
     width = interval_v;    
  }
  //rampUpTime = width;
  rampDownTime = 2000;
  rampUpTime = 13000;
  //rampDownTime = (2 * width) / 15;
  //rampUpTime = (13 * width) / 15;
  //Serial.print("rampDownTime: ");
  //Serial.println(String(rampDownTime));
  //Serial.print("rampUpTime: ");
  //Serial.println(String(rampUpTime));
  doRampDown(amp, rampDownTime);
       if (DAC == DA) {
      write_valueX(0);
     } else {
      write_valueY(0);
     }  
  doRampUp(amp, rampUpTime); 
}

void doSquare(int cur_DAC) {
   DAC = cur_DAC;
  if (cur_DAC == DA) {
     amp = amplitude_a;
     width = interval_a; 
  } else {
     amp = amplitude_v;
     width = interval_v;    
  }
  squareWave(amp, width);
}

// Pulls the voltage at the DAC up from the specified start point, over the specified time
void doRampUp(double endPoint_uV, long width_us)
{
  float increment_uVperus = (float)endPoint_uV / width_us;// microVolts increment per microseconds
  if (DAC == DA) {
     startTime_us = timeSinceLastA_us;
  } else {
     startTime_us = timeSinceLastV_us;
  }
  unsigned long incrementTime_us = 0;
  while (incrementTime_us <= width_us) {
     if (DAC == DA) {
        incrementTime_us = (timeSinceLastA_us - startTime_us); 
     } else {
        incrementTime_us = (timeSinceLastV_us - startTime_us); 
     }
     float currentVoltage_uV = abs(increment_uVperus * incrementTime_us);
       if (DAC == DA) {
      write_valueX(currentVoltage_uV);
     } else {
      write_valueY(currentVoltage_uV);
     }     
  }
}

void squareWave(double endPoint_uV, long width_us)
{
  float increment_uVperus = (float)endPoint_uV / width_us;// microVolts increment per microseconds
  if (DAC == DA) {
     startTime_us = timeSinceLastA_us;
  } else {
     startTime_us = timeSinceLastV_us;
  }
  unsigned long incrementTime_us = 0;
    while (incrementTime_us <= width_us) {
     if (DAC == DA) {
        incrementTime_us = (timeSinceLastA_us - startTime_us); 
     } else {
        incrementTime_us = (timeSinceLastV_us - startTime_us); 
     }
     if (DAC == DA) {
      write_valueX(endPoint_uV);
     } else {
      write_valueY(endPoint_uV);
     }  
  }
}

// Pulls the voltage at the DAC down from the specified start point, over the specified time
void doRampDown(double startPoint_uV, long width_us)
{
  float increment_uVperus = -1 * (float)startPoint_uV / width_us;// microVolts increment per microseconds, negative gradient since we are going down.
  if (DAC == DA) {
    startTime_us = timeSinceLastBPM_us;
  } else {
    startTime_us = timeSinceLastBPM_us + interval_a + av_interval; 
  }
  unsigned long incrementTime_us = 0;
  while(incrementTime_us <= width_us){
     if (DAC == DA) {
      incrementTime_us = (timeSinceLastBPM_us - startTime_us);
     } else {
       incrementTime_us = (timeSinceLastBPM_us + interval_a + av_interval - startTime_us);
     }
     float currentVoltage_uV =  abs(startPoint_uV + (increment_uVperus * incrementTime_us));// If we go negative, we underflow and get a big spike.
     if (DAC == DA) {
      write_valueX(currentVoltage_uV);
     } else {
      write_valueY(currentVoltage_uV);
     }     
  }
}






