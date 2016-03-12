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
boolean debug = false;

// Global variables....
boolean editable = false;
boolean running = false;
boolean ack = false;
String side = "A";
float amplitude_a = -1;
float interval_a = -1;
float amplitude_v = -1;
float interval_v = -1;
float av_interval = -1;
float bpm = -1;
String[] ports = new String[30];
int com_port = -1;
boolean cmd_pending = false;

public void print_log(String msg) {
  String cur_str = serial_textbox.getText() + msg; 
  serial_textbox.setText(cur_str);
}

public void println_log(String msg) {
  println(msg);
  //String cur_str = serial_textbox.getText() + msg + "\n"; 
  //serial_textbox.setText(cur_str);
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

public void start_suite_btn_click(GButton source, GEvent event) { 
 initArrays();
 if (debug == true) {
    bpm = 50;
    amplitude_a = .2;
    interval_a = 10;
    amplitude_v = .2;
    interval_v = 10;
    av_interval = 100;
    com_port = -2;
    contact = true;
  }
  if (bpm == -1 || 
    amplitude_a == -1 ||
    interval_a == -1  ||
    amplitude_v == -1 ||
    interval_v == -1  ||
    av_interval == -1  ||
    contact == false ||
    com_port == -1) {
    println_log("************* Have not set parameters *************");
    showMsgWindow("Error", "Need to set parameters");
  } else if (running == false) {
    running = true;
    start_manual_btn.setText("Stop Test");
    start_manual_btn.setLocalColorScheme(GCScheme.RED_SCHEME);
    switch_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    port_list.setEnabled(false);
    edit_btn.setEnabled(false);
    cmd_send_btn.setEnabled(false);
    bpm_val_field.setEnabled(false);
    interval_val_a_field.setEnabled(false);
    interval_val_v_field.setEnabled(false);
    amplitude_val_a_field.setEnabled(false);
    amplitude_val_v_field.setEnabled(false);
    println_log("Current Date/Time: " + month() + "/" + day() + " " + hour() + ":" + minute() + ":" + second());
    mode_state.setText("RUNNING");
    buildNameWindow();
  } 
  
}


public void start_manual_btn_click(GButton source, GEvent event) { 
    //initArrays();
    //
 
  if (debug == true) {
    bpm = 50;
    amplitude_a = .2;
    interval_a = 10;
    amplitude_v = .2;
    interval_v = 10;
    av_interval = 100;
    com_port = -2;
    contact = true;
  }
  if (bpm == -1 || 
    amplitude_a == -1 ||
    interval_a == -1  ||
    amplitude_v == -1 ||
    interval_v == -1  ||
    av_interval == -1  ||
    contact == false ||
    com_port == -1) {
    println_log("************* Have not set parameters *************");
    showMsgWindow("Error", "Need to set parameters");
  } else if (running == false) {
    running = true;
    start_manual_btn.setText("Stop Test");
    start_manual_btn.setLocalColorScheme(GCScheme.RED_SCHEME);
    switch_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    port_list.setEnabled(false);
    edit_btn.setEnabled(false);
    cmd_send_btn.setEnabled(false);
    bpm_val_field.setEnabled(false);
    interval_val_a_field.setEnabled(false);
    interval_val_v_field.setEnabled(false);
    amplitude_val_a_field.setEnabled(false);
    amplitude_val_v_field.setEnabled(false);
    println_log("Current Date/Time: " + month() + "/" + day() + " " + hour() + ":" + minute() + ":" + second());
    mode_state.setText("RUNNING");
    send_start_packet();
  } else {
    running = false;
    start_manual_btn.setText("Start Manual Test");
    start_manual_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setEnabled(true);
    port_list.setEnabled(true);
    cmd_send_btn.setEnabled(true);
    mode_state.setText("IDLE");
    send_end_packet();
  }
  
} 

public void bpm_val_change(GTextField source, GEvent event) {
  if (event.toString() == "TextField/Area lost focus") {
    int value = int(source.getText());
    bpm = value;
    println("***********" + bpm);
    bpm_slider.setValue(value);
  }
}

public void amplitude_val_change(GTextField source, GEvent event) {
  if (event.toString() == "TextField/Area lost focus") {
    int value = int(source.getText());
    if (side == "A") {
      amplitude_a = value/10;
    } else {
      amplitude_v = value/10;
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



public void bpm_slider_change(GCustomSlider source, GEvent event) { //_CODE_:bpm_slider:999543:
  //println("freq slider");
  bpm_val_field.setText(str(source.getValueI()));
  bpm = source.getValueI();
} 

public void amplitude_slider_change(GCustomSlider source, GEvent event) { //_CODE_:custom_slider1:464409:
  //println("amp slider");
  if (side == "A") {
    amplitude_val_a_field.setText(str(source.getValueF()/10));
    amplitude_a = source.getValueF()/10;
  } else { 
    amplitude_val_v_field.setText(str(source.getValueF()/10)); 
    amplitude_v = source.getValueF()/10;
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
    //bpm_val_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    interval_val_a_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    amplitude_val_a_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    interval_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    amplitude_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    mode_state.setText("Editing - Side A");
  } else {
    V_label.setLocalColorScheme(GCScheme.RED_SCHEME);
    A_label.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    interval_val_v_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    amplitude_val_v_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    //bpm_val_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
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
}

public void fields_enabled(String side) {
  if (side == "A") {
    interval_val_a_field.setEnabled(true);
    amplitude_val_a_field.setEnabled(true);
    interval_val_v_field.setEnabled(false);
    amplitude_val_v_field.setEnabled(false);
  } else {
    interval_val_a_field.setEnabled(false);
    amplitude_val_a_field.setEnabled(false);
    interval_val_v_field.setEnabled(true);
    amplitude_val_v_field.setEnabled(true);
  }
  av_val_field.setEnabled(true);
  bpm_val_field.setEnabled(true);
}

public void sliders_enabled(boolean state) {
  if (state == true) {
    interval_slider.setStyle("red_yellow18px");
    amplitude_slider.setStyle("red_yellow18px");
    av_slider.setStyle("red_yellow18px");
    bpm_slider.setStyle("red_yellow18px");
    update_top_labels(side);  
    start_manual_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    switch_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.RED_SCHEME);
    edit_btn.setText("Stop Editing");
    av_val_field.setLocalColorScheme(GCScheme.RED_SCHEME);
    bpm_val_field.setLocalColorScheme(GCScheme.RED_SCHEME);
  } else { //not editable 
    interval_slider.setStyle("grey_blue");
    amplitude_slider.setStyle("grey_blue");
    av_slider.setStyle("grey_blue");
    bpm_slider.setStyle("grey_blue");
    edit_btn.setText("Edit Parameters");

    interval_val_a_field.setEnabled(false);
    amplitude_val_a_field.setEnabled(false);
    interval_val_v_field.setEnabled(false);
    amplitude_val_v_field.setEnabled(false);
    bpm_val_field.setEnabled(false);
    av_val_field.setEnabled(false);

    A_label.setLocalColorScheme(GCScheme.CYAN_SCHEME); 
    V_label.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    av_val_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    bpm_val_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    
    interval_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    amplitude_val_a_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    interval_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    amplitude_val_v_field.setLocalColorScheme(GCScheme.CYAN_SCHEME);

    switch_btn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);

    start_manual_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    edit_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);

    mode_state.setText("IDLE");
  }
  interval_slider.setEnabled(state);
  amplitude_slider.setEnabled(state);
  av_slider.setEnabled(state);
  bpm_slider.setEnabled(state);
  start_manual_btn.setEnabled(!state);
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
  amplitude_slider.setLimits(100.0, 0.0, 200.0);
  amplitude_slider.setEnabled(false);
  amplitude_slider.setNumberFormat(G4P.DECIMAL, 2);
  amplitude_slider.setOpaque(false);
  amplitude_slider.addEventHandler(this, "amplitude_slider_change");

  bpm_slider = new GCustomSlider(this, 20, 225, 390, 40, "grey_blue");
  bpm_slider.setLimits(110, 20.0, 200.0);
  bpm_slider.setEnabled(false);
  bpm_slider.setNumberFormat(G4P.DECIMAL, 2);
  bpm_slider.setOpaque(false);
  bpm_slider.addEventHandler(this, "bpm_slider_change");

  av_slider = new GCustomSlider(this, 20, 275, 390, 40, "grey_blue");
  av_slider.setLimits(250.5, 1.0, 500.0);
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
  bpm_val_field = new GTextField(this, 426, 235, 30, 20, G4P.SCROLLBARS_NONE);
  bpm_val_field.addEventHandler(this, "bpm_val_change");
  bpm_val_field.setText("-1");
  bpm_val_field.setEnabled(false);

  //V Side Display
  interval_val_v_field = new GTextField(this, 450, 135, 30, 20, G4P.SCROLLBARS_NONE);
  interval_val_v_field.addEventHandler(this, "interval_val_change");
  interval_val_v_field.setText("-1");
  interval_val_v_field.setEnabled(false);
  amplitude_val_v_field = new GTextField(this, 450, 185, 30, 20, G4P.SCROLLBARS_NONE);
  amplitude_val_v_field.addEventHandler(this, "amplitude_val_change");
  amplitude_val_v_field.setText("-1");
  amplitude_val_v_field.setEnabled(false);
 
  //A Side Display
  interval_val_a_field = new GTextField(this, 410, 135, 30, 20, G4P.SCROLLBARS_NONE);
  interval_val_a_field.addEventHandler(this, "interval_val_change");
  interval_val_a_field.setText("-1");
  interval_val_a_field.setEnabled(false);
  amplitude_val_a_field = new GTextField(this, 410, 185, 30, 20, G4P.SCROLLBARS_NONE);
  amplitude_val_a_field.addEventHandler(this, "amplitude_val_change");
  amplitude_val_a_field.setText("-1");
  amplitude_val_a_field.setEnabled(false);

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
  start_manual_btn = new GButton(this, 149, 400, 115, 30);
  start_manual_btn.setText("Start Manual Test");
  start_manual_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  start_manual_btn.addEventHandler(this, "start_manual_btn_click");    

  //Stop and Start  
  start_suite_btn = new GButton(this, 380, 400, 100, 30);
  start_suite_btn.setText("Start Suite Test");
  start_suite_btn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  start_suite_btn.addEventHandler(this, "start_suite_btn_click");   


  // Ports
  port_label = new GLabel(this, 200, 325, 90, 20);
  port_label.setText("COM Port");
  port_list = new GDropList(this, 150, 350, 220, 80, 3);
  getPorts();
  port_list.setItems(ports, 0);
  port_list.addEventHandler(this, "port_list_click");    

  // Label the sliders
  interval_label = new GLabel(this, 7, 150, 100, 20);
  interval_label.setText("Width (ms)");
  interval_label.setOpaque(false);
  amplitude_label = new GLabel(this, 15, 200, 100, 20);
  amplitude_label.setText("Amplitude (mV)");
  amplitude_label.setOpaque(false);
  freq_label = new GLabel(this, 15, 250, 100, 20);
  freq_label.setText("Beats Per Minute");
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
  connection_state.setText("Connected");
  
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
GButton start_manual_btn; 
GButton start_suite_btn; 
GCustomSlider bpm_slider; 
GLabel freq_label; 
GCustomSlider interval_slider; 
GCustomSlider amplitude_slider; 
GLabel amplitude_label; 
GLabel interval_label; 
GCustomSlider av_slider; 
GLabel av_label; 

GTextField interval_val_a_field; 
GTextField amplitude_val_a_field; 
GTextField interval_val_v_field; 
GTextField amplitude_val_v_field; 
GTextField av_val_field; 
GTextField bpm_val_field; 

GLabel interval_val_a; 
GLabel amplitude_val_a; 
GLabel interval_val_v; 
GLabel amplitude_val_v; 
GLabel bpm_val; 
GLabel av_val; 

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


//***********************
// THIS CODE DOES ALL THE TEST WINDOWS
//***********************

public int TEST_NUM = 14;
String descriptions[] = new String[TEST_NUM];
String names[] = new String[TEST_NUM];
String results[] = new String[TEST_NUM];
String tests[] = new String[TEST_NUM];
String testerName = "";
boolean dirty = false;
boolean failed = false;
int start_time = 0;
public int cur_window = 1;
int test_start = 0;
PrintWriter output;
String serial;
String filename;
int AMP_A = 0;
int INV_A = 1;
int AMP_V = 2;
int INV_V = 3;
int AV_INT = 4;
int BPM = 5;


 
void windowMouse(GWinApplet appc, GWinData data, MouseEvent event) {
  MyWinData data2 = (MyWinData)data;
  switch(event.getAction()) {
  case MouseEvent.PRESS:
    data2.sx = data2.ex = appc.mouseX;
    data2.sy = data2.ey = appc.mouseY;
    data2.done = false;
    break;
  case MouseEvent.RELEASE:
    data2.ex = appc.mouseX;
    data2.ey = appc.mouseY;
    data2.done = true;
    break;
  case MouseEvent.DRAG:
    data2.ex = appc.mouseX;
    data2.ey = appc.mouseY;
    break;
  }
}

void windowDraw(GWinApplet appc, GWinData data) {
  MyWinData data2 = (MyWinData)data;
  if (!(data2.sx == data2.ex && data2.ey == data2.ey)) {
    appc.stroke(255);
    appc.strokeWeight(2);
    appc.noFill();
    if (data2.done) {
      appc.fill(128);
    }
    appc.rectMode(CORNERS);
    appc.rect(data2.sx, data2.sy, data2.ex, data2.ey);
  }
} 

class MyWinData extends GWinData {
  int sx, sy, ex, ey;
  boolean done;
}

public void buildTestWindow(int i) {
  
  windowTest[i] = new GWindow(this, "Test "+str(i), 0, 0, 450, 330, false, JAVA2D);
  windowTest[i].addDrawHandler(this, "win_draw2"); 
  windowTest[i].setActionOnClose(GWindow.CLOSE_WINDOW);
  
  nextBTNTest[i] = new GButton(windowTest[i].papplet, 361, 279, 80, 30);
  if (i == TEST_NUM-1) {
    nextBTNTest[i].setText("End");
  } else {
    nextBTNTest[i].setText("Next");
  }
  //nextBTNTest[i].addEventHandler(windowTest[i].papplet, "nextTest"+str(i)+"_click");
  
  endBTNTest = new GButton(windowTest[i].papplet, 7, 279, 80, 30);
  endBTNTest.setText("End");
  
  testNumberLabelTitleTest[i] = new GLabel(windowTest[i].papplet, 20, 10, 100, 30);
  testNumberLabelTitleTest[i].setText("Test Number:", GAlign.LEFT, GAlign.TOP);
  testNumberLabelTitleTest[i].setTextBold();
  testNumberLabelTitleTest[i].setOpaque(false);
  
  testNameLabelTitleTest[i] = new GLabel(windowTest[i].papplet, 20, 27, 100, 20);
  testNameLabelTitleTest[i].setText("Name:", GAlign.LEFT, GAlign.TOP);
  testNameLabelTitleTest[i].setTextBold();
  testNameLabelTitleTest[i].setOpaque(false);
  
  testConditionsLabelTitleTest[i] = new GLabel(windowTest[i].papplet, 20, 44, 100, 30);
  testConditionsLabelTitleTest[i].setText("Conditions:",  GAlign.LEFT, GAlign.TOP);
  testConditionsLabelTitleTest[i].setTextBold();
  testConditionsLabelTitleTest[i].setOpaque(false);
  
  testConditionsLabelTest[i] = new GLabel(windowTest[i].papplet, 130, 49, 300, 37);
  testConditionsLabelTest[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
  testConditionsLabelTest[i].setText(descriptions[i-1]);
  testConditionsLabelTest[i].setOpaque(false);
  
  testNumberLabelTest[i] = new GLabel(windowTest[i].papplet, 130, 11, 300, 30);
  testNumberLabelTest[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
  testNumberLabelTest[i].setText(str(i));
  testNumberLabelTest[i].setOpaque(false);
  
  testNameLabelTest[i] = new GLabel(windowTest[i].papplet, 130, 30, 300, 20);
  testNameLabelTest[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
  testNameLabelTest[i].setText(names[i-1]);
  testNameLabelTest[i].setOpaque(false);
  
  testReportLabelTitleTest[i] = new GLabel(windowTest[i].papplet, 30, 112, 80, 21);
  testReportLabelTitleTest[i].setText("Test Report:");
  testReportLabelTitleTest[i].setTextBold();
  testReportLabelTitleTest[i].setOpaque(false);
  
  testNotesLabelTitleTest[i] = new GLabel(windowTest[i].papplet, 30, 160, 80, 21);
  testNotesLabelTitleTest[i].setText("Test Notes:");
  testNotesLabelTitleTest[i].setTextBold();
  testNotesLabelTitleTest[i].setOpaque(false);
  
  passedTestButtonTest[i] = new GButton(windowTest[i].papplet, 117, 111, 120, 20);
  passedTestButtonTest[i].setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  passedTestButtonTest[i].setText("Passed");
  passedTestButtonTest[i].setOpaque(false);
  
  failedTestButtonTest[i] = new GButton(windowTest[i].papplet, 244, 111, 120, 20);
  failedTestButtonTest[i].setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  failedTestButtonTest[i].setText("Failed");
  failedTestButtonTest[i].setOpaque(false);

  testNotesTextAreaTest[i] = new GTextArea(windowTest[i].papplet, 117, 155, 244, 106, G4P.SCROLLBARS_NONE);
  testNotesTextAreaTest[i].setOpaque(true);
}

public void buildNameWindow() {
  test_start = millis();
  println("TESTER IS: " + testerName);
  filename = "";
  int d = day();
  String ds = String.valueOf(d);
  int m = month();
  String ms = String.valueOf(m);
  int y = year();
  String ys = String.valueOf(y);
  int h = hour();
  String hs = String.valueOf(h);
  int s = second();
  String ss = String.valueOf(s);
  filename += ys+ms+ds+hs+ss+".csv";
  println(filename);
  output = createWriter(filename); 
  String descriptors = "tester_name, generator_serial, result, time_elapsed_over_test, test_name, notes";
  output.println(descriptors);
  
  windowName = new GWindow(this, "Configure", 0, 0, 470, 160, false, JAVA2D);
  windowName.addDrawHandler(this, "win_draw2"); 
  windowName.setActionOnClose(GWindow.CLOSE_WINDOW);

  nextBTNName = new GButton(windowName.papplet, 361, 116, 80, 30);
  nextBTNName.setText("Next");
    
  nameNumberLabelTitleName = new GLabel(windowName.papplet, 20, 5, 140, 30);
  nameNumberLabelTitleName.setText("Enter Tester Name:", GAlign.LEFT, GAlign.MIDDLE);
  nameNumberLabelTitleName.setTextBold();
  nameNumberLabelTitleName.setOpaque(false);
  nameNotesTextAreaName = new GTextArea(windowName.papplet, 30, 30, 244, 45, G4P.SCROLLBARS_NONE);
  nameNotesTextAreaName.setOpaque(true);
  
  nameNumberLabelTitleGenerator = new GLabel(windowName.papplet, 20, 75, 200, 30);
  nameNumberLabelTitleGenerator.setText("Enter Generator Serial:", GAlign.LEFT, GAlign.MIDDLE);
  nameNumberLabelTitleGenerator.setTextBold();
  nameNumberLabelTitleGenerator.setOpaque(false);
  nameNotesTextAreaGenerator = new GTextArea(windowName.papplet, 30, 105, 244, 45, G4P.SCROLLBARS_NONE);
  nameNotesTextAreaGenerator.setOpaque(true);
}

public void showMsgWindow(String title, String msg) {
  windowErr = new GWindow(this, title, 0, 0, 470, 100, false, JAVA2D);
  windowErr.addDrawHandler(this, "win_draw2"); 
  windowErr.setActionOnClose(GWindow.CLOSE_WINDOW);
  okBTNErr = new GButton(windowErr.papplet, 361, 27, 80, 30);
  okBTNErr.setText("OK");
  errLabelMSG = new GLabel(windowErr.papplet, 10, 20, 350, 30);
  errLabelMSG.setText(msg);
  errLabelMSG.setTextBold();
  errLabelMSG.setOpaque(false);
}

synchronized public void win_draw2(GWinApplet appc, GWinData data) { 
  appc.background(230);
} 

public void configureTest(int cur) {
  String test = tests[cur];
  //test connection
  // if fail prompt error message
  String[] test_list = split(test, ',');
  amplitude_a = Float.valueOf(test_list[AMP_A]).floatValue();
  interval_a = Float.valueOf(test_list[INV_A]).floatValue();
  amplitude_v = Float.valueOf(test_list[AMP_V]).floatValue();
  interval_v = Float.valueOf(test_list[INV_V]).floatValue();
  av_interval = Float.valueOf(test_list[AV_INT]).floatValue();
  bpm = Float.valueOf(test_list[BPM]).floatValue();
  send_start_packet();
  //build and send config packet
}

public void initArrays() {
   names[0] = "Base Atrial Rate";
   descriptions[0] = "Set A rate to 75 PPM and verify"; 
   tests[0] = "1,2,3,4,5,6";
   names[1] = "Base Ventricular Rate";
   descriptions[1] = "Set V rate to 75 PPM and verify"; 
   tests[1] = "1,2,3,4,5,6";
   names[2] = "Atrial Pulse Voltage";
   descriptions[2] = "Set A output to 4V and verify"; 
   tests[2] = "1,2,3,4,5,6";
   names[3] = "Ventricular Pulse Voltage";
   descriptions[3] = "Set V output to 4V and verify"; 
   tests[3] = "1,2,3,4,5,6";
   names[4] = "Atrial Pulse Width";
   descriptions[4] = "Set A PW to 0.4ms and verify"; 
   tests[4] = "1,2,3,4,5,6";
   names[5] = "Ventricular Pulse Width";
   descriptions[5] = "Set V PW to 0.4ms and verify"; 
   tests[5] = "1,2,3,4,5,6";
   names[6] = "Atrial Sensitivity";
   descriptions[6] = "Set A sense to 1mV and apply a signal to the atrial channel less than 1mV. Verify no detection."; 
   tests[6] = "1,2,3,4,5,6";
   names[7] = "Ventricular Sensitivity";
   descriptions[7] = "Set A sense to 2mV and apply a signal to the atrial channel less than 1mV. Verify no detection.";
   tests[7] = "1,2,3,4,5,6"; 
   names[8] = "AV/PV Delay";
   descriptions[8] = "Set AV delay to 90ms and verfy by altering P/V interval from 70ms to 110 ms."; 
   tests[8] = "1,2,3,4,5,6";
   names[9] = "Ventricular Refractory Period";
   descriptions[9] = "Set V Ref to 350ms and verify by changing simulated R-T interval from 300ms to 400ms"; 
   tests[9] = "1,2,3,4,5,6";
   names[10] = "PVARP";
   descriptions[10] = "Set PVARP to 175 and verify."; 
   tests[10] = "1,2,3,4,5,6";
   names[11] = "Max Sensor Rate";
   descriptions[11] = "Set MSR to 130 and verify by shaking."; 
   tests[11] = "1,2,3,4,5,6";
   names[12] = "Max Tracking Rate";
   descriptions[12] = "Set MTR to 120 and verify by increasing atrial rate to 150 and tracking response."; 
   tests[12] = "1,2,3,4,5,6";
}

public void advance_window(int i) {
  if (dirty == true) {
    build_report(i);
    windowTest[i].close();
    cur_window += 1;
    buildTestWindow(cur_window);
    dirty = false;
    start_time = millis();
    send_end_packet(); //stop the last test
  } else {
    showMsgWindow("Error", "Need To Classify Test Results Before Moving Forward");
  }
}

public void build_report(int cur) {
  String result = testerName + ",";
  result += serial + ",";
  if (failed) {
     result += "failed,"; 
  } else {
     result += "passed,";
  }
  result += str(millis() - start_time) + ",";
  result += names[cur-1] + ",";
  String notes = testNotesTextAreaTest[cur].getText();
  notes = notes.replace('\n', ' ');
  result += notes;
  result += "\n";
  output.print(result);
  results[cur] = result;
}

public void save_report() {
  int total_elapsed_time = millis() - test_start;
  test_start = millis();
  output.print("\n\n\n\nTOTAL TEST TIME MS: " + str(total_elapsed_time));
  output.flush();
  output.close();
  showMsgWindow("Results", "All results stored in " + filename);
  open("/Applications/Process_4.app");
}

public void check_event(GButton button, GEvent event, int cur) {
  if (button == passedTestButtonTest[cur] && event == GEvent.CLICKED) {
    failedTestButtonTest[cur].setLocalColorScheme(GCScheme.BLUE_SCHEME);
    passedTestButtonTest[cur].setLocalColorScheme(GCScheme.GREEN_SCHEME);
    failed = false;
    dirty = true;
  }
  if (button == failedTestButtonTest[cur] && event == GEvent.CLICKED) {
    failedTestButtonTest[cur].setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    passedTestButtonTest[cur].setLocalColorScheme(GCScheme.BLUE_SCHEME);  
    failed = true;
    dirty = true;
  }
  if (button == nextBTNTest[cur] && event == GEvent.CLICKED) {
    advance_window(cur);
  }
}

public void handleButtonEvents(GButton button, GEvent event) {
  if (button == endBTNTest && event == GEvent.CLICKED) {
    save_report();
    windowTest[cur_window].close(); 
  }
  else if (button == nextBTNName && event == GEvent.CLICKED) {
    testerName = nameNotesTextAreaName.getText();
    serial = nameNotesTextAreaGenerator.getText();
    if (testerName == "") {
      showMsgWindow("Error", "Need To Specify Tester Name.");
    } else if (serial == "") {
      showMsgWindow("Error", "Need To Specify Generator Serial.");
    } else {
      windowName.close();
      buildTestWindow(1);
    }
  }
  else if (button == okBTNErr && event == GEvent.CLICKED) {
    windowErr.close();
  }
  else if (button == nextBTNTest[TEST_NUM-1] && event == GEvent.CLICKED) {
    build_report(TEST_NUM-1);
    save_report();
    windowTest[TEST_NUM-1].close();
  } else {
     check_event(button, event, cur_window); 
  }
}


GWindow windowName;
GButton nextBTNName;
GLabel nameNumberLabelTitleName;
GTextArea nameNotesTextAreaName;
GLabel nameNumberLabelTitleGenerator;
GTextArea nameNotesTextAreaGenerator;


GWindow windowErr;
GButton okBTNErr;
GLabel errLabelMSG;

GWindow windowTest[] = new GWindow[TEST_NUM];
GButton nextBTNTest[] = new GButton[TEST_NUM]; 
GButton endBTNTest;
GLabel testNumberLabelTitleTest[] = new GLabel[TEST_NUM];
GLabel testNumberLabelTest[] = new GLabel[TEST_NUM];
GLabel testNameLabelTitleTest[] = new GLabel[TEST_NUM];
GLabel testNameLabelTest[] = new GLabel[TEST_NUM];
GLabel testConditionsLabelTitleTest[] = new GLabel[TEST_NUM];
GLabel testConditionsLabelTest[] = new GLabel[TEST_NUM];
GLabel testReportLabelTitleTest[] = new GLabel[TEST_NUM];
GLabel testNotesLabelTitleTest[] = new GLabel[TEST_NUM];
GLabel testNotesLabelTest[] = new GLabel[TEST_NUM];
GButton passedTestButtonTest[] = new GButton[TEST_NUM];
GButton failedTestButtonTest[] = new GButton[TEST_NUM];
GTextArea testNotesTextAreaTest[] = new GTextArea[TEST_NUM];



