const int LED_PIN = 13;

//test packets
//  s|1|2
//  s|1|2|3|4|5|6|7
//  s|100|200|300|400|500|600|700
//  s|1000|2000|3000|4000|5000|6000|7000


// Serial Parameters
const int LINE_BUFFER_SIZE = 80; // max line length is one less than this
char delimiters[] = "|";
char* packetPosition;
int cur_field = 0;
int cnt = 0;

// Contact Parameters
char handshake_bit = 'A';
bool contact = false;

//Running Parameters (in order of packet)
int PACKET_LENGTH = 8;
char start_bit = 's';
int frequency_a = 0;
int amplitude_a = 0;
int interval_a = 0;
int frequency_v = 0;
int amplitude_v = 0;
int interval_v = 0;
int av_interval = 0;
char end_bit = 'e';

boolean first_print = true;


//Running State
bool isRunning = false;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(57600);
}


void loop() {
   if (contact == false) { // handshake like crazy at first
     Serial.println(handshake_bit); // spam that line
     if (check_for_bit(handshake_bit, "HANDSHAKE")) { //handshake
        contact = true; 
     }
   }
   if (isRunning == false && contact == true) {
      decode_packet(); //wait here until proper start packet is sent from processing
   } else if (isRunning == true && contact == true) {
      if (first_print == true) {
         Serial.println("arduino: RUNNING!");
         first_print = false;
      }
      if (check_for_bit(end_bit, "STOPPING")) { //be on the lookout for end bits
        isRunning = false;
        first_print = false;
      } 
      digitalWrite(LED_PIN, LOW);
      delay(100);
      digitalWrite(LED_PIN, HIGH);
      delay(100);
   }
}

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
  if (read_line(line, sizeof(line)) < 0) {
    Serial.println("arduino: ERR line length");
    return; 
  } 
  if (line[0] == handshake_bit) {
    
  } else if (line[0] == start_bit) { // start packet
      packetPosition = strtok(line, delimiters);
      cnt = 0;
      int tmp_frequency_a = 0;
      int tmp_amplitude_a = 0;
      int tmp_interval_a = 0;
      int tmp_frequency_v = 0;
      int tmp_amplitude_v = 0;
      int tmp_interval_v = 0;
      int tmp_av_interval = 0;
      while(packetPosition != NULL){
          cur_field = atoi(packetPosition);
          if (cnt != 0) {
            //Serial.println(cur_field);
            switch (cnt) {
            case 1:    
              tmp_frequency_a = cur_field;
              break;
            case 2:   
              tmp_amplitude_a = cur_field; 
              break;
            case 3: 
              tmp_interval_a = cur_field;
              break;
            case 4:  
              tmp_frequency_v = cur_field;
              break;
            case 5:    
              tmp_amplitude_v = cur_field;
              break;
            case 6:    
              tmp_interval_v = cur_field;
              break;
            case 7:    
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
         frequency_a = tmp_frequency_a;
         amplitude_a = tmp_amplitude_a;
         interval_a = tmp_interval_a;
         frequency_v = tmp_frequency_v;
         amplitude_v = tmp_amplitude_v;
         interval_v = tmp_interval_v;
         av_interval = tmp_av_interval; 
         Serial.print("arduino: frequency_a: ");
         Serial.println(frequency_a);
          Serial.print("arduino: amplitude_a: ");
         Serial.println(amplitude_a);        
          Serial.print("arduino: interval_a: ");
         Serial.println(interval_a);        
          Serial.print("arduino: frequency_v: ");
         Serial.println(frequency_v);
          Serial.print("arduino: amplitude_v: ");
         Serial.println(amplitude_v);
          Serial.print("arduino: interval_v: ");
         Serial.println(interval_v);
          Serial.print("arduino: av_interval: ");
         Serial.println(av_interval);        
         isRunning = true;
         //Serial.print(frequency_a + amplitude_a + interval_a + frequency_v + amplitude_v + interval_v + av_interval);         
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
