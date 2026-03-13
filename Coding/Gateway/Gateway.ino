#include <SPI.h>
#include <LoRa.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <Wire.h>
#include <ArduinoJson.h> 
#include "SSD1306Wire.h" 
#include "dw_font.h"       
#include "font_th_sarabun_new_regular30.h" 

const char* ssid = "both2g";
const char* password = "both2509"; 
String baseUrl = "http://192.168.2.35/smart_community/api/"; 

#define LED_PIN 45  
#define SCK 5
#define MISO 19
#define MOSI 27
#define SS 18
#define RST 14
#define DI0 26
#define BAND 923E6 

SSD1306Wire screen(0x3c, 4, 15);
dw_font_t myfont;

String currentMsg = "- พร้อมใช้งาน -";
String msgTypeLabel = "สถานะระบบ:";
String lastStatus = "Booting...";
String lastWebMsg = "";
int lastRssi = 0;

unsigned long lastBroadcast = 0, lastCommand = 0, lastGatewayHb = 0; 
unsigned long lastScrollTime = 0;

// 🌟 ตัวแปรใหม่สำหรับตั้งเวลาเคลียร์หน้าจอ
unsigned long lastMsgTime = 0;
const unsigned long DISPLAY_TIMEOUT = 10000; // ตั้งเวลาโชว์ข้อความ 10 วินาที (10000 ms)
bool isDisplayingAlert = false;

bool isFirstRun = true; 
bool xampp_active = true; 

unsigned long ledTimer = 0;
bool ledState = false;
int ledBlinkCount = 0;

int scrollX = 128; 
int scrollSpeed = 10; 
bool needsScrolling = false;
int textPixelWidth = 0;

const uint8_t wifi_icon[] PROGMEM = { 0x3C, 0x42, 0x81, 0x3C, 0x42, 0x18, 0x00, 0x18 };
const uint8_t lora_icon[] PROGMEM = { 0x18, 0x18, 0x00, 0x5A, 0x00, 0xDB, 0x00, 0x7E };

String getHouseNumber(String nodeID) {
  if (nodeID == "NODE-001") return "HOME: 234/1";
  if (nodeID == "NODE-012") return "HOME: 233/2";
  return nodeID; 
}

void triggerLed(int count) { ledBlinkCount = count * 2; ledTimer = millis(); ledState = true; digitalWrite(LED_PIN, HIGH); }
void handleLed() {
  if (ledBlinkCount > 0 && millis() - ledTimer > 100) {
    ledTimer = millis(); ledState = !ledState;
    digitalWrite(LED_PIN, ledState ? HIGH : LOW); ledBlinkCount--;
  }
}

void draw_pixel(int16_t x, int16_t y) { if(x >= 0 && x < 128 && y >= 0 && y < 64) { screen.setColor(WHITE); screen.setPixel(x, y); } }
void clear_pixel(int16_t x, int16_t y) { if(x >= 0 && x < 128 && y >= 0 && y < 64) { screen.setColor(BLACK); screen.setPixel(x, y); screen.setColor(WHITE); } }

void updateScreen() {
  screen.clear();
  screen.setColor(WHITE);
  if(WiFi.status() == WL_CONNECTED) {
    screen.drawXbm(0, 2, 8, 8, wifi_icon);
    screen.setFont(ArialMT_Plain_10);
    screen.drawString(10, -1, "ONLINE");
  } else { 
    screen.drawString(0, -1, "OFFLINE"); 
  }
  
  screen.drawRect(48, 0, 32, 12); screen.drawString(52, -1, "HUB");
  screen.drawXbm(118, 2, 8, 8, lora_icon);
  screen.drawLine(0, 14, 128, 14); 

  screen.drawRect(0, 18, 128, 32); 
  screen.setFont(ArialMT_Plain_10);
  screen.drawString(4, 19, msgTypeLabel);

  if (needsScrolling) {
      dw_font_goto(&myfont, scrollX, 40); 
  } else { 
      int centerPos = (128 - textPixelWidth) / 2; 
      dw_font_goto(&myfont, max(4, centerPos), 40); 
  }
  dw_font_print(&myfont, (char*)currentMsg.c_str());

  screen.drawLine(0, 52, 128, 52); 
  screen.setFont(ArialMT_Plain_10);
  screen.drawString(0, 53, lastStatus); 
  screen.setTextAlignment(TEXT_ALIGN_RIGHT);
  screen.drawString(128, 53, "UP: " + String(millis()/60000) + "m");
  screen.setTextAlignment(TEXT_ALIGN_LEFT);
  screen.display();
}

void setNewMessage(String type, String msg) {
  msgTypeLabel = type; currentMsg = msg;
  textPixelWidth = currentMsg.length() * 6; 
  if (textPixelWidth > 120) {
      needsScrolling = true; 
      scrollX = 128; 
  } else {
      needsScrolling = false;
      scrollX = 128;
  }
  updateScreen();
}

void handleXamppFail() {
  if (xampp_active) {
      xampp_active = false;
      lastStatus = "Server Offline";
      updateScreen();
  }
}

String urlEncode(String str) {
  String encodedString = "";
  char c, code0, code1;
  for (int i = 0; i < str.length(); i++) {
    c = str.charAt(i);
    if (isalnum(c)) encodedString += c;
    else if (c == ' ') encodedString += '+';
    else {
      code1 = (c & 0xf) + '0'; if ((c & 0xf) > 9) code1 = (c & 0xf) - 10 + 'A';
      c = (c >> 4) & 0xf; code0 = c + '0'; if (c > 9) code0 = c - 10 + 'A';
      encodedString += '%'; encodedString += code0; encodedString += code1;
    }
  }
  return encodedString;
}

void setup() {
  Serial.begin(115200);
  delay(1000); 

  pinMode(16, OUTPUT); digitalWrite(16, LOW); delay(50); digitalWrite(16, HIGH);
  pinMode(LED_PIN, OUTPUT); digitalWrite(LED_PIN, LOW); 
  
  screen.init(); screen.flipScreenVertically();
  dw_font_init(&myfont, 128, 64, draw_pixel, clear_pixel);
  dw_font_setfont(&myfont, (dw_font_info_t*)&font_th_sarabun_new_regular20); 
  
  WiFi.begin(ssid, password);
  int wifi_attempts = 0;
  while(WiFi.status() != WL_CONNECTED && wifi_attempts < 20) { 
    delay(500); 
    lastStatus = "WiFi Connecting..."; 
    updateScreen(); 
    wifi_attempts++;
  }

  if(WiFi.status() == WL_CONNECTED) {
    lastStatus = "WiFi OK";
  } else {
    lastStatus = "LoRa Only Mode";
    xampp_active = false;
  }
  
  setNewMessage("สถานะระบบ:", "- พร้อมรับข้อมูล -");
  delay(1000);

  SPI.begin(SCK, MISO, MOSI, SS); LoRa.setPins(SS, RST, DI0);
  if (!LoRa.begin(BAND)) { Serial.println("LoRa Fail"); while(1); }
  
  LoRa.setSyncWord(0x12); 
  LoRa.setSpreadingFactor(7); 
  LoRa.setSignalBandwidth(125E3); 
  LoRa.setCodingRate4(5);        
  LoRa.enableCrc();
}

void loop() {
  handleLed(); 
  
  if (needsScrolling && millis() - lastScrollTime > scrollSpeed) {
    scrollX--; 
    if (scrollX < -textPixelWidth) scrollX = 128; 
    updateScreen(); 
    lastScrollTime = millis();
  }

  int packetSize = LoRa.parsePacket();
  if (packetSize) {
    String incoming = "";
    while (LoRa.available()) incoming += (char)LoRa.read();
    int rssi = LoRa.packetRssi();

    if (incoming.indexOf("NODE-") == -1) return; 
    triggerLed(5); 

    int p1 = incoming.indexOf('|'), p2 = incoming.indexOf('|', p1 + 1), p3 = incoming.lastIndexOf('|');
    if (p1 != -1 && p2 != -1) {
      String n_id = incoming.substring(0, p1);
      float batFloat = incoming.substring(p1 + 1, p2).toFloat(); 
      String n_bat = String((int)batFloat); 
      String n_msg = (p3 > p2) ? incoming.substring(p2 + 1, p3) : incoming.substring(p2 + 1);
      n_msg.trim();

      String houseNo = getHouseNumber(n_id);
      lastMsgTime = millis();
      isDisplayingAlert = true;

      setNewMessage(houseNo, "> " + n_msg + " (แบต " + n_bat + "%)");
      lastRssi = rssi;

      if(WiFi.status() == WL_CONNECTED) {
        lastStatus = "Web Syncing..";
        updateScreen(); 
        
        HTTPClient http;
        http.setTimeout(1000); 
        String url = baseUrl + "insert_alert.php?node_id=" + n_id + "&battery=" 
        + n_bat + "&msg=" + urlEncode(n_msg) + "&rssi=" + String(rssi);
        http.begin(url);
        int code = http.GET();
        if (code > 0) {
            lastStatus = "Saved OK";
            xampp_active = true;
        } else {
            handleXamppFail(); 
        }
        http.end();
        updateScreen();
      } else {
        lastStatus = "LoRa RX (No Web)"; 
        updateScreen();
      }
    }
  }
  
  unsigned long now = millis();

  if (isDisplayingAlert && (now - lastMsgTime > DISPLAY_TIMEOUT)) {
      isDisplayingAlert = false;
      setNewMessage("สถานะระบบ:", "- พร้อมรับข้อมูล -");
      if(WiFi.status() == WL_CONNECTED) {
          lastStatus = "System Ready";
      } else {
          lastStatus = "LoRa Only Mode";
      }
      updateScreen();
  }
  
  if (WiFi.status() == WL_CONNECTED) {
      
      if (now - lastGatewayHb > 60000 || lastGatewayHb == 0) {
        lastGatewayHb = now;
        HTTPClient http;
        http.setTimeout(1000); 
        http.begin(baseUrl + "insert_alert.php?node_id=GATEWAY-MAIN&battery=100&msg=STATUS&rssi=0");
        int code = http.GET();
        if (code > 0) {
            xampp_active = true; 
            if(lastStatus == "Server Offline") {
                lastStatus = "System Ready";
                updateScreen();
            }
        } else {
            handleXamppFail();
        }
        http.end();
      }
      
      if (xampp_active) {
          if (now - lastBroadcast > 5000) { checkBroadcast(); lastBroadcast = now; }
          if (now - lastCommand > 2000) { checkCommand(); lastCommand = now; }
      }
  }
}

void checkBroadcast() {
  HTTPClient http;
  http.setTimeout(1000); 
  http.begin(baseUrl + "get_message.php");
  int httpCode = http.GET();
  
  if (httpCode == 200) {
    String payload = http.getString(); 
    payload.trim();
    payload.replace("|", " "); 
    
    if (payload.length() > 0 && payload != lastWebMsg) {
      if (isFirstRun) { 
        lastWebMsg = payload; isFirstRun = false; 
        lastStatus = "System Ready"; updateScreen();
      } else {
        lastWebMsg = payload;
        digitalWrite(LED_PIN, HIGH); 
        LoRa.beginPacket(); LoRa.print("GATEWAY|100|" + payload + "|ALL"); LoRa.endPacket(); 
        digitalWrite(LED_PIN, LOW); 
        lastStatus = "Broadcasted"; 
        lastMsgTime = millis();
        isDisplayingAlert = true;
        setNewMessage("ประกาศจากส่วนกลาง:", payload); 
      }
    }
  } else if (httpCode < 0) {
     handleXamppFail(); 
  }
  http.end();
}

void checkCommand() {
  HTTPClient http;
  http.setTimeout(1000); 
  http.begin(baseUrl + "get_pending_commands.php");
  int httpCode = http.GET();
  if (httpCode == 200) {
    StaticJsonDocument<256> doc;
    if (!deserializeJson(doc, http.getStream()) && doc["status"] == "has_command") {
      digitalWrite(LED_PIN, HIGH); 
      LoRa.beginPacket(); LoRa.print("GATEWAY|100|จนท. รับเรื่องแล้ว|ALL"); LoRa.endPacket(); 
      digitalWrite(LED_PIN, LOW); 
      String node = doc["node_id"].as<String>();
      
      String houseNo = getHouseNumber(node); 
      lastStatus = "ACK sent"; 
      lastMsgTime = millis();
      isDisplayingAlert = true;
      setNewMessage("ตอบกลับ:", houseNo);
    }
  } else if (httpCode < 0) {
     handleXamppFail();
  }
  http.end();
}