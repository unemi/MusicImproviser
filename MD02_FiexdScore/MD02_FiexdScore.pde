MyMIDI myMIDI = new MyMIDI();
int score[][] = {
  {67,1},{65,1,50},
  {64,1,80},{67,1,110},{76,2,127},{-1,1},{74,1},
  {72,1},{64,1},{67,2},{-1,1},{72,1},
  {71,1},{62,1},{65,1},{67,1},{71,1},{74,1},
  {72,3},{-1,1}};
int chord[][] = {
  {60, 64, 67}, {60, 64, 67}, {59, 62, 67},
  {60, 64, 67}
};
int bass[] = {
  36, 36, 40, 43, 36, 40, 43, 43, 38, 35,
  36, 36
};
int index = 0, cnt = 0, beat = 0;
void setup() {
  frameRate(3);
  myMIDI.channels[0].programChange(80);
  myMIDI.channels[2].programChange(33);
}
void draw() {
  int n = score.length;
  if (cnt == 0) {
    int pitch = score[(index + n - 1) % n][0];
    if (pitch >= 0) myMIDI.channels[0].noteOff(pitch);
    pitch = score[index][0];
    if (pitch >= 0) {
      int vel = (score[index].length == 2)? 120 : score[index][2];
      myMIDI.channels[0].noteOn(pitch, vel);
    }
    cnt = score[index][1];
    index = (index + 1) % n;
  }
  switch (beat % 6) {
    case 2:
      myMIDI.channels[9].noteOn(35, 127); break;
    case 0: case 4:
      myMIDI.channels[9].noteOn(37, 127);
  }
  if (beat % 3 == 0) {
    int chrd[] = chord[(beat / 6) % chord.length];
    for (int k : chrd)
      myMIDI.channels[1].noteOn(k, 90);
  }
  if (beat % 2 == 0)
    myMIDI.channels[2].
      noteOn(bass[(beat/2)%bass.length], 120);
  cnt --;
  beat ++;
}
