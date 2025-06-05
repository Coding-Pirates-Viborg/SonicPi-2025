=begin
--------------------------------------------------------------------------------
Kopier denne kode og indsæt den i en af bufferne i Sonic Pi på din egen maskine.

Du kan f.eks. placere den øverst i den buffer, hvor dine musikstykker ligger.

Filen med koden der modtager en trigger besked fra Open Sound Control (OSC) skal
ligge på din computer

Du kan finde filen i Github:
https://github.com/Coding-Pirates-Viborg/SonicPi-2025/blob/main/osc-trigger/Sonic-Pi/osc-receive-trigger.rb
--------------------------------------------------------------------------------
=end

# Sættes til det nummer vi er blevet enige om på workshoppen
MIN_MASKINE = 1

# Her afvikles filen med koden der modtager OSC beskeder
run_file "~/dev/kodepirat/SonicPi-2025/osc-trigger/Sonic-Pi/osc-receive-trigger.rb"

# Denne funktion skal du rette til, så den afspiller de rigtige stykker musik fra
# dine egne musikstykker i forhold til hvad vi er blevet enige om på workshoppen
define :afspil_sekvens do |sekvens_nr|
  bpm = get[:bpm]
  use_bpm bpm
  sync :tick
  case sekvens_nr
  when 1
    cue :s1
  when 2
    cue :s2
  when 3
    cue :s3
  end
end

# ------------------------------------------------------------------------------
# Herunder kan du placere din egen musikkode der skal afvikles på de forskellige
# cues der er defineret i funktionen "afspil_sekvens"

