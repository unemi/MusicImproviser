MyMIDI myMIDI = new MyMIDI();
int score[] = {60, 62, 64, 65, 64, 62, 60};
int index = 0;
void setup() {
  frameRate(2);
}
void draw() {
  myMIDI.channels[0].noteOff(score[(index + 6) % 7], 120);
  myMIDI.channels[0].noteOn(score[index], 120);
  index = (index + 1) % 7;
}
