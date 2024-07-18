#define BLYNK_TEMPLATE_ID "TMPL6C9csyZqQ"
#define BLYNK_TEMPLATE_NAME "tinggidanvolume"
#define BLYNK_AUTH_TOKEN "WvqJ40J735aUgczynp3WH6N5GeanLyBC"
#define BLYNK_PRINT Serial
#include <WiFi.h>
#include <BlynkSimpleEsp32.h>
#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x27, 16, 2);

char auth[] = BLYNK_AUTH_TOKEN;
char ssid[] = "HAN";
char pass[] = "Pranandipt4";

BlynkTimer timer;

#define echoPin 12 // Pin Echo
#define trigPin 13 // Pin Trigger

long duration;
float jarak;

float tinggiWadah = 6.27; // Tinggi wadah (jarak dasar dengan sensor) dalam cm
float lebarWadah = 20; // Lebar wadah dalam cm
float panjangWadah = 30; // Panjang wadah dalam cm
float luasAlaswadah = 25.25; // Panjang wadah dalam cm2
float tinggiAir;
float volume;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Blynk.begin(auth, ssid, pass, "blynk.cloud", 80);
  lcd.begin();
  lcd.backlight();
}

void loop() {
   Serial.begin(115200); // Baudrate komunikasi dengan serial monitor
   // Mengukur jarak dengan sensor ultrasonik
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  jarak = duration * 0.034 / 2; //konversi ke jarak sebenarnya (cm)

  // Menghitung volume wadah air (disesuaikan dengan karakteristik wadah Anda)
  tinggiAir = tinggiWadah - jarak;
  volume = tinggiAir * luasAlaswadah;

  // Menampilkan hasil di LCD
  lcd.setCursor(0, 0);
  lcd.print("T air:");
  lcd.print(tinggiAir);
  lcd.print(" cm");
  lcd.setCursor(0, 1);
  lcd.print("V air:");
  lcd.print(volume);
  lcd.print(" ml");

  Blynk.run();
  timer.run();
  Blynk.virtualWrite(V0, tinggiAir);
  Blynk.virtualWrite(V1, volume);
  delay(1000);
}
