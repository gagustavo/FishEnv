#!/usr/bin/fish
function mkvirtualenv -d 'Create virtualenv on the current directory'
    if test -z (cat $HOME/.fishenvs/envs | egrep -i "^$argv[1]" | head -n 1)
        set dir (pwd)
        mkdir -p "$HOME/.fishenvs/"
        cd "$HOME/.fishenvs/"
        virtualenv $argv[1]
        echo "$argv[1] $dir" >> ~/.fishenvs/envs
        cd $dir
    else
        set_color F00
        echo "Env with this alias already exists"
        set_color normal
    end
end

function workon -d 'Loads $arg env and cd in to env\'s folder'
    . $HOME/.fishenvs/$argv[1]/bin/activate.fish
    set -U fishenv $argv[1]
    cd (get_env_dir $argv[1])
end

function get_env_dir
    echo (cat "$HOME/.fishenvs/envs" | egrep "^$argv[1]" | cut -d' ' -f2- | head -n 1)
end

function workon_dir -d 'Changes the directory of the working env or $arg env'
    if test -z $fishenv
        set -U fishenv $argv[1]
    end
    set dir (pwd)
    cat "$HOME/.fishenvs/envs" | egrep -v "^$fishenv" > $HOME/.fishenvs/envs
    echo "$fishenv $dir" >> ~/.fishenvs/envs
end

function __fish_fishenv_using_command
    set opts (commandline -opc)
    if [ (count $opts) = 1 ]
        return 0
    end
    return 1
end

complete -c workon -f -n "__fish_fishenv_using_command" -a "(cat "$HOME/.fishenvs/envs" | cut -d' ' -f1 )" -d "Virtual Env"
