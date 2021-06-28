eval_file SSO_RB_PATH()

use_debug false

len = 16
randomness = 7

#instrument, amp, note_offset, pan
instr = [
  ['Harp', 0.4, 0, -0.1],
  ['Xylophone', 0.05, 0, -0.1],
  ['Glockenspiel', 0.05, 0, 0.1],
  ['Flutes sus', 0.5, 0, -0.1],
  ['Violas sus', 0.3, 12, 0.3],
  ['Tuba sus', 1.0, -12, -0.1],
  ['Basses piz', 0.7, -24, 0.1],
  ['Cor Anglais', 1.0, 12, 0.1], #Some of its notes won't be played but I want to stay in key so that can't be helped
  ['2nd Violins sus', 0.4, 12, -0.2],
  ['Clarinets', 1.0, 0, 0.0],
  ['Horns sus', 1.0, 0, -0.3],
  ['Tuba sus', 0.8, -12, 0.3],
  ['Celli piz', 1.0, 0, 0.0]
]

curScale = chord :D3, :minor7, num_octaves: 2
pausePattern = [4,2,1,3,5,1,0,8,16,32]

melodies = []
instr.each do |inst|
  loadName inst[0]
  melody = []
  len.times do
    melody.append([:r, 1.0])
  end
  melodies.append(melody.ring)
end

loudInstr = ''
pauses = pausePattern[0]

live_loop :main do
  new_melodies = []
  idx = tick % len
  instr.zip(melodies).each do |inst,melody|
    if one_in(randomness)
      melody = melody[0..idx] +
        [[(knit :r, pauses, (choose curScale), 1).choose,
          inst[1] * (rrand 0.6, 1.0)
          ]] +
        melody[(idx+1)..melody.length]
    end
    pl melody[idx][0], 1.3, inst[0], (loudInstr == inst[0] ? 3.0 : 1.0) * melody.look[1], inst[2], inst[3]
    new_melodies.append(melody)
  end
  melodies = new_melodies
  
  if one_in 50
    loudInstr = ['', instr.choose[0], instr.choose[0]].choose
    print "Loud now:", loudInstr
  end
  
  if factor? look, 150
    pauses = pausePattern.tick(:pauses)
    print "Pauses now:", pauses
  end
  
  sleep 0.4
end