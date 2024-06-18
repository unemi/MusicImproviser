MyMIDI myMIDI = new MyMIDI();
int[] Maj = {0, 4, 7}, Min = {0, 3, 7},
  Sev = {0, 4, 7, 10}, Mn7 = {0, 3, 7, 10};
Chord C = new Chord(60, Maj), F = new Chord(65, Maj),
  Am = new Chord(57, Min), Dm = new Chord(62, Min),
  Em7 = new Chord(64, Mn7), G7 = new Chord(67, Sev);
Chord[] prog = {C, F, C, Am, Em7, Dm, G7, C};
float[][] rythmP = {{1., 0.}, {.4, .5}, {.8, .1}, {.4, .5},
  {.9, .1}, {.4, .5}, {.8, .1}, {.1, .5}};
int[] rythm = new int[rythmP.length];
int index = 0, beats = rythmP.length, chord[];
void setup() {
  frameRate(5);
  newRythm();
}
void newRythm() {
  for (int i = 0; i < rythmP.length; i ++) {
    float r = random(1);
    float[] p = rythmP[i];
    rythm[i] = (r < p[0])? 0 : (r < p[0]+p[1])? 1 : 2;
  }
}
void pianoOn() {
  chord = prog[index / beats].notes();
  for (int k : chord)
    myMIDI.channels[0].noteOn(k, int(random(80,120)));
}
void pianoOff() {
  if (chord != null) for (int k : chord)
    myMIDI.channels[0].noteOff(k);
}
void draw() {
  switch (rythm[index % rythm.length]) {
    case 0: pianoOff(); pianoOn(); break;
    case 1: pianoOff();
  }
  if ((++ index) >= prog.length * beats) {
    index = 0;
    newRythm();
  }
}
class Chord {
  int base;
  int[] keys;
  Chord(int b, int[] k) {
    base = b;
    keys = k;
  }
  int[] notes() {
    int[] ns = keys.clone();
    int idxH = 0, idxL = 0, nH = -1, nL = 999;
    for (int i = 0; i < keys.length; i ++) {
      ns[i] += base;
      if (ns[i] >= 72) ns[i] -= 12;
      else if (ns[i] < 60) ns[i] +=12;
      if (nH < ns[i]) { idxH = i; nH = ns[i]; }
      if (nL > ns[i]) { idxL = i; nL = ns[i]; }
    }
    float r = random(1);
    if (r < .2) ns[idxL] += 12;
    else if (r > .8) ns[idxH] -= 12;
    return ns;
  }
}
