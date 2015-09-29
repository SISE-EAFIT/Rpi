int trig= 31; // pin encargado de mandar la señar ultrasonica
int echo= 30; // pin que recibe el pulso
int val;

long distancia;
long tiempo;

void setup() {
 Serial.begin(9600); // inicializamos el puerto serial
 pinMode(trig, OUTPUT);
 pinMode(echo, INPUT);
}

void loop() {
  digitalWrite(trig, LOW);
  delayMicroseconds(60); //Esperamos 10 microsegundos
  digitalWrite(trig, HIGH); // Activamos los pulsos
  delayMicroseconds(60); //Esperamos 10 microsegundos}
  digitalWrite(trig, LOW);
  tiempo = pulseIn(echo, HIGH);
  delay(60);

  distancia = 0.017 * tiempo;
  val = map(distancia, 0, 1023, 0, 255);
  Serial.write(val);
  Serial.println(val);
}
