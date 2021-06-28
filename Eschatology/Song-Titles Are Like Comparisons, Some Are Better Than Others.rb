use_bpm 80

set :base, 200

live_loop :melody do
  use_synth :piano
  play (chord (hz_to_midi get :base), :minor).choose, hard: 1.0
  sleep [0.2, 0.2, 0.2, 0.2, 0.4].choose
end

live_loop :notes do
  use_synth :piano
  
  base = get :base
  note = (halves base, 3).tick
  amp = 0.5 + (look % 3) / 8.0 - base / 8000.0
  
  play (hz_to_midi note), amp: amp
  
  sleep [0.1,0.1,0.15].look + (base / 8000.0)
  set :base, 200 + (base + 50 - 200) % 250 if one_in(20)
end

live_loop :drums do
  sample [:bd_sone,:bd_tek,:bd_sone,:bd_tek,:bd_mehackit].tick(:samp), amp: (rrand 0.5, 0.7)
  sleep [0.2, 0.2, 0.4].choose
end

