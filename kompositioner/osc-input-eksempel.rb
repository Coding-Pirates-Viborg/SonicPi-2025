# Open Sound Control
# ------------------

# Eskempel på at motage en trigger "udefra"

set :bpm, 0

live_loop :play do
  bpm = get[:bpm]
  if bpm != nil and bpm > 0
    use_bpm bpm
    breakbeat
  else
    sleep 1
  end
end

# Modtag en besked fra osc
define :receive_osc do
  use_real_time
  besked = sync "/osc*/trigger"
  bpm = besked[0].to_i
  set :bpm, bpm
  puts "BPM changed to: " + bpm.to_s
end

live_loop :osc do
  receive_osc
end

