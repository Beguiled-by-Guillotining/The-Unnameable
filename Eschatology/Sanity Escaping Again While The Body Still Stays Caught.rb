eval_file SSO_RB_PATH()

use_debug false

len = 9
set :len, len

set :global_amp, 1.0
loopNum = 0


curScale = scale :E3, :segah, num_octaves: 2

define :liveLoop do |pitch, window_size, amp, instrumentName, note_offset=0|
  l = loopNum
  loopNum += 1
  in_thread do
    loadName instrumentName
    
    melody = []
    len.times do
      melody.append([:r, 0.0])
    end
    
    with_fx :pitch_shift, pitch: pitch, pitch_dis: 0.001, time_dis: 0.001, window_size: window_size do
      live_loop ("main" + l.to_s).to_sym do
        idx = tick % get(:len)
        
        if one_in(20)
          melody[idx] = [[:r, (choose curScale), (choose curScale)].choose, (rrand -1.0, 1.0)]
        end
        m = melody[idx]
        pl m[0]+note_offset, 1.0, instrumentName, amp * get(:global_amp), 0, m[1]
        
        sleep 0.2
      end
    end
  end
end

liveLoop -12, 1.0,  0.5, 'Xylophone'
liveLoop -12, 1.0,  0.5, 'Xylophone', 6
liveLoop -12, 1.0,  0.5, 'Xylophone', -6
liveLoop -12, 0.5,  0.5, 'Xylophone'
liveLoop -12, 0.5,  0.5, 'Xylophone', 6
liveLoop -12, 0.5,  0.5, 'Xylophone', -6
liveLoop -24, 1.0,  1.0, 'Glockenspiel'
liveLoop -36, 0.02, 1.0, 'Glockenspiel'
liveLoop -36, 0.2,  1.0, 'Glockenspiel'
liveLoop -48, 0.2,  2.0, 'Trumpet', 12
liveLoop -48, 0.02, 2.0, 'Trumpet', 12
liveLoop -60, 1.0,  8.0, 'Trumpet', 12
liveLoop -72, 1.0,  10.0, 'Trumpet', 12

live_loop :ampMod do
  sleep 5.0
  set :global_amp, get(:global_amp) + 0.1
  print "amp", get(:global_amp)
end

live_loop :lenMod do
  sleep 16.0
  set :len, get(:len) - 1
  print "len", get(:len)
  stop if get(:len) <= 1
end

