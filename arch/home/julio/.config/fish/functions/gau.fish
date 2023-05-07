function gau --wraps='git add -u' --wraps='git add -u; echo Added contents to the git staging area' --wraps='git add -u; echo 🚀Added contents to the git staging area' --wraps=git\ add\ -u\;\ eche\ \\U1F680\ Added\ contents\ to\ the\ git\ staging\ area --wraps=git\ add\ -u\;\ echo\ \\U1F680\ Added\ contents\ to\ the\ git\ staging\ area --description 'alias gau git add -u; echo Added contents to the git staging area'
  git add -u; echo Added contents to the git staging area $argv
        
end
