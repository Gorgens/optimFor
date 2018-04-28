#include <SD.h> // biblioteca cartão SD
#include <SoftwareSerial.h> // biblioteca pinos serial do GPS
#include <TinyGPS++.h> // biblioteca GPS
#include "DHT.h" // biblioteca DTH - sensor temperatura/umidade
 
#define DHTPIN A1 // pino do sensor de temperatura/umidade
#define DHTTYPE DHT11 // define o DHT 11 como o tipo de sensor utilizado
DHT dht(DHTPIN, DHTTYPE); // parâmetros da biblioteca

const int chipSelect = 4; // pino de cartão SD

SoftwareSerial gpsSerial(3, 2); // pinos do GPS

TinyGPSPlus gps; // variável GPS

void setup()
{
  Serial.begin(9600); // velocidade da serial do arduino
  Serial.println("Inicializando SD card...");  // escrever na serial
  gpsSerial.begin(9600); // velocidade da serial do GPS

     if (!SD.begin(chipSelect)) // verifica se o cartão esta inserido e pode ser inicializado 
     {
     Serial.println("Falha no SD Card, ou nao presente");  // escrever na serial
     
     //------------- Cabeçalho sem SD
     Serial.println("-Latitude- , -Longitude- , --Data--  , --Hora-- , -Velocidade- , -Temperatura- , -Umidade- "); // escrever na serial
     
     return;
     }
     
  Serial.println("SD Card Inicializado.");  // escrever na serial

  //------------- Cabeçalho SD
  Serial.println("-Latitude- , -Longitude- , --Data--  , --Hora-- , -Velocidade- , -Temperatura- , -Umidade- "); // escrever na serial  

  File dataFile = SD.open("gps.txt", FILE_WRITE); // cria arquivo de dados
  if (dataFile) // abre o arquivo de banco de dados
  {
  //dataFile.println("-Latitude- , -Longitude- , --Data--  , --Hora-- , -Velocidade- , -Temperatura- , -Umidade- "); // escrever no cartão SD
  dataFile.println("Latitude,Longitude,Data,Hora,Velocidade,Temperatura,Umidade"); // escrever no cartão SD
  }
  dataFile.close(); // fecha o arquivo de banco de dados 

  dht.begin(); // inicia sensor temperatura/umidade
}


void loop()
{  
  while (gpsSerial.available() > 0) // faça enquanto o GPS etiver disponível
   if (gps.encode(gpsSerial.read())) // descodifica o sinal recebido pelo GPS
   
   DadosGps(); // recebe afunção DadosGps onde os dados são processados      
  
   if (millis() > 5000 && gps.charsProcessed() < 10) // espera 5000 milisegundos e menos de 10 caracteres processados, se o cartão nao for identificado aparece a mensagem "GPS nao detectado"
   {
    Serial.println(F("GPS nao detectado"));  // escrever na serial
    while(true); // executa enquanto for verdade
    }
}


void DadosGps() // função DadosGps, processamento dos dados do GPS
{
 File dataFile = SD.open("gps.txt", FILE_WRITE); // cria e abre o arquivo de banco de dados no carato SD em formato txt, bloco de notas

 float h = dht.readHumidity(); // atribui valores a variavel h, umidade
 float t = dht.readTemperature(); // atribui valores a variavel t, temperatura
 
//------------ Cartao SD    
      
      if (dataFile) // abre o arquivo de banco de dados
      {  
        
      //----- Latitude e Longitude - Cartao SD     
      dataFile.print(gps.location.lat(), 6); // escrever no arquivo de banco de dados 
      dataFile.print(F(" , "));  // escrever no arquivo de banco de dados 
      dataFile.print(gps.location.lng(), 6); // escrever no arquivo de banco de dados
      dataFile.print(F("  , "));  // escrever no arquivo de banco de dados 
      
      //------ Data - Cartao SD  
      dataFile.print(gps.date.day()); // escrever no arquivo de banco de dados      
      dataFile.print(F("/")); // escrever no arquivo de banco de dados 
      dataFile.print(gps.date.month()); // escrever no arquivo de banco de dados 
      dataFile.print(F("/")); // escrever no arquivo de banco de dados 
      dataFile.print(gps.date.year()); // escrever no arquivo de banco de dados 
      dataFile.print(F(" , "));  // escrever no arquivo de banco de dados 

      //------ Hora - Cartao SD  
      if (gps.time.hour() < 10) dataFile.print(F("0")); // condição para formatação da hora, adiciona um "0" antes do numero que for menor que 10.
      dataFile.print(gps.time.hour()); // escrever no arquivo de banco de dados 
      dataFile.print(F(":")); // eescrever no arquivo de banco de dados 
      if (gps.time.minute() < 10) dataFile.print(F("0")); // condição para formatação da hora, adiciona um "0" antes do numero que for menor que 10.
      dataFile.print(gps.time.minute()); // escrever no arquivo de banco de dados 
      dataFile.print(F(":")); // escrever no arquivo de banco de dados 
      if (gps.time.second() < 10) dataFile.print(F("0")); // condição para formatação da hora, adiciona um "0" antes do numero que for menor que 10.
      dataFile.print(gps.time.second()); // escrever no arquivo de banco de dados          
      dataFile.print(F(" ,   "));  // escrever no arquivo de banco de dados 

      //------- Velocidade - Cartao SD  
      //dataFile.print("Velocidade: "); // escrever no arquivo de banco de dados 
      dataFile.print(gps.speed.kmph()); // escrever no arquivo de banco de dados 
      //dataFile.print("km/h"); // escrever no arquivo de banco de dados 
      dataFile.print(F("   ,   "));  // escrever no arquivo de banco de dados 

      //------- Rumo/Azimute - Monitor Serial
    
      //------- Temperatura - Cartao SD  
      dataFile.print(t); // escrever no arquivo de banco de dados 
      //dataFile.print(" *C"); // escrever no arquivo de banco de dados 
      dataFile.print(F("    ,  ")); // escrever no arquivo de banco de dados 

      //------- Umidade - Cartao SD       
      dataFile.print(h); // escrever no arquivo de banco de dados 
      //dataFile.print(" %"); // escrever no arquivo de banco de dados 
      
      //------- "Enter"
      dataFile.println(); // escrever no arquivo de banco de dados "Enter"
      
      //------- Finaliza SD 
      dataFile.close(); // fecha o arquivo de banco de dados 
       }


//------------ Monitor Serial

  
      //------ Latitude e Longitude - Monitor Serial
      //Serial.print("Latitude: "); // escrever na serial
      Serial.print(gps.location.lat(), 6); // escrever na serial
      Serial.print(F(" , "));  // escrever na serial
      //Serial.print("Longitude: "); // escrever na serial
      Serial.print(gps.location.lng(), 6); // escrever na serial
      Serial.print(F("  , "));  // escrever na serial
      
      //------ Data - Monitor Serial
      //Serial.print("Data: "); // escrever na serial
      Serial.print(gps.date.day()); // escrever na serial      
      Serial.print(F("/")); // escrever na serial
      Serial.print(gps.date.month()); // escrever na serial
      Serial.print(F("/")); // escrever na serial
      Serial.print(gps.date.year()); // escrever na serial
      Serial.print(F(" , "));  // escrever na serial

      //------ Hora - Monitor Serial
 
      //Serial.print("Hora: "); // escrever no arquivo de banco de dados 
      if (gps.time.hour() < 10) Serial.print(F("0")); // condição para formatação da hora, adiciona um "0" antes do numero que for menor que 10.
      Serial.print(gps.time.hour()); // escrever no arquivo de banco de dados 
      Serial.print(F(":")); // eescrever no arquivo de banco de dados 
      if (gps.time.minute() < 10) Serial.print(F("0")); // condição para formatação da hora, adiciona um "0" antes do numero que for menor que 10.
      Serial.print(gps.time.minute()); // escrever no arquivo de banco de dados 
      Serial.print(F(":")); // escrever no arquivo de banco de dados 
      if (gps.time.second() < 10) Serial.print(F("0")); // condição para formatação da hora, adiciona um "0" antes do numero que for menor que 10.
      Serial.print(gps.time.second()); // escrever no arquivo de banco de dados      
      Serial.print(F(" ,   "));  // escrever na serial

      //------- Velocidade - Monitor Serial
      //Serial.print("Velocidade: "); // escrever na serial
      Serial.print(gps.speed.kmph()); // escrever na serial
      Serial.print("km/h"); // escrever na serial
      Serial.print(F("   ,   "));  // escrever na serial

      //------- Rumo/Azimute - Monitor Serial
    
      //------- Temperatura - Cartao SD  
      Serial.print(t); // escrever na serial
      Serial.print(" *C"); // escrever na serial
      Serial.print(F("    ,  "));  // escrever na serial

      //------- Umidade - Cartao SD       
      Serial.print(h); // escrever na serial
      Serial.print(" %"); // escrever na serial
    
      //------- "Enter"
      Serial.println(); // escrever na serial "Enter"
  
  //delay(10000); // aguarda 10 segundos
  
}

