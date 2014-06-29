#include <SPI.h>
#include <Ethernet.h>
#include <avr/pgmspace.h>
#include <string.h>
#include <Wire.h>
#include <SoftwareSerial.h>

#define smillis() ((long)millis())
#define I2C_ADDRESS 0x50

SoftwareSerial RFID(2,3);

byte mac[] = { 
  0x90, 0xA2, 0xDA, 0x0F, 0x0F, 0x97
};    

IPAddress ip(192,168,15,12);                      
IPAddress server(192,168,15,11);

int DO_RESET_ETH_SHIELD = 8;  // Output pin to reset Ethernet shield
int readyLED =  13;

char inString[32]; // string for incoming serial data
int stringPos = 0; // string index counter
boolean startRead = false; // is reading?
byte readCard[6];    // Sotres an ID read from the RFID reader
byte checksum = 0;

EthernetClient client;

void setup() {
  Serial.begin(9600);
  init_ethernet();   // Delayed reset of Ethernet shield
  pinMode(readyLED, OUTPUT);
  //digitalWrite(readyLED, HIGH);
  Serial.println("setup running");
  // Serial.begin(9600);
  delay(1000);
  Ethernet.begin(mac, ip);

  pinMode(6,INPUT_PULLUP);
  pinMode(8,OUTPUT);
  digitalWrite(8,LOW);
  //digitalWrite(6,LOW);

  // Serial.begin(9600);
  Serial.print("My IP address: ");
  for (byte thisByte = 0; thisByte < 4; thisByte++)
  {
    Serial.print(Ethernet.localIP()[thisByte], DEC);
    Serial.print(".");
  }
  Serial.println();
  // delay(1000);
  // Serial.begin(9600);
  RFID.begin(9600);
}

void loop()
{

  String buffer;
  buffer = "";
  byte val = 0;

  if(RFID.available() > 0)          // If the serial port is available and sending data...
  {
    if((val = RFID.read()) == 2)    // First Byte should be 2, STX byte 
    {                  
      getID();
      byte bytesread = 0;

      for ( int i = 0; i < 5; i++ )         // Loop 5 times
      {
        buffer = String(buffer + String(readCard[i], HEX));
      }

      Serial.println();
      Serial.println(buffer);
    }


    sendData(buffer, 0);        // send data to database server
    // delay(500);
    Serial.println();

    RFID.end();
    RFID.begin(9600);
  }
}

void getID()
{
  byte bytesread = 0;
  byte i = 0;
  byte val = 0;
  byte tempbyte = 0;
  // 5 HEX Byte code is actually 10 ASCII Bytes. 
  while ( bytesread < 12 ) // Read 10 digit code + 2 digit checksum
  {                        
    if( RFID.available() > 0)   // Check to make sure data is coming on the serial line
    { 
      val = RFID.read();        // Store the current ASCII byte in val

      if((val == 0x0D)||(val == 0x0A)||(val == 0x03)||(val == 0x02)) 
      {                           // If header or stop bytes before the 10 digit reading
        break;                    // Stop reading                                 
      }

      if ( (val >= '0' ) && ( val <= '9' ) )    // Do Ascii/Hex conversion
      {
        val = val - '0';
      } 
      else if ( ( val >= 'A' ) && ( val <= 'F' ) ) 
      {
        val = 10 + val - 'A';
      }

      if ( bytesread & 1 == 1 )      // Every two ASCII charactors = 1 BYTE in HEX format
      {
        // Make some space for this hex-digit by
        // shifting the previous hex-digit with 4 bits to the left:
        readCard[bytesread >> 1] = (val | (tempbyte << 4));

        if ( bytesread >> 1 != 5 )                // If we're at the checksum byte,
        {
          checksum ^= readCard[bytesread >> 1];   // Calculate the checksum using XOR
        };
      } 
      else                                        // If it is the first HEX charactor
      {
        tempbyte = val;                           // Store the HEX in a temp variable
      };
      bytesread++;                                // Increment the counter to keep track
    } 
  } 
  bytesread = 0;
}



String readPage(){
  //read the page returned py the PHP script we called
  // and capture & everything between '<' and '>' to display on the OLED
  stringPos = 0;

  memset( &inString, 0, 32 ); //clear inString memory

  while (true)  {

    if (client.available()) {
      while (client.connected())  {
        char c = client.read();
        if (c == '<' ) {
          startRead = true; //Ready to start reading the part
        } 
        else if (startRead)  {
          if (c != '>') {
            inString[stringPos] = c;
            stringPos ++;
            // Serial.print(c);
          }
          else {
          //got what we need here! We can disconnect now
            startRead = false;
            // client.stop();
            client.flush();
          // Serial.println("disconnecting.");
            return inString;
          }
        }
      }
    }
  }
}

void sendData(String  thisData,  String InOut) { 
  if (client.connect(server, 3000)) {
    client.print("GET /verify/");
    // Serial.println("Connected to server...");
    delay(100);
    // format and  send the HTTP GET request:
    // client.print(InOut);
    // client.print("cardid=");
    client.print(thisData);
    client.println(" HTTP/1.1");                //
    client.println("Host: localhost");          //run the php script on the server
    // client.println("Accept: text/html");        //
    // client.println("Connection: close");        //
    client.println();                           //

    // Serial.println("data sent");
    // // //Connected - Read the page
    delay(1000);
    readPage();
    // delay(2000);
    // //go and read the output
    // // if there are incoming bytes available
    // // from the server, read them and print them:
    // Serial.print("mao ni ang string ==>");
    // Serial.println(inString);

    //if valid
    if(inString[0] == '1') {
      Serial.println("valid card");
      

      //5secs timeout for entry
      if(timedFunction(15000) == HIGH) {
        client.print("GET /display/");
        delay(100);
        client.print(thisData);
        client.println(" HTTP/1.1");                //
        client.println("Host: localhost");
        client.println();     
        delay(1000);
      }
      else {
        Serial.print("timed-out");
      }
      digitalWrite(8,LOW);
    }

    else if(inString[0] == '0') {
      Serial.println("invalid card");
    }

    client.flush();
    client.stop();
    client.flush();  // close the connection network connection
  }


  else {
    // if you couldn't make a connection to the database server:
    Serial.println("connection failed");
    delay (1000);

    client.flush();
    client.stop();
    client.flush();
    init_ethernet();
  }

}

// Delayed reset and startup for Ethernet shield
void init_ethernet() {
  pinMode(DO_RESET_ETH_SHIELD, OUTPUT);     // sets the digital pin as output
  digitalWrite(DO_RESET_ETH_SHIELD, LOW);
  //digitalWrite(readyLED, LOW);              // turn off Ready LED
  delay(1000);  //for ethernet chip to reset
  digitalWrite(DO_RESET_ETH_SHIELD, HIGH);
  delay(1000);  //for ethernet chip to reset
  pinMode(DO_RESET_ETH_SHIELD, INPUT);      // sets the digital pin input
  delay(1000);  //for ethernet chip to reset
  delay(1000);  //for ethernet chip to reset
  //digitalWrite(readyLED,HIGH);              // wait for everything to be up and then turn on Ready
}

int timedFunction(unsigned long howLong) {
  unsigned long finishAt = millis() + howLong;
  while(millis() < finishAt) {
    digitalWrite(8,HIGH);
        // Do whatever
    if(digitalRead(6)==HIGH){
      return HIGH;
    }
  }
  return LOW;
}

