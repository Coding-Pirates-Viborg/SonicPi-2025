=begin
-----------------------------------------
Orkester computer

Kopier denne kode og indsæt den i en af
bufferne i Sonic Pi på din egen maskine.
-----------------------------------------
=end


set :master_bpm, 60 # Default værdi - overskrives af "dirigenten"

# Lyt efter BPM
live_loop :listen_for_bpm do
  bpm, _ = sync "/osc*/bpm" # vent på BPM fra "dirigenten"
  puts "BPM modtaget: " + bpm.to_s

  # Sæt BPM for alle kommende afspilninger
  set :master_bpm, bpm if bpm > 0
end

# Lyt efter start signalet
live_loop :listen_for_trigger do
  sekvens, _ = sync "/osc*/start" # vent på startsignal fra "dirigenten"
  puts "SEKVENS modtaget: " + sekvens.to_s

  # Brug master BPM der er modtaget fra "dirigenten"
  use_bpm get(:master_bpm)


  # Når start signalet er modtaget, så "oversæt" den modtagne
  # sekvens til et cue, der passer det musik, der skal afspilles

  # Tilret cues så de passer med dine egne musik-sekvenser

  # OBS: Du gør det MEGET nemmere for dig selv, hvis du kalder
  #      dine sekvenser og cues det samme!

  case sekvens.downcase
  # Bemærk: alt med små bogstaver
  when "stortromme"
    cue :stortromme
  when "lilletromme"
    cue :lilletromme
  else
    puts "!!! UKENDT SEKVENS: #{sekvens} !!!"
  end
end

# -----------------------------------------------------------------

# Herunder lytter hver sekvens efter sit eget cue for
# at blive afspillet
# Dette skal tilrettes så det passer med dit eget musik

# OBS: Du gør det MEGET nemmere for dig selv, hvis du kalder
#      dine sekvenser og cues det samme!

live_loop :stortromme do
  sync_bpm :stortromme # vent på cue

  # afspilning starter først når cue't er modtaget
  4.times do
    sample :bd_haus
    sleep 0.1
  end
end

live_loop :lilletromme do
  sync_bpm :lilletromme # vent på cue

  # afspilning starter først når cue't er modtaget
  4.times do
    sample :sn_dolf
    sleep 0.1
  end
end


