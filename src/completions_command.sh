# shellcheck disable=SC2215
name: completions
help: Generate bash autocompletions script

examples:
- eval "\$(zphp completions)"
---
#########################################
## Get the completions function
##
## Output:
##   Writes the completions function to STDOUT
#########################################
send_completions
