=begin
-----------------------------------------
Orkester computer

Kopier denne kode og indsæt den i en af
bufferne i Sonic Pi på din egen maskine.
-----------------------------------------
=end

# Lyt efter trigger signalet
live_loop :listen_for_trigger do
  sekvens, _ = sync "/osc*/start"
  puts "SEKVENS modtaget: " + sekvens.to_s
  
  # Når det modtages, så afspil den sekvens
  # der er blevet sendt
  case sekvens
  when 1
    cue :s1
  when 2
    cue :s2
  else
    puts "Ukendt sekvens: #{sekvens}"
  end
end

live_loop :s1_stortromme do
  sync_bpm :s1
  4.times do
    sample :bd_haus
    sleep 0.1
  end
end

live_loop :s2_lilletromme do
  sync_bpm :s2
  4.times do
    sample :sn_dolf
    sleep 0.1
  end
end


