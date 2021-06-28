eval_file SSO_RB_PATH()

use_debug false

loadName '1st Violins stc'
loadName '2nd Violins stc'
loadName 'Trumpets stc'

define :playSamples do |samples, amp|
  at (line 0, 0.2, steps: [1,1,2,2,4].choose) do
    sample (choose sample_names samples), amp: amp + (rrand -0.2, 0.5)
  end
end

inst = '1st Violins stc'
define :playNotesSub do |curChord, amp|
  at (line 0, 0.2, steps: [1,1,2,2,4].choose) do
    pl (choose curChord), 0.5, inst, amp + (rrand -0.2, 0.5)
  end
end

define :playNotes do |curChord, amp|
  if one_in 20
    playNotesSub curChord, amp
    inst = ['1st Violins stc', '1st Violins stc',
            '2nd Violins stc', '2nd Violins stc', 'Trumpets stc'].choose
    playNotesSub curChord, amp
  else
    playNotesSub curChord, amp
  end
end

set :bpm, 15

live_loop :drums do
  use_bpm get :bpm
  playSamples :tabla, 2.0
  sleep 0.2
end

live_loop :note do
  use_bpm get :bpm
  playNotes (chord :G3, :minor, num_octaves: 3), 1.0
  sleep 0.2
end

live_loop :bpm_setter do
  use_bpm 60
  sleep 4.0
  set :bpm, (get :bpm) * 1.1
end

