#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <TimeLib.h>
#include <WiFiUdp.h>
#include <DHT.h> // Include the DHT library

// Wi-Fi credentials
const char* ssid = "FUTRA_UP2B"; // replace with your Wi-Fi SSID
const char* password = "dothebest"; // replace with your Wi-Fi password

// Firebase Realtime Database
const char* firebaseHost = "up2btangki-default-rtdb.asia-southeast1.firebasedatabase.app"; // Firebase host without "https://"
const char* firebaseAuth = "16PpVFU8xxWU0uiy0mUfQWXIwr51BLt0UySuIpMF";

FirebaseData firebaseData;
FirebaseConfig firebaseConfig;
FirebaseAuth auth;

LiquidCrystal_I2C lcd(0x27, 16, 2);

// DHT11 sensor
#define DHTPIN 4 // Pin connected to the DHT11 sensor
#define DHTTYPE DHT11 // Define the sensor type

DHT dht(DHTPIN, DHTTYPE);

// KY-037 sensor
#define SOUND_SENSOR_PIN 34 // Analog pin connected to KY-037 sensor

#define echoPin 12 // Pin Echo
#define trigPin 13 // Pin Trigger

long duration;
float jarak;

float tinggiWadah = 115; // Tinggi wadah (jarak dasar dengan sensor) dalam cm
float lebarWadah = 80; // Lebar wadah dalam cm
float panjangWadah = 120; // Panjang wadah dalam cm
float luasAlaswadah = 9600; // Luas alas wadah dalam cm2
float tinggiAir;
float volume;
float volumeLiter;

unsigned long lastFailTime = 0; // Time of the last failed attempt
const unsigned long failDurationLimit = 60000; // 1 minute in milliseconds

int initialVolume = -1;
int finalVolume = -1;

const int timeZone = 7; // Time zone offset for GMT+7

WiFiUDP ntpUDP;

void setup() {
  Serial.begin(115200); // Baudrate komunikasi dengan serial monitor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  lcd.init();
  lcd.backlight();

  // Initialize DHT sensor
  dht.begin();

  // Initialize KY-037 sensor pin
  pinMode(SOUND_SENSOR_PIN, INPUT);

  // Connect to Wi-Fi
  connectWiFi();

  // Initialize Firebase
  firebaseConfig.host = firebaseHost;
  firebaseConfig.signer.tokens.legacy_token = firebaseAuth;
  Firebase.begin(&firebaseConfig, &auth);
  Firebase.reconnectWiFi(true);

  // Synchronize time from NTP server
  configTime(timeZone * 3600, 0, "pool.ntp.org");
  if (!syncTime()) {
    Serial.println("Failed to synchronize time with NTP server");
  }
}

void loop() {
  // Update time
  time_t now = time(nullptr);
  struct tm *localTime = localtime(&now);

  // Mengukur jarak dengan sensor ultrasonik
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  jarak = duration * 0.034 / 2; // Konversi ke jarak sebenarnya (cm)

  // Menghitung volume wadah air (disesuaikan dengan karakteristik wadah Anda)
  tinggiAir = tinggiWadah - jarak;
  volume = tinggiAir * luasAlaswadah;
  volumeLiter = volume / 1000.0; // Konversi volume dari ml ke liter

  // Membulatkan volumeLiter menjadi dua angka desimal
  // float roundedVolumeLiter = round(volumeLiter * 100.0) / 100.0;

  // Read temperature and humidity from DHT11
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  // Read sound level from KY-037
  int soundLevel = analogRead(SOUND_SENSOR_PIN);

  // Convert roundedVolumeLiter to an int
  int volumeLiterInt = static_cast<int>(volumeLiter);
  int tinggiAirInt = static_cast<int>(tinggiAir);

  // Print sensor readings to Serial Monitor
  // Serial.print("Temperature: ");
  // Serial.print(temperature);
  // Serial.println(" C");

  // Serial.print("Humidity: ");
  // Serial.print(humidity);
  // Serial.println(" %");

  Serial.print("Sound Level: ");
  Serial.println(soundLevel);

  // Display results on LCD
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("T air:");
  lcd.print(tinggiAirInt);
  lcd.print(" cm");
  lcd.setCursor(0, 1);
  lcd.print("V air:");
  lcd.print(volumeLiterInt); // Menampilkan volume dalam liter dengan 2 decimal places
  lcd.print(" L");

  // Upload rounded volume liter to Firebase
  String path = "/fuelinformation/tankVolume"; // Your desired path in Firebase
  if (Firebase.setFloat(firebaseData, path.c_str(), volumeLiter)) {
    // Serial.println("Volume data uploaded to Firebase");
    lastFailTime = 0; // Reset the fail time on successful upload
  } else {
    Serial.print("Failed to upload volume data to Firebase: ");
    Serial.println(firebaseData.errorReason());

    if (lastFailTime == 0) {
      lastFailTime = millis(); // Set the time of the first failure
    } else if (millis() - lastFailTime > failDurationLimit) {
      // Reconnect to Wi-Fi if failures exceed the limit
      connectWiFi();
      lastFailTime = 0; // Reset the fail time after reconnection attempt
    }
  }

  // Upload temperature to Firebase
  String tempPath = "/fuelinformation/temperature"; // Your desired path in Firebase
  if (Firebase.setFloat(firebaseData, tempPath.c_str(), temperature)) {
    // Serial.println("Temperature data uploaded to Firebase");
    lastFailTime = 0; // Reset the fail time on successful upload
  } else {
    Serial.print("Failed to upload temperature data to Firebase: ");
    Serial.println(firebaseData.errorReason());

    if (lastFailTime == 0) {
      lastFailTime = millis(); // Set the time of the first failure
    } else if (millis() - lastFailTime > failDurationLimit) {
      // Reconnect to Wi-Fi if failures exceed the limit
      connectWiFi();
      lastFailTime = 0; // Reset the fail time after reconnection attempt
    }
  }



  // Check for initial and final volume recording times
  int currentHour = localTime->tm_hour;
  int currentMinute = localTime->tm_min;
  int currentSecond = localTime->tm_sec;

  // Extract the date from the current time
  char dateKey[11]; // Buffer to hold the formatted date string
  snprintf(dateKey, sizeof(dateKey), "%04d_%02d_%02d",
           localTime->tm_year + 1900, localTime->tm_mon + 1, localTime->tm_mday);

    // Set initialVolume at midnight (00:00:01)
  if (initialVolume == -1 || (currentHour == 1 && currentMinute == 0)) {
    initialVolume = volumeLiterInt;
    String initialPath = "/fuelinformation/zhistory/" + String(dateKey) + "/awal";
    Firebase.setInt(firebaseData, initialPath, initialVolume);
    Serial.print("New Day Initial Volume set: ");
    Serial.println(initialVolume);
  }

  // If it's 9:00:00 AM, set finalVolume and calculate difference
  if (currentHour == 23 && currentMinute == 00 &&  finalVolume == -1) {
    finalVolume = volumeLiterInt;
    String finalPath = "/fuelinformation/zhistory/" + String(dateKey) + "/akhir";
    Firebase.setInt(firebaseData, finalPath, finalVolume);
    Serial.print("Final Volume at 9:00 AM: ");
    Serial.println(finalVolume);

    // Calculate the difference between initial and final volumes
    int volumeDifference = initialVolume - finalVolume;
    String diffPath = "/fuelinformation/zhistory/" + String(dateKey) + "/konsum";
    Firebase.setInt(firebaseData, diffPath, volumeDifference);
    Serial.print("Volume Difference: ");
    Serial.println(volumeDifference);

  }
  // Reset finalVolume for the next day's calculation
  if (currentHour == 0 && currentMinute == 5) {
    initialVolume = -1;
    finalVolume = -1;
  }
  delay(3000);
}

void connectWiFi() {
  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wi-Fi");
   //----------
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("FUTRA UP2B Jatim");
  lcd.setCursor(0, 1);
  lcd.print("Connecting Wi-Fi");
  lcd.clear();
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println();
  Serial.println("Connected to Wi-Fi");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
  //----------
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Connected Wifi");
  lcd.setCursor(0, 1);
  lcd.print("IP");
  lcd.print(WiFi.localIP());
}

bool syncTime() {
  configTime(timeZone * 3600, 0, "pool.ntp.org");
  time_t now = time(nullptr);
  int retry = 0;
  const int retryCount = 10;
  while (now < 8 * 3600 * 2 && retry < retryCount) {
    delay(1000);
    now = time(nullptr);
    retry++;
  }
  if (retry == retryCount) {
    return false;
  }
  setTime(now);
  Serial.println("Time synchronized successfully");
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Time Sukses");
  return true;
}