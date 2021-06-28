# Song title from Mrs. Wilson's Cook Book

# listOnsets slightly modifed from https://in-thread.sonic-pi.net/t/onset-percussion/1101/5
define :listOnsets do |s|
  set :onsetsMaps, []
  l = lambda {|c| set :onsetsMaps, c.to_a; c[0]}
  sample s, onset: l, amp: 0, finish: 0 # trigger the lambda function played sample at 0 volume and finish=0
  sleep 0.1
  return get :onsetsMaps
end

samp = SAMPLE_DIR() + "TMTASL/amy.wav"

onsets = listOnsets samp
i = 0

with_fx :reverb do
  live_loop :talk do
    if one_in 30
      i = rrand_i 0, onsets.size()
    elsif !one_in 3
      i = (i + 1) % onsets.size()
    end
    pitch = (rrand -2, 2)
    sample samp, amp: (rrand 5.0, 6.0), onset: i, rpitch: pitch, pan: (rrand -0.2, 0.2)
    sleep (onsets[i][:finish] - onsets[i][:start]) * (sample_duration samp, rpitch: pitch)
  end
  
  live_loop :drums do
    use_synth :chipnoise
    play amp: (rrand 0.3, 0.4), attack: 0.01, release: 0.05, freq_band: (rrand_i 0, 15)
    sleep [0.125, 0.125, 0.25, 0.25, 0.25, 0.25, 0.5].choose
  end
end

with_fx :reverb, mix: 1, room: 1 do
  live_loop :noise do
    if factor? tick, 2
      use_synth :hollow
      play (choose chord :D5, :minor7), release: 4.0
    else
      use_synth :growl
      play (choose chord :D6, :minor7), release: 1.5, amp: 0.7
    end
    sleep 1.0
  end
end