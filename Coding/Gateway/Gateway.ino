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
String baseUrl = "http://192.168.2.38/smart_community/api/"; 

#define SCK 5, MISO 19, MOSI 27, SS 18, RST 14, DI0 26, BAND 923E6 
SSD1306Wire screen(0x3c, 4, 15);
dw_font_t myfont;

String currentMsg = "- พร้อมใช้งาน -";
String msgTypeLabel = "สถานะระบบ:";
String lastStatus = "Booting...";
String shortIP = "No WiFi", lastWebMsg = "";
int lastRssi = 0;
unsigned long lastBroadcast = 0, lastCommand = 0;

int scrollX = 128; 
unsigned long lastScrollTime = 0;
int scrollSpeed = 25; 
bool needsScrolling = false;
int textPixelWidth = 0;

const uint8_t wifi_icon[] PROGMEM = { 0x3C, 0x42, 0x81, 0x3C, 0x42, 0x18, 0x00, 0x18 };
const uint8_t lora_icon[] PROGMEM = { 0x18, 0x18, 0x00, 0x5A, 0x00, 0xDB, 0x00, 0x7E };

void draw_pixel(int16_t x, int16_t y) { 
  if(x >= 0 && x < 128 && y >= 0 && y < 64) {
    screen.setColor(WHITE); screen.setPixel(x, y); 
  }
}
void clear_pixel(int16_t x, int16_t y) { 
  if(x >= 0 && x < 128 && y >= 0 && y < 64) {
    screen.setColor(BLACK); screen.setPixel(x, y); screen.setColor(WHITE);
  }
}
void updateScreen() {
  screen.clear();
  screen.setColor(WHITE);
  
  if(WiFi.status() == WL_CONNECTED) screen.drawXbm(0, 0, 8, 8, wifi_icon);
  screen.setFont(ArialMT_Plain_10);
  screen.drawString(12, -2, shortIP);
  
  screen.drawRect(46, 0, 36, 11);
  screen.drawString(49, -2, "GATE");
  
  screen.drawXbm(120, 0, 8, 8, lora_icon);
  screen.drawLine(0, 12, 128, 12); 
  screen.drawString(2, 14, msgTypeLabel); 
  if (needsScrolling) {
    dw_font_goto(&myfont, scrollX, 28);
  } else {
    int centerPos = (128 - textPixelWidth) / 2;
    dw_font_goto(&myfont, max(0, centerPos), 28);
  }
  dw_font_print(&myfont, (char*)currentMsg.c_str());
  
  screen.drawLine(0, 52, 128, 52); 
  screen.drawString(2, 53, lastStatus);
  
  if (lastRssi != 0) {
    String sig = String(lastRssi) + " dBm";
    screen.drawString(85, 53, sig);
  }
  
  screen.display();
}

void setNewMessage(String type, String msg) {
  msgTypeLabel = type;
  currentMsg = msg;
  textPixelWidth = currentMsg.length() * 3.5; 
  
  if (textPixelWidth > 120) {
    needsScrolling = true;
    scrollX = 128; 
  } else {
    needsScrolling = false;
  }
  updateScreen();
}

void setup() {
  Serial.begin(115200);
  pinMode(16, OUTPUT); digitalWrite(16, LOW); delay(50); digitalWrite(16, HIGH);
  
  screen.init(); 
  screen.flipScreenVertically();
  
  dw_font_init(&myfont, 128, 64, draw_pixel, clear_pixel);
  dw_font_setfont(&myfont, (dw_font_info_t*)&font_th_sarabun_new_regular20); 

  WiFi.begin(ssid, password);
  for(int i=0; i<20 && WiFi.status() != WL_CONNECTED; i++) { 
      delay(500); lastStatus = "WiFi Connect.."; updateScreen();
  }
  
  if(WiFi.status() == WL_CONNECTED) {
    String ip = WiFi.localIP().toString();
    shortIP = ip.substring(ip.lastIndexOf('.', ip.lastIndexOf('.') - 1));
    lastStatus = "System Ready";
  }

  SPI.begin(5, 19, 27, 18);
  LoRa.setPins(18, 14, 26);
  if (!LoRa.begin(923E6)) { lastStatus = "LoRa Fail"; updateScreen(); while(1); }
  
  LoRa.setSyncWord(0x12);
  LoRa.setSpreadingFactor(12); 
  LoRa.enableCrc();
  
  setNewMessage("สถานะระบบ:", "- รอรับข้อมูล -");
}

void loop() {
  if (needsScrolling && millis() - lastScrollTime > scrollSpeed) {
    scrollX--;
    if (scrollX < -textPixelWidth) {
      scrollX = 128; 
    }
    updateScreen();
    lastScrollTime = millis();
  }

  int packetSize = LoRa.parsePacket();
  if (packetSize) {
    setNewMessage("Alert!", "มีข้อความเข้ามา..."); 
    lastStatus = "Processing..";
    updateScreen();

    String incoming = "";
    while (LoRa.available()) incoming += (char)LoRa.read();
    delay(500); 

    lastRssi = LoRa.packetRssi();
    setNewMessage("ได้รับแจ้งเหตุ:", incoming);
    sendToWeb(incoming, lastRssi);
  }
  
  unsigned long now = millis();
  if (now - lastBroadcast > 5000) { checkBroadcast(); lastBroadcast = now; }
  if (now - lastCommand > 2000) { checkCommand(); lastCommand = now; }
}

void sendToWeb(String msg, int rssi) {
  if(WiFi.status() != WL_CONNECTED) return;
  HTTPClient http;
  String url = baseUrl + "insert_alert.php?msg=" + msg + "&rssi=" + String(rssi);
  url.replace(" ", "%20"); 
  
  http.begin(url);
  int httpCode = http.GET();
  if (httpCode > 0) {
    lastStatus = "DB: Saved OK";
  } else {
    lastStatus = "DB: Error " + String(httpCode);
  }
  http.end();
  if(!needsScrolling) updateScreen(); 
}

void checkBroadcast() {
  if(WiFi.status() != WL_CONNECTED) return;
  HTTPClient http;
  http.begin(baseUrl + "get_message.php");
  
  if (http.GET() == 200) {
    String payload = http.getString(); payload.trim();
    if (payload.length() > 0 && payload != lastWebMsg) {
      lastWebMsg = payload;
      
      LoRa.beginPacket(); 
      LoRa.print("GATEWAY|" + payload); 
      LoRa.endPacket();
      
      lastStatus = "Broadcasted";
      setNewMessage("ส่งประกาศแล้ว:", payload);
    }
  }
  http.end();
}

void checkCommand() {
  if (WiFi.status() != WL_CONNECTED) return;
  HTTPClient http;
  http.begin(baseUrl + "get_pending_commands.php");
  
  if (http.GET() == 200) {
    StaticJsonDocument<256> doc;
    DeserializationError error = deserializeJson(doc, http.getStream());
    
    if (!error && doc["status"] == "has_command") {
      LoRa.beginPacket(); 
      LoRa.print("GATEWAY|จนท. รับเรื่องแล้ว"); 
      LoRa.endPacket();
      
      String node = doc["node_id"].as<String>();
      lastStatus = "ACK to " + node;
      setNewMessage("ตอบกลับไปยัง:", node);
    }
  }
  http.end();
}