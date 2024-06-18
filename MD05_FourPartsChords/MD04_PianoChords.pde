MyMIDI myMIDI = new MyMIDI();
int nBeats = 16, nParts = 5; // sax, piano, bass, snare, hi-hat
int nBarsToAlternateRythm = 2;
int rythm[][] = new int[nBeats][nParts];
int nBeatsInPhrase = 4;
float rythmP[][][] = {
  {{1., 0.}, {.2, .1}, {.6, .3}, {.2, .8}}, // sax
  {{.8, .2}, {.2, .2}, {.5, .3}, {.2, .2}},  // piano
  {{.9, 0.}, {.05, .2}, {.8, .3}, {.05, .2}},  // bass
  {{.2, .2}, {.5, .2}, {.2, .3}, {.5, .2}},  // snare
  {{.5, .2}, {.2, .2}, {.5, .3}, {.2, .2}}};  // hi-hat
int[] Maj = {0, 4, 7}, Min = {0, 3, 7},
  Sev = {0, 4, 7, 10}, Mn7 = {0, 3, 7, 10};
  //  Dim = {0, 3, 6}, Aug = {0, 4, 8},
Chord C = new Chord(60, Maj), F = new Chord(65, Maj),
  Am = new Chord(57, Min), Dm = new Chord(62, Min),
  Em7 = new Chord(64, Mn7), G7 = new Chord(67, Sev);
Chord[] prog = {C, F, C, Am, Em7, Dm, G7, C};
int[] scale = {60, 62, 64, 65, 67, 69, 71};
int[] crntChrd;  // for piano
int[] saxPhrase; // for main melody
int saxPitch = -1, bassPitch = -1;
int index = 0;

void newRythm() {
  for (int j = 0; j < nParts; j ++)
  for (int i = 0; i < nBeats; i ++) {
    float r = random(1), p[] = rythmP[j][i % rythmP[j].length];
    rythm[i][j] = (r < p[0])? 0 : (r < p[0] + p[1])? 1 : 2;
  }
  //println("new rythm");
}
void saxOn() {
  saxPitch = saxPhrase[index % nBeatsInPhrase];
  myMIDI.channels[0].noteOn(saxPitch, int(random(90,127)));
}
void saxOff() {
  if (saxPitch >= 0) {
    myMIDI.channels[0].noteOff(saxPitch);
    saxPitch = -1;
  }
}
void pianoOn() {
  crntChrd = prog[index / nBeats].notes();
  for (int k : crntChrd)
    myMIDI.channels[1].noteOn(k, int(random(40,60)));
}
void pianoOff() {
  if (crntChrd == null) return;
  for (int k : crntChrd)
    myMIDI.channels[1].noteOff(k);
  crntChrd = null;
}
void bassOn() {
  bassPitch = prog[index / nBeats].someNote() - 24;
  if (bassPitch > 42) bassPitch -= 12;
  myMIDI.channels[2].noteOn(bassPitch, int(random(80,110)));
}
void bassOff() {
  if (bassPitch >= 0) {
    myMIDI.channels[2].noteOff(bassPitch);
    bassPitch = -1;
  }
}
void setup() {
  frameRate(8);
  myMIDI.channels[0].programChange(65); // 66 alto sax
  myMIDI.channels[1].programChange(4); // 5 electric piano
  myMIDI.channels[2].programChange(34); // 35 pick bass
  newRythm();
}
void draw() {
  int[] rtm = rythm[index % nBeats];
// sax
  if (index % nBeatsInPhrase == 0) {
    Chord crd = prog[index / nBeats];
    saxPhrase = crd.phrase(crd.someNote());
  }
  switch (rtm[0]) {
    case 0: saxOff(); saxOn(); break;
    case 1: saxOff();
  }
// piano
  switch (rtm[1]) {
    case 0: pianoOff(); pianoOn(); break;
    case 1: pianoOff();
  }
// bass
  switch (rtm[2]) {
    case 0: bassOff(); bassOn(); break;
    case 1: bassOff();
  }
// drums
  if (index % 4 == 0)
    myMIDI.channels[9].noteOn(35, int(random(80,127)));  // bass drum
  if (rtm[3] == 0)
    myMIDI.channels[9].noteOn(37, 127);  // snare
  if (rtm[4] == 0)
    myMIDI.channels[9].noteOn(44, 127);  // hi-hat pedal
// next step
  if ((++ index) >= nBeats * prog.length) index = 0;
  if (index % (nBeats*nBarsToAlternateRythm) == 0) newRythm();
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
  int someNote() {
    return keys[int(random(keys.length))] + base;
  }
  int[] phrase(int startKey) {
    int idx = 0, k = startKey, octv = 0;
    while (k < scale[0]) { k += 12; octv --; }
    while (k > scale[scale.length-1]) { k -= 12; octv ++; }
    for (int i = 0; i < scale.length; i ++)
      if (scale[i] >= k) { idx = i; break; }
    idx += octv * scale.length;
    int phrs[] = new int[nBeatsInPhrase];
    phrs[0] = startKey;
    for (int i = 1; i < nBeatsInPhrase; i ++) {
      idx += int(random(3)) - 1;
      phrs[i] = scale[(idx + scale.length * 3) % scale.length]
        + ((idx + scale.length * 3) / scale.length - 3) * 12;
    }
    return phrs;
  }
}
