#include <Arduino.h>
#include "LoRaWan_APP.h"
#include <Wire.h>
#include "HT_SSD1306Wire.h"
#include "dw_font.h"
#include "font_th_sarabun_new_regular20.h" 
#include <Adafruit_GFX.h>
#include <Adafruit_SH110X.h>

String devID = "NODE-012";
String relayID = "SEARCHING"; 

#define ROT_CLK 2
#define ROT_DT  3
#define ROT_SW  4
#define BUZZER  26
#define LED_PIN 45          

#define VBAT_READ 1
#define VBAT_CTRL 37
#define HB_INTV 40000 
#define RF_FREQ 923000000 

SSD1306Wire dispI(0x3c, 500000, SDA_OLED, SCL_OLED, GEOMETRY_128_64, RST_OLED);
Adafruit_SH1106G dispE(128, 64, &Wire1);
dw_font_t myfont;

const char* menus[] = { 
  "ขอความช่วยเหลือ", 
  "ไฟไหม้ !", 
  "มีผู้บุกรุก/โจร", 
  "เจ็บป่วยฉุกเฉิน", 
  "อุบัติเหตุ/รถชน", 
  "น้ำท่วม", 
  "สัตว์มีพิษ", 
  "ทดสอบระบบ" 
};
const int NUM_MENUS = sizeof(menus) / sizeof(menus[0]);

int menuIdx=0, batPct=0, txtX=10; 
int16_t rssi=0;
int8_t snr=0;
int16_t bestRssi = -160; 

volatile bool rotated=false; 
volatile int lastClk=HIGH;

volatile unsigned long lastRotTime = 0; 
volatile int rotStep = 0;               
const int ROT_DIVIDER = 2; 

unsigned long lastHb=0, scnTmr=0, lastScrl=0, lastChargeStep=0;
bool scnOn=true;
unsigned long ledTimer = 0;
bool ledState = false;
int ledBlinkCount = 0; 

RTC_DATA_ATTR int savedBatPct = -1; 

enum { LOCKED, IDLE, MENU, SEND } mode = LOCKED;
int unlockProgress = 0;       
const int UNLOCK_LIMIT = 8;   

String msg = ""; 
String senderName = ""; 

int rawDebug = 0; 

static RadioEvents_t RadioEvents;
void OnRxDone(uint8_t *payload, uint16_t size, int16_t rssi, int8_t snr);
void OnTxDone(); void OnTxTimeout();

void triggerLed(int count) {
  ledBlinkCount = count * 2; ledTimer = millis(); ledState = true; digitalWrite(LED_PIN, HIGH);
}

void handleLed() {
  if (ledBlinkCount > 0 && millis() - ledTimer > 100) { 
    ledTimer = millis(); ledState = !ledState; digitalWrite(LED_PIN, ledState ? HIGH : LOW); ledBlinkCount--;
  } else if (ledBlinkCount == 0) { digitalWrite(LED_PIN, LOW); }
}

void beep(int n, int d) { for(int i=0;i<n;i++) { digitalWrite(BUZZER, HIGH); delay(d); digitalWrite(BUZZER, LOW); if(n>1) delay(100); } }
void sosSound() { for(int i=0;i<3;i++) { digitalWrite(BUZZER, HIGH); delay(100); digitalWrite(BUZZER, LOW); delay(50); } }
void drawP(int16_t x, int16_t y) { dispE.drawPixel(x, y, SH110X_WHITE); }
void clrP(int16_t x, int16_t y) { dispE.drawPixel(x, y, SH110X_BLACK); }

int getBat() {
  pinMode(VBAT_CTRL, OUTPUT); digitalWrite(VBAT_CTRL, HIGH); delay(20);
  uint32_t raw = 0; for(int i=0; i<20; i++) raw += analogRead(VBAT_READ);
  digitalWrite(VBAT_CTRL, LOW);
  uint32_t avgRaw = raw / 20;

  rawDebug = avgRaw;

  if (avgRaw >= 1050) {
      return 100;
  }

  int pct = constrain(map(avgRaw, 800, 890, 0, 100), 0, 100);
  
  return pct;
}

void wake() {
  if(!scnOn) { dispI.displayOn(); dispE.oled_command(SH110X_DISPLAYON); scnOn=true; }
  scnTmr = millis();
}

void updDispI() {
  if(!scnOn) return;
  dispI.clear();
  dispI.setFont(ArialMT_Plain_16); 
  dispI.setTextAlignment(TEXT_ALIGN_LEFT);
  dispI.drawString(0, 0, devID);
  
  dispI.setTextAlignment(TEXT_ALIGN_RIGHT);
  if (rawDebug >= 1050) {
      dispI.drawString(128, 0, "CHARGING");
  } else {
      dispI.drawString(128, 0, String(batPct) + "%");
  }
  
  dispI.drawLine(0, 18, 128, 18);
  dispI.setFont(ArialMT_Plain_10); 
  dispI.setTextAlignment(TEXT_ALIGN_LEFT);
  String relaySt = (relayID == "SEARCHING") ? "Scanning..." : relayID;
  dispI.drawString(0, 22, "Relay: " + relaySt); 
  dispI.drawString(0, 34, "RSSI: " + String(rssi) + "  SNR: " + String(snr));
  
  String modeStr = "IDLE";
  if(mode == LOCKED) modeStr = "LOCKED";
  else if(mode == MENU) modeStr = "MENU";
  else if(mode == SEND) modeStr = "SENDING";
  dispI.drawString(0, 46, "Mode: " + modeStr);
  
  unsigned long s = millis() / 1000;
  dispI.drawString(0, 56, "Up: " + String(s/60) + "m " + String(s%60) + "s");
  dispI.display();
}

void updDispE() {
  if(!scnOn) return;
  dispE.clearDisplay(); 
  dispE.setTextSize(1); dispE.setTextColor(SH110X_WHITE);
  
  if(mode == LOCKED) {
    dispE.setCursor(0, 0); dispE.print(devID);
    
    if (rawDebug >= 1050) {
        dispE.setCursor(70, 0); 
        dispE.print("CHARGING");
    } else {
        dispE.setCursor(55, 0); 
        dispE.print(String(batPct) + "% (" + String(rawDebug) + ")");
    }
    
    dispE.drawLine(0, 10, 128, 10, SH110X_WHITE);
    dispE.setCursor(45, 15); dispE.print("LOCKED");
    dispE.drawRect(14, 30, 100, 10, SH110X_WHITE);
    int barW = map(unlockProgress, 0, UNLOCK_LIMIT, 0, 96);
    dispE.fillRect(16, 32, barW, 6, SH110X_WHITE);
    dispE.setCursor(25, 50); dispE.print("Turn to Unlock");
  }
  else if(mode == MENU) {
    dispE.setCursor(35, 0); dispE.print("-- MENU --");
    dispE.setCursor(0, 30); dispE.print("<"); 
    dispE.setCursor(120, 30); dispE.print(">");
    dw_font_goto(&myfont, 15, 35); 
    dw_font_print(&myfont, (char*)menus[menuIdx]);
  } 
  else if(mode == SEND) {
    dispE.setCursor(30, 20); dispE.print("SENDING...");
    dispE.drawRect(24, 40, 80, 8, SH110X_WHITE);
    dispE.fillRect(26, 42, (millis()/30)%78, 4, SH110X_WHITE);
  } 
  else {
    if (senderName != "") {
        dispE.setCursor(0, 10); 
        dispE.print("FROM: " + senderName); 
    } else {
        dispE.setCursor(0, 10); 
        dispE.print("MESSAGE:");
    }
    
    dispE.drawLine(0, 24, 128, 24, SH110X_WHITE);
    
    if (msg == "") {
        dispE.setCursor(35, 40); 
        dispE.print("- STANDBY -");
    } else {
        dw_font_goto(&myfont, txtX, 48); 
        dw_font_print(&myfont, (char*)msg.c_str());
    }
    
    dispE.drawLine(0, 54, 128, 54, SH110X_WHITE);
    dispE.setCursor(5, 56); dispE.print(devID);
  }
  dispE.display();
}
void updAll() { updDispI(); updDispE(); }

void IRAM_ATTR isr() {
  int clk = digitalRead(ROT_CLK);
  unsigned long now = millis();
  if(clk != lastClk && clk == LOW) {
    if (now - lastRotTime > 30) { 
        if(digitalRead(ROT_DT) == LOW) { 
           rotStep++; 
        } else { 
           rotStep--; 
        }
        if (rotStep >= ROT_DIVIDER) {
           if(mode == LOCKED) unlockProgress = min(unlockProgress + 1, UNLOCK_LIMIT);
           else menuIdx = (menuIdx + 1) % NUM_MENUS;
           rotStep = 0; rotated = true;
        } 
        else if (rotStep <= -ROT_DIVIDER) {
           if(mode == LOCKED) unlockProgress = max(unlockProgress - 1, 0);
           else menuIdx = (menuIdx == 0) ? (NUM_MENUS - 1) : menuIdx - 1; 
           rotStep = 0; rotated = true;
        }
        lastRotTime = now;
    }
  }
  lastClk = clk;
}

void setup() {
  Serial.begin(115200);
  pinMode(ROT_CLK, INPUT_PULLUP); pinMode(ROT_DT, INPUT_PULLUP); pinMode(ROT_SW, INPUT_PULLUP);
  pinMode(BUZZER, OUTPUT); digitalWrite(BUZZER, LOW);
  pinMode(LED_PIN, OUTPUT); digitalWrite(LED_PIN, LOW); 
  attachInterrupt(digitalPinToInterrupt(ROT_CLK), isr, CHANGE);
  analogReadResolution(12);
  pinMode(Vext, OUTPUT); digitalWrite(Vext, LOW); delay(100); 
  pinMode(RST_OLED, OUTPUT); digitalWrite(RST_OLED, LOW); delay(20); digitalWrite(RST_OLED, HIGH); delay(50);
  dispI.init(); dispI.flipScreenVertically();
  Wire1.begin(41, 42); dispE.begin(0x3C, true); dispE.setRotation(0); dispE.display(); delay(500);
  dw_font_init(&myfont, 128, 64, drawP, clrP);
  dw_font_setfont(&myfont, (dw_font_info_t*)&font_th_sarabun_new_regular20);
  Mcu.begin(HELTEC_BOARD, SLOW_CLK_TPYE);
  RadioEvents.RxDone = OnRxDone; RadioEvents.TxDone = OnTxDone; RadioEvents.TxTimeout = OnTxTimeout;
  Radio.Init(&RadioEvents); Radio.SetChannel(RF_FREQ);
  Radio.SetTxConfig(MODEM_LORA, 22, 0, 0, 12, 1, 8, false, true, 0, 0, false, 5000);
  Radio.SetRxConfig(MODEM_LORA, 0, 12, 1, 0, 8, 0, false, 0, true, 0, 0, false, true);
  Radio.Rx(0);
  
  int currentRawBat = getBat();
  if (savedBatPct >= 0 && savedBatPct <= 100) {
      if (currentRawBat >= 95 && savedBatPct < 90) { batPct = savedBatPct; } 
      else { batPct = currentRawBat; }
  } else { batPct = currentRawBat; }
  savedBatPct = batPct; 

  String hello = devID + "|HELLO|Node ถูกเปิดใช้งานแล้ว";
  Radio.Send((uint8_t*)hello.c_str(), hello.length());
  wake(); updAll();
}

void loop() {
  Radio.IrqProcess();
  unsigned long now = millis();
  handleLed(); 
  if (now - lastChargeStep > 5000) { 
      lastChargeStep = now;
      int rawBat = getBat();
      if (batPct != rawBat) { batPct = rawBat; savedBatPct = batPct; if (scnOn) updDispI(); }
  }
  if(now - lastHb > HB_INTV) {
    lastHb = now;
    String target = (relayID == "SEARCHING") ? "ALL" : relayID;
    String pkt = devID + "|" + String(batPct) + "|STATUS|Via:" + target;
    Radio.Send((uint8_t*)pkt.c_str(), pkt.length());
  }
  if(rotated) { rotated = false; wake(); if(mode == LOCKED && unlockProgress >= UNLOCK_LIMIT) { mode = IDLE; beep(2, 50); unlockProgress = 0; } updDispE(); }
  
  if(digitalRead(ROT_SW) == LOW) {
    wake(); unsigned long pStart = millis(); bool sosTriggered = false;
    while(digitalRead(ROT_SW) == LOW) {
      unsigned long holdTime = millis() - pStart;
      if (mode != SEND) {
        dispE.clearDisplay(); 
        dispE.setTextSize(1); dispE.setCursor(25, 5); dispE.print("HOLD FOR SOS");
        dispE.drawRect(14, 25, 100, 15, SH110X_WHITE);
        int barW = map(min((int)holdTime, 5000), 0, 5000, 0, 96);
        dispE.fillRect(16, 27, barW, 11, SH110X_WHITE);
        
        dispE.setTextSize(2); 
        if (holdTime < 5000) {
            dispE.setCursor(55, 45); 
            dispE.print(String((5000-holdTime)/1000 + 1)); 
        } else {
            dispE.setCursor(20, 45); 
            dispE.print("SENT!"); 
        }
        dispE.display();
        
        if(holdTime > 5000 && !sosTriggered) {
          sosTriggered = true; mode = SEND; sosSound(); 
          msg = "!! SOS ฉุกเฉิน !!"; senderName = ""; 
          updAll(); digitalWrite(LED_PIN, HIGH);
          String target = (relayID == "SEARCHING") ? "ALL" : relayID;
          String pkt = devID + "|" + String(batPct) + "|SOS ขอความช่วยเหลือด่วน|Via:" + target;
          Radio.Send((uint8_t*)pkt.c_str(), pkt.length());
          break; 
        }
      }
      delay(20);
    }
    if(!sosTriggered && (millis() - pStart > 50)) {
       if(mode == LOCKED) { beep(1, 20); updDispE(); }
       else if(mode == IDLE) { mode = MENU; beep(1, 50); updDispE(); }
       else if(mode == MENU) {
          mode = SEND; beep(1, 200); digitalWrite(LED_PIN, HIGH);
          String target = (relayID == "SEARCHING") ? "ALL" : relayID;
          String pkt = devID + "|" + String(batPct) + "|" + String(menus[menuIdx]) + "|Via:" + target;
          Radio.Send((uint8_t*)pkt.c_str(), pkt.length());
          msg = "กำลังส่ง..."; senderName = ""; updAll();
       }
    }
    if(!sosTriggered && mode != LOCKED) updDispE(); 
  }

  if(scnOn && (now - scnTmr > 15000)) { 
    dispI.displayOff(); dispE.oled_command(SH110X_DISPLAYOFF); 
    scnOn = false; mode = LOCKED; unlockProgress = 0; msg = ""; senderName = ""; 
  }
  if(scnOn && mode == IDLE && (now - lastScrl > 30)) { txtX -= 2; if(txtX < -300) txtX = 128; lastScrl = now; updDispE(); }
}

void OnRxDone(uint8_t *pl, uint16_t sz, int16_t rs, int8_t sn) {
  char b[255]; memcpy(b, pl, sz); b[sz]='\0'; String in(b);
  int p1 = in.indexOf('|');
  int p2 = in.indexOf('|', p1 + 1);
  int p3 = in.lastIndexOf('|');

  String senderID = "";
  String content = "";
  if (p1 != -1) senderID = in.substring(0, p1); 
  if (senderID == devID) { Radio.Rx(0); return; }

  if (p2 != -1 && p3 != -1 && p3 > p2) content = in.substring(p2 + 1, p3);
  else if (p1 != -1) content = in.substring(p1 + 1); 
  content.trim();

  String displayName = senderID; 
  if (content.indexOf("SOS") != -1) { 
      if (senderID == "NODE-001") displayName = "HOUSE 1";
      else if (senderID == "NODE-012") displayName = "HOUSE 2";
      else if (senderID == "NODE-003") displayName = "HOUSE 3";
  }

  if (senderID.startsWith("NODE-") && (rs > bestRssi || relayID == "SEARCHING")) {
      bestRssi = rs; relayID = senderID; 
  }
  if(in.indexOf("STATUS") != -1) { Radio.Rx(0); return; } 

  if(content.length() == 0 || content == msg) { Radio.Rx(0); return; }
  triggerLed(5); wake(); 
  msg = content; senderName = displayName; 
  txtX = 128; mode = IDLE; rssi = rs; snr = sn;
  if(in.indexOf("ACK")!=-1 || in.indexOf("รับเรื่อง")!=-1) beep(3, 100); else beep(1, 100);
  updAll(); Radio.Rx(0);
}

void OnTxDone() { 
  digitalWrite(LED_PIN, LOW); 
  if(mode == SEND) { mode = IDLE; wake(); msg = "ส่งข้อมูลแล้ว"; senderName = ""; updAll(); } 
  Radio.Rx(0); 
}

void OnTxTimeout() { 
  digitalWrite(LED_PIN, LOW); 
  if(mode == SEND) { 
      mode = IDLE; wake(); msg = "ส่งไม่สำเร็จ"; senderName = "";
      relayID = "SEARCHING"; bestRssi = -160;
      beep(1, 500); updAll(); 
  } 
  Radio.Rx(0); 
}