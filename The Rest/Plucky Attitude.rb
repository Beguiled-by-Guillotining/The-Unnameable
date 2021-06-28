curScale = (scale :C4, :jiao)

set :loopNum, 0

define :startLoop do |time, coef, decay, offset=0, amp=1.0|
  n = get :loopNum
  set :loopNum, n+1
  
  live_loop ("loop" + n.to_s).to_sym do
    use_synth :pluck
    play (choose curScale) + offset, coef: coef, pluck_decay: decay, amp: amp if !one_in 8
    sleep time + (rrand -0.001, 0.001)
  end
end

live_loop :spawner do
  coef = (rrand 0.1, 0.9)
  offset = (knit 0,5,  -12,2, -24,1, -36,1).choose
  decay = (knit 1,5,  10,2, 20,1).choose
  
  amp = (rrand 1.0, 2.0) * coef + offset * 0.01
  amp = 0.1 if amp < 0.1
  
  startLoop (rrand_i 1,5)*0.1,  coef, decay, offset, amp
  sleep 5.0
end
