// Serial Parameters
const int LINE_BUFFER_SIZE = 80; // max line length is one less than this
char delimiters[] = "|";
char* packetPosition;
unsigned long cur_field = 0;
int cnt = 0;

bool check_for_bit(char cur_bit, String msg){
  if (Serial.available() != 0) { //Be on the lookout for end packets
    char ch = Serial.read(); 
    if (ch == cur_bit) {
       isRunning = false;
       Serial.println("arduino: " + msg);
    }
  } 
}

void decode_packet() {
  char line[LINE_BUFFER_SIZE];
  Serial.println(line[LINE_BUFFER_SIZE]);
  if (read_line(line, sizeof(line)) < 0) {
    Serial.println("arduino: ERR line length");
    return; 
  } 
  if (line[0] == handshake_bit) {
    
  } else if (line[0] == end_bit) {
   
  }
  else if (line[0] == start_bit) { // start packet
      packetPosition = strtok(line, delimiters);
      cnt = 0;
      
      unsigned long tmp_bpm = 0;
      double tmp_amplitude_a = 0;
      unsigned long tmp_interval_a = 0;
      double tmp_amplitude_v = 0;
      unsigned long tmp_interval_v = 0;
      unsigned long tmp_av_interval = 0;
      while(packetPosition != NULL){
          cur_field = atof(packetPosition);
          if (cnt != 0) {
            switch (cnt) {
            case 1:    
              tmp_bpm = cur_field;
              break;
            case 2:   
              tmp_amplitude_a = cur_field; 
              break;
            case 3: 
              tmp_interval_a = cur_field;
              break;
            case 4:  
              tmp_amplitude_v = cur_field;
              break;
            case 5:    
              tmp_interval_v = cur_field;
              break;
            case 6:    
              tmp_av_interval = cur_field;
              break;
           default:
             Serial.println("arduino: ERR switch");
           }     
          }
          packetPosition = strtok(NULL, delimiters);  
          cnt++;
      }
      if (cnt == PACKET_LENGTH) {
         Serial.println("arduino: VALID PACKET");
         bpm = tmp_bpm;
         amplitude_a = tmp_amplitude_a;   //in microV
         interval_a = tmp_interval_a;
         amplitude_v = tmp_amplitude_v;   //in microV
         interval_v = tmp_interval_v;
         av_interval = tmp_av_interval; 
         Serial.print("arduino: bpm: ");
         Serial.println(bpm);
         Serial.print("arduino: amplitude_a: ");
         Serial.println(amplitude_a);        
         Serial.print("arduino: interval_a: ");
         Serial.println(interval_a);        
         Serial.print("arduino: amplitude_v: ");
         Serial.println(amplitude_v);
         Serial.print("arduino: interval_v: ");
         Serial.println(interval_v);
         Serial.print("arduino: av_interval: ");
         Serial.println(av_interval);        
         isRunning = true;
      }
  } else if (strcmp(line, "") == 0) {
  } else {
    Serial.print("arduino: ERR unknown command: \"");
    Serial.print(line);
    Serial.print("\" (well formed packets are of type:"); 
    Serial.println("s|freq_a|amp_a|interval_a|freq_v|amp_v|interval_v|av_interval)");
  } 
}


int read_line(char* buffer, int bufsize)
{
  for (int index = 0; index < bufsize; index++) {
    while (Serial.available() == 0) {
    }
    char ch = Serial.read(); 
    //Serial.print(ch); 
    if (ch == '\n') {
      buffer[index] = 0; 
      return index; 
    }
    buffer[index] = ch; 
  }
  char ch;
  do {
    while (Serial.available() == 0) {
    }
    ch = Serial.read(); 
    Serial.print(ch); 
  } while (ch != '\n');
  buffer[0] = 0; 
  return -1; 
}



