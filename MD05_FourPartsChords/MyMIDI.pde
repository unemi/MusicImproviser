import javax.sound.midi.*;

class MyMIDI {
  public MidiChannel channels[];
  MyMIDI() {
    try {
      Synthesizer synthesizer = MidiSystem.getSynthesizer();
      synthesizer.open();
      channels = synthesizer.getChannels();
    } catch (Exception e) { System.err.println(e); }
  }
}
