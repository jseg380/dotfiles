# Completions for vagrant

# set -l progname vagrant

# set -l listmachines "(sed -n 's/^\s*config.vm.define \"\([^\\\"]*\)\".*/\1/p' Vagrantfile)"

# set -l existsvagrantfile "test -f Vagrantfile"

# complete -c $progname

# complete -c $progname -n "$existsvagrantfile" -fa "status"

# complete -c "$progname up" -n "$existsvagrantfile" -fa "$listmachines"

# complete -c vagrant -n '__fish_seen_subcommand_from sum' -l 'sum' -f -a "1 3 5"
