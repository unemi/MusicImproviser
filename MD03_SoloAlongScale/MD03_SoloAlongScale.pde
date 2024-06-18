MyMIDI myMIDI = new MyMIDI();
int nBeats = 32;
int[] scale = {0, 2, 4, 5, 7, 9, 11}, score = new int[nBeats];
int L = scale.length, b = 0, bar = 0;
void setup() {
  frameRate(8);
  makePhrase();
  myMIDI.channels[0].programChange(80);
}
void makePhrase() {
  int k = L;
  for (int i = 0; i < nBeats; i ++) {
    if ((i % 2 == 1 || i % 4 == 2) && random(1) < .667) {
      if (random(1) < 0.333) score[i] = -1;  // pause
      else score[i] = 0;  // continue
    } else {  // new note
      k = min(24,max(0,k + int(random(3)) - 1));
      score[i] = (k/L)*12+scale[k%L]+48;
    }
  }
}
int K = -1;
void draw() {
  if (K > 0) myMIDI.channels[0].noteOff(K);
  K = score[b];
  if (K > 0) myMIDI.channels[0].noteOn(K, 100);
  if ((b = (b + 1) % nBeats) == 0) {
    if ((++ bar) % 2 == 0) makePhrase();
  }
}
