import processing.serial.*; 

Serial port; 
String val;

boolean contact = false;
char handshake_char = 'A';
char start_char = 's';
char end_char = 'e';
int connection_timeout = 5000;
long previous_time = 0;

void serialEvent(Serial port) {
 val = port.readStringUntil('\n');
 if (val != null) {
  val = trim(val);
  println_log(val);
  if (contact == false) { //Try to talk to controller
    if (val.equals("A")) {
      port.clear();
      contact = true;
      port.write(handshake_char);
      println_log("***** Contact Established ******");
      connection_state.setText("Connected");
      cmd_send_btn.setEnabled(true);
      cmd_field.setEnabled(true);
      cmd_field_label.setLocalColorScheme(GCScheme.GREEN_SCHEME);
      cmd_send_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    }
  }
 }
}

void send_start_packet() {
      println_log("**************************");
      println_log("* SENDING ARDUINO SETTINGS:");
      println_log("*   frequency_a: " + frequency_a );
      println_log("*   amplitude_a: " + amplitude_a );
      println_log("*   interval_a: " + interval_a );
      println_log("*   frequency_v: " + frequency_v );
      println_log("*   amplitude_v: " + amplitude_v);
      println_log("*   interval_v: " + interval_v );
      println_log("*   av_interval: " + av_interval );
      println_log("*   com_port: " + com_port );
      println_log("**************************");
      port.clear();
      port.write(
        start_char + 
        "|" +
        str(frequency_a)  +
        "|" +
        str(amplitude_a) +
        "|" +
        str(interval_a) +
        "|" +
        str(frequency_v) +
        "|" +
        str(amplitude_v) +
        "|" +
        str(interval_v) +
        "|" +
        str(av_interval) + 
        "\n"
      );
}

void send_end_packet() {
      port.clear();
      port.write(
        end_char + "\n"
      );
}
  
  
