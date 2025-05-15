# Eksempel projekt på brug af booleaans til forskellige "spor"


TRACK1 = true
#TRACK1 = false

TRACK2 = true
#TRACK2 = false

TRACK3 = true
#TRACK3 = false

live_loop :track1 do
  breakbeat if (TRACK1)
  nothing if not (TRACK1)
end

live_loop :track2 do
  sync :track1
  synthtrommer if (TRACK2)
  nothing if not (TRACK2)
end

live_loop :track3 do
  sync :track1
  bassline if (TRACK3)
  nothing if not (TRACK3)
end

define :nothing do
  # nothing here
  sleep 1
end

define :bassline do
  4.times do
    play 40
    sleep 0.4
    play 50
    sleep 0.6
    play 60
    sleep 0.4
  end
end

define :breakbeat do
  4.times do
    one_breakbeat
  end
end

define :one_breakbeat do
  sample :bd_haus, rate: 90
  sleep 0.2
  sample :bd_haus, rate: 100
  sample :bd_haus, rate: 2
  sleep 0.1
  sample :sn_dub, rate: 70
  sleep 0.1
  sample :sn_dub, rate: 70
  sample :bd_haus, rate: 3
  sleep 0.1
  sample :sn_dub, rate: 70
  sleep 0.1
  sample :drum_snare_hard, rate: 2
  sleep 0.2
  
  sample :bd_haus, rate: 100
  sample :bd_haus, rate: 2
  sleep 0.1
  sample :bd_haus, rate: 90
  sleep 0.1
  sample :bd_haus, rate: 90
  sample :bd_haus, rate: 2
  sleep 0.2
  sample :drum_snare_hard, rate: 2
  sleep 0.1
  sample :bd_haus, rate: 100
  sleep 0.1
  sample :bd_haus, rate: 100
  sleep 0.1
  sample :bd_haus, rate: 90
  sleep 0.1
end

define :synthtrommer do
  blok1 0.5
  blok2 0.4
  blok1 0.5
  blok2 0.3
end

define :blok1 do |p|
  #sample :guit_e_fifths
  sample :ambi_choir, rate: p
  sample :bd_haus, rate: 1
  sleep 0.4
  sample :bd_haus, rate: 1
  sleep 0.2
  sample :bd_haus, rate: 1
  sleep 0.4
  sample :sn_dolf, rate: 8
  sleep 0.1
  sample :sn_dolf, rate: 8
  sleep 0.1
  sample :elec_beep
  sleep 0.2
  sample :elec_beep
  sleep 0.2
end

define :blok2 do |p|
  sample :ambi_choir, rate: p
  sample :bd_haus, rate: 1
  sleep 0.4
  sample :bd_haus, rate: 2
  sleep 0.4
  sample :bd_haus, rate: 1
  sleep 0.2
  sample :sn_dolf, rate: 1
  sleep 0.4
end
