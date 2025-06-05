=begin
--------------------------------------------------------------------------------
Modtage en trigger besked fra Open Sound Control (OSC)

Programmet her lytter efter en besked via OSC protokollen på stien "/osc*/trigger".

Når beskeden modtages, kalder den funktionen "afspil_sekvens". Denne funktion skal
du selv definere i Sonic Pi, så den afspiller den rigtige musik i forhold til hvad
vi har planlagt på workshoppen.

HVORDAN BRUGER JEG DETTE?
-------------------------
Filen her skal ligge på din computers harddisk, et sted hvor den kan læses fra Sonic Pi.

Det letteste er at klone hele "SonicPi-2025" repoet. Hvis du ikke ved hvordan man gør,
så spørg i workshoppen :-)

I Sonic Pi kan man afspille en fil med "run_file". Der er et eksempel på dette i
filen "start-musiksekvens-eksempel.rb" i Github her:
https://github.com/Coding-Pirates-Viborg/SonicPi-2025/blob/main/osc-trigger/Sonic-Pi/start-musiksekvens-eksempel.rb
--------------------------------------------------------------------------------
=end

# Sender et tick cue på hvert taktslag.
# Bruges til at synkronisere at sekvenserne ikke starter ude af takt
live_loop :sequencer do
  cue :tick
  sleep 1
end



define :receive_osc do
  puts "Modtager OSC beskeder på maskine: " + MIN_MASKINE.to_s
  use_real_time

  kontrol = -1
  while kontrol != 0 do
    besked = sync "/osc*/trigger"

    modtager = besked[0]
    sekvens = besked[1]
    bpm = besked[2]
    kontrol = besked[3]

    puts "Trigger besked modtaget:"
    puts "------------------------"
    puts "Modtager: " + modtager.to_s + " (mig: " + MIN_MASKINE.to_s + ")"
    puts "Sekvens:  " + sekvens.to_s
    puts "BPM:      " + bpm.to_s
    puts "Kontrol:  " + kontrol.to_s
    puts "------------------------"

    set :bpm, bpm

    if modtager == MIN_MASKINE
      puts "Wu-huu! Afspiller nu sekvens: " + sekvens.to_s
      afspil_sekvens(sekvens) # denne funktion skal du skrive koden til

    end
  end
  puts "Kontrol = 0 modtaget. Stopper med at lytte efter trigger beskeder!"
end
receive_osc
