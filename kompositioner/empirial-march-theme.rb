# Empirial march - basic!!
# Thanx to: https://github.com/ej-mitchell/sonic-pi-themes/blob/master/imperial-march-theme.rb

# Partition definitions

define :main_chord_inversion do
    play :Ef5
    sleep 0.45
    play :Bf5
    sleep 0.15
    play :G5
    sleep 0.6
  end
  
  define :first_theme do
    first_theme_a
    sleep 0.6
    first_theme_b
  end
  
  define :first_theme_a do
    3.times do
      play :G5
      sleep 0.6
    end
    
    2.times do
      main_chord_inversion
    end
  end
  
  define :first_theme_b do
    3.times do
      play :D6
      sleep 0.6
    end
    
    play :Ef6
    sleep 0.45
    play :Bf5
    sleep 0.15
    play :G5
    sleep 0.6
    
    main_chord_inversion
  end
  
  define :second_theme do
    play :G6
    sleep 0.6
    play :G5
    sleep 0.45
    play :G5
    sleep 0.15
    play :G6
    sleep 0.6
    play :Gf6
    sleep 0.45
    play :F6
    sleep 0.15
    
    play :E6
    sleep 0.15
    play :Ds6
    sleep 0.15
    play :E6
    # NOTE: double sleeps are a reminder to add differentiation between duration and rest marks
    sleep 0.30
    sleep 0.30
    play :Gs5
    sleep 0.30
    play :Cs6
    sleep 0.6
    play :Bs5
    sleep 0.45
    play :B5
    sleep 0.15
    
    play :Bf5
    sleep 0.15
    play :A5
    sleep 0.15
    play :Bf5
    sleep 0.30
    sleep 0.30
    play :Ef5
    sleep 0.30
    play :Gf5
    sleep 0.6
    
    # resolve on first theme
    
    2.times do
      main_chord_inversion
    end
  end
  
  ## TO PLAY
  first_theme
  sleep 0.6
  second_theme