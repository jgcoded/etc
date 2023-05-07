
if status is-interactive
    # Commands to run in interactive sessions can go here
    set --erase SSH_AGENT_PID
    if ! set -q gnupg_SSH_AUTH_SOCK_by; or test $gnupg_SSH_AUTH_SOCK_by != $fish_pid
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
end

