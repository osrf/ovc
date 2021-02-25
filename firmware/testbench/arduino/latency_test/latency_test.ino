// we'll use pin A0 as the input trigger and just poll it's A/D
// so that we can be triggered by off-board low-voltage digital i/o (like 1.8v)

#define PIN_TRIGGER A0

typedef enum {
  STATE_IDLE,
  STATE_STARTED
} State;
static State state = STATE_IDLE;
static uint32_t t_start = 0;


void setup()
{
  pinMode(PIN_LED, OUTPUT);
  digitalWrite(PIN_LED, LOW);
  Serial.begin(115200);

  // read the A/D a few times to try to flush out any junk
  for (int i = 0; i < 10; i++)
  {
    delay(50);
    analogRead(PIN_TRIGGER);
  }
}

void start_timing()
{
  state = STATE_STARTED;
  t_start = micros();
  digitalWrite(PIN_LED, HIGH);
}

void stop_timing()
{
  const uint32_t t_elapsed = micros() - t_start;
  state = STATE_IDLE;
  Serial.println(t_elapsed);
  digitalWrite(PIN_LED, LOW);
}

void loop()
{
  int rx_byte = -1;
  if (Serial.available() > 0)
    rx_byte = Serial.read();

  const int trigger_threshold = (int)(1.4 * 1024.0 / 3.3);
  const int trigger = analogRead(PIN_TRIGGER);

  switch (state)
  {
    case STATE_IDLE:
      if (rx_byte == 'A' || trigger > trigger_threshold)
      {
        start_timing();
        Serial.println(trigger);
      }
      break;

    case STATE_STARTED:
      if (rx_byte == 'a')
        stop_timing();
      break;

    default:
      state = STATE_IDLE;
      break;
  }
}
