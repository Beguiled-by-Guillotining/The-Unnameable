eval_file KNOBS_RB_PATH()

#initKnobs

loopLen = 2.0

midi_name = PAD_MIDI_NAME()

with_fx :echo, decay: 100000, phase: loopLen, max_phase: loopLen, mix: 0.7 do |e|
  live_loop :midi_piano do
    use_real_time
    note, velocity = sync midi_name + "note_on"
    in_thread do
      start = vt
      syncNote = note
      note += getKnob(2)
      amp = velocity / 127.0 * getKnob(1) / 127.0
      c = synth :piano, note: note, amp: amp, hard: amp, slide: 0.2
      loop do
        newNote, velocity = sync midi_name + "note_off"
        if newNote == syncNote
          control c, amp: 0
          break
        end
      end
    end
  end
  
  live_loop :echoController do
    phase = getKnob(6) * loopLen / 127.0
    phase = 0.01 if phase < 0.01
    control e, mix: getKnob(5) / 127.0, pre_mix: getKnob(7) * 10.0 / 127.0, phase: phase
    sleep 0.1
  end
end

