/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.
 
 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
 // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

// So... Yeah... Will bypass all 
// user set values... Don't set
// unless you want to debug...
boolean debug = true;

// Global variables....
boolean editable = false;
boolean running = false;
boolean ack = false;
String side = "A";
float frequency_a = -1;
float amplitude_a = -1;
float interval_a = -1;
float frequency_v = -1;
float amplitude_v = -1;
float interval_v = -1;
float av_interval = -1;
String[] ports = new String[30];
int com_port = -1;
boolean cmd_pending = false;

public void print_log(String msg) {
  String cur_str = serial_textbox.getText() + msg; 
  serial_textbox.setText(cur_str);
}

public void println_log(String msg) {
  String cur_str = serial_textbox.getText() + msg + "\n"; 
  serial_textbox.setText(cur_str);
}

public void cmd_btn_click(GButton source, GEvent event) {
   port.clear();
   port.write(cmd_field.getText());
   cmd_field.setText(""); 
}

public void cmd_field_change(GTextField source, GEvent event) {
   if (event.toString() == "TextField/Area lost focus") {
      if (source.getText() != "") {
         cmd_pending = true;
      }
   } 
}

public void start_btn_click(GButton source, GEvent event) { 
  if (debug == true) {
    frequency_a = 10;
    amplitude_a = 10;
    interval_a = 10;
    frequency_v = 10;
    amplitude_v = 10;
    interval_v = 10;
    av_interval = 10;
    com_port = -2;
    contact = true;
  }
  //println("start click");
  if (frequency_a == -1 || 
    amplitude_a == -1 ||
    interval_a == -1  ||
    frequency_v == -1 || 
    amplitude_v == -1 ||
    interval_v == -1  ||
    av_interval == -1  ||
    contact == false ||
    com_port == -1) {
    println_log("************* Have not set parameters *************");
  } else if (running == false) {
    running = true;
    start_btn.setText("Stop Test");
    start_btn.setLocalColorScheme(GCScheme.RED_SCHEME);
    switch_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    port_list.setEnabled(false);
    edit_btn.setEnabled(false);
    cmd_send_btn.setEnabled(false);
    frequency_val_a_field.setEnabled(false);
    interval_val_a_field.setEnabled(false);
    amplitude_val_a_field.setEnabled(false);
    frequency_val_v_field.setEnabled(false);
    interval_val_v_field.setEnabled(false);
    amplitude_val_v_field.setEnabled(false);
    println_log("Current Date/Time: " + month() + "/" + day() + " " + hour() + ":" + minute() + ":" + second());
    mode_state.setText("RUNNING");
    send_start_packet();
  } else {
    running = false;
    start_btn.setText("Start Test");
    start_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setEnabled(true);
    port_list.setEnabled(true);
    cmd_send_btn.setEnabled(true);
    mode_state.setText("IDLE");
    send_end_packet();
  }
} 

public void frequency_val_change(GTextField source, GEvent event) {
  if (event.toString() == "TextField/Area lost focus") {
    int value = int(source.getText());
    if (side == "A") {
      frequency_a = value;
    } else {
      frequency_v = value;
    }
    frequency_slider.setValue(value);
  }
}

public void amplitude_val_change(GTextField source, GEvent event) {
  if (event.toString() == "TextField/Area lost focus") {
    int value = int(source.getText());
    if (side == "A") {
      amplitude_a = value;
    } else {
      amplitude_v = value;
    }
    amplitude_slider.setValue(value);
  }
}

public void interval_val_change(GTextField source, GEvent event) {
  if (event.toString() == "TextField/Area lost focus") {
    int value = int(source.getText());
    if (side == "A") {
      interval_a = value;
    } else {
      interval_v = value;
    }
    interval_slider.setValue(value);
  }
}


public void av_val_change(GTextField source, GEvent event) {
  if (event.toString() == "TextField/Area lost focus") {
    int value = int(source.getText());
    av_interval = value;
    av_slider.setValue(value);
  }
}

public void port_list_click(GDropList source, GEvent event) { //_CODE_:dropList1:899812:
  com_port = source.getSelectedIndex();
  connection_state.setText("Not Connected");
  cmd_field.setEnabled(false);
  cmd_send_btn.setEnabled(false);
  cmd_field_label.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  cmd_send_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  if (port != null) {
    port.stop();
    port = null;
  }
  port = new Serial(this, Serial.list()[com_port], 57600);
  port.bufferUntil('\n'); 
  contact = false;
} 



public void frequency_slider_change(GCustomSlider source, GEvent event) { //_CODE_:frequency_slider:999543:
  //println("freq slider");
  if (side == "A") {
    frequency_val_a_field.setText(str(source.getValueI()));
    frequency_a = source.getValueI();
  } else { 
    frequency_val_v_field.setText(str(source.getValueI()));    
    frequency_v = source.getValueI();
  }
} 

public void amplitude_slider_change(GCustomSlider source, GEvent event) { //_CODE_:custom_slider1:464409:
  //println("amp slider");
  if (side == "A") {
    amplitude_val_a_field.setText(str(source.getValueI()));
    amplitude_a = source.getValueI();
  } else { 
    amplitude_val_v_field.setText(str(source.getValueI())); 
    amplitude_v = source.getValueI();
  }
} 

public void av_slider_change(GCustomSlider source, GEvent event) { //_CODE_:custom_slider2:244735:
  //println("av slider");
  av_val_field.setText(str(source.getValueI()));
  av_interval = source.getValueI();
} 

public void interval_slider_change(GCustomSlider source, GEvent event) { //_CODE_:custom_slider3:848810:
  //println("interval slider");
  if (side == "A") {
    interval_val_a_field.setText(str(source.getValueI()));
    interval_a = source.getValueI();
  } else { 
    interval_val_v_field.setText(str(source.getValueI())); 
    interval_v = source.getValueI();
  }
} 

public void edit_click(GButton source, GEvent event) { 
  //println("edit click");
  if (running == true) return;
  if (editable == true) {
    editable = false;
  } else {
    editable = true;
  }
  fields_enabled(side);
  sliders_enabled(editable);
} 

public void switch_click(GButton source, GEvent event) { //_CODE_:switch_btn:294277:
  //println("switch click");
  if (side == "A") {
    side = "V";
  } else {
    side = "A";
  }
  //side_state.setText(side);
  middle_sliders();
  update_top_labels(side);
  fields_enabled(side);
} 

public void update_top_labels(String side) {
  if (side == "A") {
    A_label.setLocalColorScheme(GCScheme.RED_SCHEME);
    V_label.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    frequency_val_a_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    interval_val_a_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    amplitude_val_a_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    frequency_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    interval_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    amplitude_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    mode_state.setText("Editing - Side A");
  } else {
    V_label.setLocalColorScheme(GCScheme.RED_SCHEME);
    A_label.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    frequency_val_v_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    interval_val_v_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    amplitude_val_v_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    frequency_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    interval_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    amplitude_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    mode_state.setText("Editing - Side V");
  }
}

public void middle_sliders() {
  if (interval_a != -1 && interval_v != -1) {
    interval_slider.setValue((interval_slider.getStartLimit() + interval_slider.getEndLimit())/2);
  }
  if (amplitude_a != -1 && amplitude_v != -1) {
    amplitude_slider.setValue((amplitude_slider.getStartLimit() + amplitude_slider.getEndLimit())/2);
  }
  if (frequency_a != -1 && frequency_v != -1) {
    frequency_slider.setValue((frequency_slider.getStartLimit() + frequency_slider.getEndLimit())/2);
  }
}

public void fields_enabled(String side) {
  if (side == "A") {
    frequency_val_a_field.setEnabled(true);
    interval_val_a_field.setEnabled(true);
    amplitude_val_a_field.setEnabled(true);
    frequency_val_v_field.setEnabled(false);
    interval_val_v_field.setEnabled(false);
    amplitude_val_v_field.setEnabled(false);
  } else {
    frequency_val_a_field.setEnabled(false);
    interval_val_a_field.setEnabled(false);
    amplitude_val_a_field.setEnabled(false);
    frequency_val_v_field.setEnabled(true);
    interval_val_v_field.setEnabled(true);
    amplitude_val_v_field.setEnabled(true);
  }
  av_val_field.setEnabled(true);
}

public void sliders_enabled(boolean state) {
  if (state == true) {
    interval_slider.setStyle("red_yellow18px");
    amplitude_slider.setStyle("red_yellow18px");
    av_slider.setStyle("red_yellow18px");
    frequency_slider.setStyle("red_yellow18px");
    update_top_labels(side);  
    start_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    switch_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.RED_SCHEME);
    edit_btn.setText("Stop Editing");
    av_val_field.setLocalColorScheme(GCScheme.RED_SCHEME);
  } else { //not editable 
    interval_slider.setStyle("grey_blue");
    amplitude_slider.setStyle("grey_blue");
    av_slider.setStyle("grey_blue");
    frequency_slider.setStyle("grey_blue");
    edit_btn.setText("Edit Parameters");

    frequency_val_a_field.setEnabled(false);
    interval_val_a_field.setEnabled(false);
    amplitude_val_a_field.setEnabled(false);
    frequency_val_v_field.setEnabled(false);
    interval_val_v_field.setEnabled(false);
    amplitude_val_v_field.setEnabled(false);
    av_val_field.setEnabled(false);

    A_label.setLocalColorScheme(GCScheme.CYAN_SCHEME); 
    V_label.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    av_val_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);

    frequency_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    interval_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    amplitude_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    frequency_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    interval_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    amplitude_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);

    switch_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);

    start_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);

    mode_state.setText("IDLE");
  }
  interval_slider.setEnabled(state);
  amplitude_slider.setEnabled(state);
  av_slider.setEnabled(state);
  frequency_slider.setEnabled(state);
  start_btn.setEnabled(!state);
  switch_btn.setEnabled(state);
}

public void getPorts() {
  for (int i = 0; i < Serial.list ().length; i++) {
    ports[i] = Serial.list()[i];
  }
}



public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  if (frame != null)
    frame.setTitle("MHYH");

  // Sliders
  interval_slider = new GCustomSlider(this, 20, 125, 390, 40, "grey_blue");
  interval_slider.setLimits(50.0, 0.0, 100.0);
  interval_slider.setEnabled(false);
  interval_slider.setNumberFormat(G4P.DECIMAL, 2);
  interval_slider.setOpaque(false);
  interval_slider.addEventHandler(this, "interval_slider_change");

  amplitude_slider = new GCustomSlider(this, 20, 175, 390, 40, "grey_blue");
  amplitude_slider.setLimits(50.0, 0.0, 100.0);
  amplitude_slider.setEnabled(false);
  amplitude_slider.setNumberFormat(G4P.DECIMAL, 2);
  amplitude_slider.setOpaque(false);
  amplitude_slider.addEventHandler(this, "amplitude_slider_change");

  frequency_slider = new GCustomSlider(this, 20, 225, 390, 40, "grey_blue");
  frequency_slider.setLimits(50.0, 0.0, 100.0);
  frequency_slider.setEnabled(false);
  frequency_slider.setNumberFormat(G4P.DECIMAL, 2);
  frequency_slider.setOpaque(false);
  frequency_slider.addEventHandler(this, "frequency_slider_change");

  av_slider = new GCustomSlider(this, 20, 275, 390, 40, "grey_blue");
  av_slider.setLimits(50.0, 0.0, 100.0);
  av_slider.setEnabled(false);
  av_slider.setNumberFormat(G4P.DECIMAL, 2);
  av_slider.setOpaque(false);
  av_slider.addEventHandler(this, "av_slider_change");


  //A Side Display
  A_label = new GLabel(this, 410, 107, 30, 20);
  A_label.setText("A");
  A_label.setTextBold();
  A_label.setOpaque(false);


  //V Side Display
  V_label = new GLabel(this, 451, 107, 30, 20);
  V_label.setText("V");
  V_label.setTextBold();
  V_label.setOpaque(false);


  //Field Display
  av_val_field  = new GTextField(this, 426, 285, 33, 19, G4P.SCROLLBARS_NONE);
  av_val_field.addEventHandler(this, "av_val_change");
  av_val_field.setText("-1");
  av_val_field.setEnabled(false);

  //V Side Display
  interval_val_v_field = new GTextField(this, 450, 135, 30, 20, G4P.SCROLLBARS_NONE);
  interval_val_v_field.addEventHandler(this, "interval_val_change");
  interval_val_v_field.setText("-1");
  interval_val_v_field.setEnabled(false);
  amplitude_val_v_field = new GTextField(this, 450, 185, 30, 20, G4P.SCROLLBARS_NONE);
  amplitude_val_v_field.addEventHandler(this, "amplitude_val_change");
  amplitude_val_v_field.setText("-1");
  amplitude_val_v_field.setEnabled(false);
  frequency_val_v_field = new GTextField(this, 450, 235, 30, 20, G4P.SCROLLBARS_NONE);
  frequency_val_v_field.addEventHandler(this, "frequency_val_change");
  frequency_val_v_field.setText("-1");
  frequency_val_v_field.setEnabled(false);

  //A Side Display
  interval_val_a_field = new GTextField(this, 410, 135, 30, 20, G4P.SCROLLBARS_NONE);
  interval_val_a_field.addEventHandler(this, "interval_val_change");
  interval_val_a_field.setText("-1");
  interval_val_a_field.setEnabled(false);
  amplitude_val_a_field = new GTextField(this, 410, 185, 30, 20, G4P.SCROLLBARS_NONE);
  amplitude_val_a_field.addEventHandler(this, "amplitude_val_change");
  amplitude_val_a_field.setText("-1");
  amplitude_val_a_field.setEnabled(false);
  frequency_val_a_field = new GTextField(this, 410, 235, 30, 20, G4P.SCROLLBARS_NONE);
  frequency_val_a_field.addEventHandler(this, "frequency_val_change");
  frequency_val_a_field.setText("-1");
  frequency_val_a_field.setEnabled(false);

  //Make it All Editable?
  edit_btn = new GButton(this, 20, 350, 110, 30);
  edit_btn.setText("Edit Parameters");
  edit_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  edit_btn.addEventHandler(this, "edit_click");
  switch_btn = new GButton(this, 20, 400, 110, 30);
  switch_btn.setEnabled(false);
  switch_btn.setText("Switch Chambers");
  switch_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  switch_btn.addEventHandler(this, "switch_click");

  //Stop and Start  
  start_btn = new GButton(this, 380, 400, 100, 30);
  start_btn.setText("Start Test");
  start_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  start_btn.addEventHandler(this, "start_btn_click");    

  // Ports
  port_label = new GLabel(this, 200, 325, 90, 20);
  port_label.setText("COM Port");
  port_list = new GDropList(this, 150, 350, 220, 80, 3);
  getPorts();
  port_list.setItems(ports, 0);
  port_list.addEventHandler(this, "port_list_click");    

  // Label the sliders
  interval_label = new GLabel(this, 7, 150, 100, 20);
  interval_label.setText("Interval (ms)");
  interval_label.setOpaque(false);
  amplitude_label = new GLabel(this, 15, 200, 100, 20);
  amplitude_label.setText("Amplitude (mV)");
  amplitude_label.setOpaque(false);
  freq_label = new GLabel(this, 15, 250, 100, 20);
  freq_label.setText("Frequency (ms)");
  freq_label.setOpaque(false);
  av_label = new GLabel(this, 14, 300, 120, 20);
  av_label.setText("A-V Interval (ms)");
  av_label.setOpaque(false);

  // Mode Label
  mode_label = new GLabel(this, 15, 90, 80, 20);
  mode_label.setText("Mode: ");
  mode_state = new GLabel(this, 15, 90, 220, 20);
  mode_state.setTextBold();
  mode_state.setText("IDLE");

  // Connection Label
  connection_label = new GLabel(this, 379, 350, 80, 20);
  connection_label.setText("Connection: ");
  connection_state = new GLabel(this, 318, 370, 220, 20);
  connection_state.setText("Not Connected");
  
  // Debug Log
  serial_textbox_label = new GLabel(this, 20, 460, 80, 20);
  serial_textbox_label.setText("Log: ");
  serial_textbox = new GTextArea(this, 20, 480, 450, 200, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
  serial_textbox.setOpaque(true);
  serial_textbox.setEnabled(false);
 
  // Commands
  cmd_field_label = new GLabel(this, 20, 700, 80, 20);
  cmd_field_label.setText("Command: ");
  cmd_field_label.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  cmd_field = new GTextField(this, 20, 720, 250, 30, G4P.SCROLLBARS_NONE);
  cmd_field.setOpaque(true);
  cmd_field.setEnabled(false);
  cmd_field.addEventHandler(this, "cmd_field_change");
  cmd_send_btn = new GButton(this, 300, 720, 110, 30);
  cmd_send_btn.setText("Send Command");
  cmd_send_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  cmd_send_btn.setEnabled(false);
  cmd_send_btn.addEventHandler(this, "cmd_btn_click");  
}

GLabel mode_label;
GLabel mode_state;
GButton start_btn; 
GCustomSlider frequency_slider; 
GLabel freq_label; 
GCustomSlider interval_slider; 
GCustomSlider amplitude_slider; 
GLabel amplitude_label; 
GLabel interval_label; 
GCustomSlider av_slider; 
GLabel av_label; 

GTextField interval_val_a_field; 
GTextField amplitude_val_a_field; 
GTextField frequency_val_a_field; 
GTextField interval_val_v_field; 
GTextField amplitude_val_v_field; 
GTextField frequency_val_v_field; 
GTextField av_val_field; 

GLabel interval_val_a; 
GLabel amplitude_val_a; 
GLabel frequency_val_a; 
GLabel av_val; 
GLabel interval_val_v; 
GLabel amplitude_val_v; 
GLabel frequency_val_v;

GLabel A_label; 
GLabel V_label; 
GButton edit_btn; 
GLabel running_state; 
GButton switch_btn;
GLabel port_label;
GDropList port_list;
GLabel connection_label;
GLabel connection_state;
GLabel serial_textbox_label;
GTextArea serial_textbox; 
GTextField cmd_field;
GLabel cmd_field_label;
GButton cmd_send_btn; 

