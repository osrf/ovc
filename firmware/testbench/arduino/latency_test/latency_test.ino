// we'll use pin A0 as the input trigger and just poll it's A/D
// so that we can be triggered by off-board low-voltage digital i/o (like 1.8v)

#define NUM_TRIGGERS 3
#define PIN_TRIGGER_0 A0
#define PIN_TRIGGER_1 A1
#define PIN_TRIGGER_2 A2

typedef enum {
  STATE_IDLE,
  STATE_TRIGGER_0,
  STATE_TRIGGER_1,
  STATE_TRIGGER_2,
} State;
static State state = STATE_IDLE;
static uint32_t t_start = 0;
static uint32_t t_elapsed[NUM_TRIGGERS] = {0};


void setup()
{
  pinMode(PIN_LED, OUTPUT);
  digitalWrite(PIN_LED, LOW);
  Serial.begin(115200);

  // read the A/D a few times to try to flush out any junk
  for (int i = 0; i < 10; i++)
  {
    delay(50);
    analogRead(PIN_TRIGGER_0);
    analogRead(PIN_TRIGGER_1);
    analogRead(PIN_TRIGGER_2);
  }
}

void trigger_0()
{
  t_start = micros();
  digitalWrite(PIN_LED, HIGH);
  state = STATE_TRIGGER_0;
}

void trigger_1()
{
  t_elapsed[0] = micros() - t_start;
  state = STATE_TRIGGER_1;
}

void trigger_2()
{
  t_elapsed[1] = micros() - t_start;
  state = STATE_TRIGGER_2;
}

void stop_timing()
{
  const uint32_t t_stop = micros();
  t_elapsed[2] = t_stop - t_start;

  Serial.print(t_elapsed[0]);
  Serial.print(" ");
  Serial.print(t_elapsed[1]);
  Serial.print(" ");
  Serial.println(t_elapsed[2]);

  digitalWrite(PIN_LED, LOW);
  state = STATE_IDLE;
}

void loop()
{
  int rx_byte = -1;
  if (Serial.available() > 0)
    rx_byte = Serial.read();

  const int trigger_threshold = (int)(1.4 * 1024.0 / 3.3);

  switch (state)
  {
    case STATE_IDLE:
      if (rx_byte == 'A' || analogRead(PIN_TRIGGER_0) > trigger_threshold)
        trigger_0();
      break;

    case STATE_TRIGGER_0:
      if (rx_byte == 'B' || analogRead(PIN_TRIGGER_1) > trigger_threshold)
        trigger_1();
      break;

    case STATE_TRIGGER_1:
      if (rx_byte == 'C' || analogRead(PIN_TRIGGER_2) > trigger_threshold)
        trigger_2();
      break;

    case STATE_TRIGGER_2:
      if (rx_byte == 'a')
        stop_timing();
      break;

    default:
      state = STATE_IDLE;
      break;
  }
}
