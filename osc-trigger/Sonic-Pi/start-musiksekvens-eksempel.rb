# Kopier denne kode og indsæt den i en af bufferne
# i Sonic Pi på din egen maskine.

# Du kan f.eks. placere den øverst i den buffer, hvor
# din komposition ligger.

# Modtage en trigger besked fra Open Sound Control (OSC)
# Filen skal ligge på din computer
# Se Github:
run_file "~/dev/kodepirat/SonicPi-2025/osc-trigger/Sonic-Pi/osc-receive-trigger.rb"

# Sæt denne variabel til det nummer vi er blevet enige om
MIN_MASKINE = 0

# Denne funktion skal du rette til, så den afspiller
# de rigtige stykker musik fra din egen komposition
# i forhold til hvad vi har planlagt på workshoppen
define :afspil_sekvens do |sekvens_nr|
  bpm = get[:bpm]
  use_bpm bpm
  case sekvens_nr
  when 1
    cue :s1, :s2
  when 2
    cue :s2
  end
end
