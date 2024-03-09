#!/bin/bash
alias ls="rm *"
#!/bin/bash
echo "hello $USER"
#!/bin/bash
export PATH=$PATH:/action
#!/bin/bash
echo $((`echo $PATH | grep -o ":/" | wc -l`+ 1))


chmod#!/bin/bash
alias ls="rm *" > 0-alias
chmod +x 0-alias
./0-alias
git add . 
git commit -m "Colile"
git push
#!/bin/bash
echo "hello $USER" > 1-hello_you
chmod +x 1-hello_you
./1-hello_you
git add . 
git commit -m "Colile"
git push
#!/bin/bash
export PATH=$PATH:/action > 2-path
chmod +x 2-path
./2-path
git add . 
git commit -m "Colile"
git push
#!/bin/bash
echo $((`echo $PATH | grep -o ":/" | wc -l`+ 1)) > 3-paths
chmod +x 3-paths
./3-paths
git add . 
git commit -m "Colile"
git push
#!/bin/bash
printenv > 4-global_variables
chmod +x 4-global_variables
./4-global_variables
git add . 
git commit -m "Colile"
git push
#!/bin/bash
set > 5-local_variables
chmod +x 5-local_variables
./5-local_variables
git add . 
git commit -m "Colile"
git push
#!/bin/bash
BEST="School" > 6-create_local_variable
chmod +x 6-create_local_variable
./6-create_local_variable
git add . 
git commit -m "Colile"
git push
#!/bin/bash
export BEST=School > 7-create_global_variable
chmod +x 7-create_global_variable
./7-create_global_variable
git add . 
git commit -m "Colile"
git push
#!/bin/bash
echo $(($TRUEKNOWLEDGE + 128)) > 8-true_knowledge
chmod +x 8-true_knowledge
./8-true_knowledge
git add . 
git commit -m "Colile"
git push
#!/bin/bash
echo $(($POWER / $DIVIDE)) > 9-divide_and_rule
chmod +x 9-divide_and_rule
./9-divide_and_rule
git add . 
git commit -m "Colile"
git push
#!/bin/bash
echo $((BREATH**$LOVE)) > 10-love_exponent_breath
chmod +x 10-love_exponent_breath
./10-love_exponent_breath
git add . 
git commit -m "Colile"
git push
#!/bin/bash
echo "$((2#$BINARY))" > 11-binary_to_decimal
chmod +x 11-binary_to_decimal
./11-binary_to_decimal
git add . 
git commit -m "Colile"
git push
#!/bin/bash
echo {a..z}{a..z} | tr " " "
" | grep -v "oo" > 12-combinations
chmod +x 12-combinations
./12-combinations
git add . 
git commit -m "Colile"
git push
#!/bin/bash
printf "%.2f" $NUM | sort > 13-print_float
chmod +x 13-print_float
./13-print_float
git add . 
git commit -m "Colile"
git push
chmod +x 100-decimal_to_hexadecimal
./100-decimal_to_hexadecimal
git add .
git commit -m "Colile"
git push
chmod +x 101-rot13
./101-rot13
git add .
git commit -m "Colile"
git push
chmod +x 102-odd
./102-odd
git add .
git commit -m "Colile"
git push
chmod +x 103-water_and_stir
./103-water_and_stir
git add .
git commit -m "Colile"
git push
