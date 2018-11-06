#!/bin/bash
cluster=$1
version=$2
distro=$3

version="$(printf %40s "${version:-Flight Direct r2018.1}")"
distro="$(printf %40s "Based on $distro")"

frame() {
  col=$((159-$1))
  if [ "$col" -lt 154 ]; then
      esc="1;32"
  else
    esc="1;38;5;$col"
  fi
  if [ "${cluster}" == "Unconfigured" ]; then
    welcome="$(printf %$((43+${#esc}))s "Welcome to [${esc}mAlces Flight")"
  else
    welcome="$(printf %$((43+${#esc}))s "Welcome to [${esc}m${cluster}")"
  fi
  cat | sed -e "s#%WELCOME%#$welcome#g" \
            -e "s#%VERSION%#$version#g" \
            -e "s#%DISTRO%#$distro#g"
}

final_frame() {
  echo '[20A'
  frame 6 <<'EOF'
[38;5;68m  'o`               
 'ooo`[1;37;40m               %WELCOME%[38;5;68;49m
 `oooo`             
  `oooo`         'o`[1;37;40m %VERSION%[38;5;68;49m
    `ooooo`  `ooooo[1;37;40m  %DISTRO%[38;5;68;49m
       `oooo:oooo`                                 
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;15mflight[38;5;68m ]- [0m                  
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
EOF
  echo "[13A"
}

delay() {
  if read -t0 -N0 -s; then
    if [ "$2" ]; then
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;15mflight[38;5;68m ]- [0m                  
EOF
    else
      final_frame
    fi
    exit 0
  else
    sleep $1
  fi
}

cleanup() {
  stty "$oldstty"
  if [ "$1" == "force" ]; then
    final_frame
    exit
  fi
}

oldstty="$(stty -g)"
trap cleanup EXIT
trap "cleanup force" INT TERM
stty -icanon -echo min 1 time 0

frame 0 <<'EOF'
[38;5;68m        `.:/+/
    ./oooo+`[1;37;40m         %WELCOME%[38;5;68;49m
  `/oooooo.
  /oooooo/[1;37;40m           %VERSION%[38;5;68;49m
  ooooooo-  ./o/[1;37;40m     %DISTRO%[38;5;68;49m
  +oooooo/`+ooo
  -oooooooooooo
   :ooooooooooo. `:+:`
    -+ooooooooo+:ooo`
     `:ooooooooooooo.                               `.
       `:+oooooooooo+`                              /o/
         `-+ooooooooo+-                 :.   .+/   -ooo:
            .:+oooooooo+-`            .+o: `:ooo  :oooo+
               `-/oooooooo/..-....-:/+ooo//oooo+/+ooooo/
                   ./oooooooo+oooooooooooooooooooooooo/`
                     .+oooooooooo++oooooooooooooooo+:.
                       .:/+ooooooo-`..--::::::::-.`
                             `-:/oo+
                                `-.
EOF
delay 0.1
echo "[20A"
frame 0 <<'EOF'
[38;5;68m      `-:/+/                                           
    ./oooo+`[1;37;40m         %WELCOME%[38;5;68;49m
   -+ooooo`                                            
  `oooooo/   .-`[1;37;40m     %VERSION%[38;5;68;49m
  .oooooo/ ./++`[1;37;40m     %DISTRO%[38;5;68;49m
   +oooooo/ooo/                                           
   .oooooooooo/  `--                                      
    .+ooooooooo.-+o-                                      
     `/oooooooo+ooo-                             `        
       ./oooooooooo+`                           `+/`      
         .:+oooooooo+-               `-   `/:   /oo/      
           `-/+ooooooo/.`          `-+o `-+o+ `/oooo`     
              `.:+oooooo+:......-:/+ooo:+ooo+/+oooo+      
                 `.:+oooooo+oooooooooooooooooooooo+.      
                    `/+ooooooooo++++oooooooooo++/-`       
                      .-:/++oooo:``...-------.``          
                           `.-/+/                         
                               ``                         
[0m                                                       
EOF
delay 0.1
echo '[20A'
frame 0 <<'EOF'
[38;5;68m     `-/+o:                                       
   `/oooo/[1;37;40m           %WELCOME%[38;5;68;49m
  `+oooo+                                         
  :ooooo/  -//[1;37;40m       %VERSION%[38;5;68;49m
  -ooooo+-+oo-[1;37;40m       %DISTRO%[38;5;68;49m
   /ooooooooo-  `.                                     
   `/oooooooo/`/o/                                     
     -+oooooooooo:                                     
       -+ooooooooo.                         :+.        
         -/oooooooo:`             :.  `+/  .ooo`       
           `-/ooooooo:.        `-+o-.:oo+`:oooo-       
               .:+ooooo+/////+oooooooooooooooo+`       
                  -+oooooooooooooooooooooooo+-         
                   `-:/+ooooo:.--:://///:--`           
                        `.:/o+                         
                            ``                         
[0m                                                       
                                                       
                                                       
EOF
delay 0.1
echo '[20A'
frame 1 <<'EOF'
[38;5;68m        ``                                   
    `:/oo-[1;37;40m           %WELCOME%[38;5;68;49m
   /oooo-                                    
  :oooo+  `.`[1;37;40m        %VERSION%[38;5;68;49m
  /oooo+`:+o.[1;37;40m        %DISTRO%[38;5;68;49m
  .ooooo+ooo   `                                       
   -+ooooooo-./+`                                      
    `/+ooooo+oo+                        `              
      ./+ooooooo:`                 ``  `+/`            
        `-/+ooooo/-`         `-/  -+/ `/oo:            
           `-/+oooo+:......-:+o+:/oo+:+ooo:            
              `./ooooo+ooooooooooooooooo+:`            
                 ./++ooooo/:////++++//:-`              
                   ``.-:/++     ````                   
                         `.                            
[0m                                                       
                                                       
                                                       
                                                       
EOF
delay 0.05
echo '[20A'
frame 2 <<'EOF'
[38;5;68m       ``                               
   `:+o+.[1;37;40m            %WELCOME%[38;5;68;49m
  -oooo-                                
  ooooo  -/`[1;37;40m         %VERSION%[38;5;68;49m
  +oooo:+o/[1;37;40m          %DISTRO%[38;5;68;49m
  .+oooooo/ `:.                                        
   `/oooooo/oo`                                        
     .+ooooooo:                    ./`                 
       .:+ooooo/.          :. `+: `+o/                 
          .:+oooo/-`.``.-:+o:/oo/:ooo+                 
             `:ooooooooooooooooooooo/`                 
               `:/+oooo/-:://////:-`                   
                   `.-/+                     
[0m                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
EOF
delay 0.025
echo '[20A'
frame 3 <<'EOF'
[38;5;68m     `.`                           
  `:+o+`[1;37;40m             %WELCOME%[38;5;68;49m
 `+ooo. ``                         
 `oooo.:+:[1;37;40m           %VERSION%[38;5;68;49m
  /oooooo- ..[1;37;40m        %DISTRO%[38;5;68;49m
   :+oooo+/o.                                          
    `:+ooooo/`          `  ``  /-                      
      `-/+ooo+:`      `-/`-+:`/oo`                     
         `.:+oo+/:////+o++oo++oo/                      
             -/+oooo+//++++++/:.                       
               ``.://   `````                          
                    `                                  
[0m                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
EOF
delay 0.0125
echo '[20A'
frame 4 <<'EOF'
[38;5;68m    .-`                       
  :+o/[1;37;40m               %WELCOME%[38;5;68;49m
 -ooo.`-`                     
 .ooo/+o[1;37;40m             %VERSION%[38;5;68;49m
  -ooooo-/:[1;37;40m          %DISTRO%[38;5;68;49m
   `/ooooo/               `-                           
     `:+ooo+.      `:``/-`+o.                          
        `-/oo+:/:/+oo+oo+oo+`                          
           ./+ooo+://////:-                            
               .-:                                
[0m                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
EOF
delay 0.00625
echo '[20A'
frame 5 <<'EOF'
[38;5;68m   .-`                   
 .+o:[1;37;40m                %WELCOME%[38;5;68;49m
 /oo::/                  
 `/oooo.:[1;37;40m            %VERSION%[38;5;68;49m
   -/oooo.       ` `[1;37;40m %DISTRO%[38;5;68;49m
     .:/oo:.```.:/-oooo:                               
        `:ooooo/ooooo/:`                               
          ``.:: `````                                  
                          
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
EOF
delay 0.00625
echo '[20A'
frame 6 <<'EOF'
[38;5;68m  'o`               
 'ooo`[1;37;40m               %WELCOME%[38;5;68;49m
 `oooo`             
  `oooo`         'o`[1;37;40m %VERSION%[38;5;68;49m
    `ooooo`  `ooooo[1;37;40m  %DISTRO%[38;5;68;49m
       `oooo:oooo`                                 
          `v [40m -                                
[0m                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
EOF
delay 0.05 2
echo '[14A'
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;237malces [1;38;5;232mflight[38;5;68m ]- [0m                                
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;240malces [1;38;5;237mflight[38;5;68m ]- [0m                                
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;243malces [1;38;5;238mflight[38;5;68m ]- [0m                                
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;246malces [1;38;5;239mflight[38;5;68m ]- [0m                                
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;240mflight[38;5;68m ]- [0m                                
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;241mflight[38;5;68m ]- [0m                  
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;244mflight[38;5;68m ]- [0m                   
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;252mflight[38;5;68m ]- [0m                  
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;255mflight[38;5;68m ]- [0m                   
EOF
echo '[2A'
delay 0.05 2
cat <<'EOF'
[38;5;68m          `v [40m -[ [1;38;5;249malces [1;38;5;15mflight[38;5;68m ]- [0m                  
EOF
