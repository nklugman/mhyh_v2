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


int calc(int av_interval, int va_interval, int bpm, int a_width, int v_width){
  int valid = bpm - av_interval - va_interval - a_width - v_width;
  if (valid == 0) {
    return valid;
  }
  if (av_interval == -1) {
    return bpm - va_interval - a_width - v_width;
  }
  if (va_interval == -1) {
    return bpm - av_interval - a_width - v_width;
  }
  if (bpm == -1) {
    return av_interval + va_interval + a_width + v_width;
  }
  if (a_width == -1) {
    return bpm - av_interval - va_interval - v_width;
  }
  if (v_width == -1) {
    return bpm - av_interval - va_interval - a_width;
  }
}

bool has_beat_a = false;
void VA_test() {
  unsigned long v_start = interval_a+av_interval;
  unsigned long a_restart = v_start+interval_v+va_interval;

  if (timeSinceLastA_us > a_restart) {
    timeSinceLastA_us = 0;
    doPC69(DA); //busy loop for interval_a
    has_beat_a = true;
  }
  if (has_beat_a == true && timeSinceLastA_us >= v_start) {
    doPC69(DV); //busy loop for interval_v
    has_beat_a = false;
  }
}


// Controls the timing of generated waves depending on user input.
void checkAndDoPulse(){ 
    unsigned long av_interval_start = interval_a;
    unsigned long av_interval_end = interval_a + av_interval;

    if(timeSinceLastBPM_us > bpm){
      //Serial.print("AV INTERVAL: ");
      //Serial.println(String(last_v_debug-last_a_debug));
      //Serial.print("BEAT TIME: ");
      //Serial.println(String(millis()-last_b_debug));
      //Serial.println("********BEAT**********");
      //Serial.print("BEAT A: ");
      //Serial.println(String(millis(), DEC));
      last_b_debug = millis();
      last_a_debug = millis();
      on1 = !on1;
      digitalWrite(p1, on1);  
      timeSinceLastBPM_us = 0;// Reset the BPM timer
      timeSinceLastA_us = 0;   
      doPC69(DA);   
      has_beat_v = false;
    } 
    if (timeSinceLastBPM_us >= av_interval_end && has_beat_v == false) {
        on2 = !on2;
        digitalWrite(p2, on2); 
        //Serial.print("BEAT V: ");
        //Serial.println(String(millis(), DEC));
        last_v_debug = millis();
        has_beat_v = true;   
        doPC69(DV);
    }
}

// Top level PC69 Generator Function
void doPC69(int cur_DAC) { 
  on2 = !on2;
  digitalWrite(p2, on2);  
  DAC = cur_DAC;
  if (cur_DAC == DA) {
     amp = amplitude_a;
     width = interval_a; 
  } else {
     amp = amplitude_v;
     width = interval_v;    
  }
  //rampUpTime = width;
  rampDownTime = (2 * width) / 15;
  rampUpTime = (13 * width) / 15;
  //Serial.print("rampDownTime: ");
  //Serial.println(String(rampDownTime));
  //Serial.print("rampUpTime: ");
  //Serial.println(String(rampUpTime));
  doRampDown(amp, rampDownTime);
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
  while (incrementTime_us < width_us) {
     if (DAC == DA) {
        incrementTime_us = (timeSinceLastA_us - startTime_us); 
     } else {
        incrementTime_us = (timeSinceLastV_us - startTime_us); 
     }
     float currentVoltage_uV = increment_uVperus * incrementTime_us;
     updateDACVoltage(currentVoltage_uV);
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
    while (incrementTime_us < width_us) {
     if (DAC == DA) {
        incrementTime_us = (timeSinceLastA_us - startTime_us); 
     } else {
        incrementTime_us = (timeSinceLastV_us - startTime_us); 
     }
     updateDACVoltage(endPoint_uV);
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
  while(incrementTime_us < width_us){
     if (DAC == DA) {
      incrementTime_us = (timeSinceLastBPM_us - startTime_us);
     } else {
       incrementTime_us = (timeSinceLastBPM_us + interval_a + av_interval - startTime_us);
     }
     float currentVoltage_uV =  abs(startPoint_uV + (increment_uVperus * incrementTime_us));// If we go negative, we underflow and get a big spike.
     updateDACVoltage(currentVoltage_uV);
  }
}


// Adjust for Voltage
void updateDACVoltage(double setpoint_uV)
{
  long dacVoltage_uV = setpoint_uV * voltageFactor;
  long dacValue = 4095 * ((dacVoltage_uV / 1000) / maxDACVoltage_mV);
  if (DAC == DA) {
     dacA.setVoltage(dacValue, false); 
  } else {
     dacV.setVoltage(dacValue, false); 
  }
}


void zeroVoltages() 
{
   dacA.setVoltage(0, false); 
   dacV.setVoltage(0, false); 
}

