samples = sample_names :ambi
samples += sample_names :glitch

define :sample_loop do
  in_thread do
    cur_sample = choose samples
    time = rrand 5.0, 10.0
    repeats = choose [1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,3]
    amp = rrand 0.5, 1.0
    loop do
      repeats.times do
        sample cur_sample, release: 0.2, amp: amp
        sleep 0.1
      end
      sleep time
    end
  end
end

sample_loop
sleep 2.0
sample_loop
sleep 3.0
wait_time = 7.0
live_loop :spawner do
  sample_loop
  sleep rrand wait_time, wait_time + 5.0
  wait_time += 1.0
end

sleep 5.0
live_loop :drums do
  pattern = []
  times = []
  amps = []
  (rrand_i 5, 7).times do
    pattern.append(choose sample_names :tabla)
    times.append(choose [0.2, 0.2, 0.1])
    amps.append(rrand 0.7, 0.9)
  end
  (rrand_i 15, 20).times do
    for i in (range 0, pattern.size - 1)
      sample pattern[i], amp: amps[i]
      sleep times[i]
    end
  end
end