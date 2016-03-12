import processing.serial.*; 

Serial port; 
String serial_val;

boolean contact = false;
char handshake_char = 'A';
char start_char = 's';
char end_char = 'e';
long previous_time = 0;

void serialEvent(Serial port) {
 serial_val = port.readStringUntil('\n');
 if (serial_val != null) {
  serial_val = trim(serial_val);
  println_log(serial_val);
  if (contact == false) { //Try to talk to controller
    if (serial_val.equals("A")) {
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

void do_data_units() {
  bpm = (float)1000000 * 60/bpm; //microseconds
}

void send_start_packet() {
      do_data_units();
      println_log("**************************");
      println_log("* SENDING ARDUINO SETTINGS:");
      println_log("*   bpm: " + bpm );
      println_log("*   amplitude_a: " + amplitude_a );
      println_log("*   interval_a: " + interval_a );
      println_log("*   amplitude_v: " + amplitude_v);
      println_log("*   interval_v: " + interval_v );
      println_log("*   av_interval: " + av_interval );
      println_log("*   com_port: " + com_port );
      println_log("**************************");
      port.clear();
      port.write(
        start_char + 
        "|" +
        str(bpm)  +
        "|" +
        str(amplitude_a*100) +
        "|" +
        str(interval_a*1000) +
        "|" +
        str(amplitude_v*100) +
        "|" +
        str(interval_v*1000) +
        "|" +
        str(av_interval*1000) + 
        "\n"
      );
}

void send_end_packet() {
      port.clear();
      port.write(
        end_char + "\n"
      );
}
  
  
