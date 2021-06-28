with_fx :tremolo, phase: 30, depth: 0.7 do
  live_loop :main do
    notes = shuffle chord :C4, :minor7, num_octaves: 2, invert: -4
    synth :chiplead, note: notes[0], amp: 0.1
    synth :chiplead, note: notes[1], amp: 0.1
    sleep [0.2, 0.4].choose
  end
  
  live_loop :main2 do
    synth :chipbass, note: (choose chord :C3, :minor7), amp: 0.2, release: 2
    synth :chipbass, note: (choose chord :C3, :minor7), amp: 0.2, release: 2
    sleep 0.8
  end
end

live_loop :bg do
  time = choose [1.6, 3.2]
  synth :growl, note: (choose chord :C4, :minor7), sustain: time, amp: (rrand 0.25, 0.35)
  synth :growl, note: (choose chord :C4, :minor7), sustain: time, amp: (rrand 0.25, 0.35)
  synth :hollow, note: (choose chord :C3, :minor7), sustain: time, amp: (rrand 0.45, 0.55)
  synth :hollow, note: (choose chord :C3, :minor7), sustain: time, amp: (rrand 0.45, 0.55)
  synth :pnoise, cutoff: 70, sustain: time, release: 0, amp: 0.25
  sleep time
end