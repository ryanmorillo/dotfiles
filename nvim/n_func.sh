function n() {
if [[ $# < 1 ]];then
    echo "Usage: n filename"
    exit 0
fi
NVIM_LISTEN_ADDRESS=$(lsof -U |awk '/^nvim/ && /tmp/ {print $9} ' | head -n1)
if [[ -z $NVIM_LISTEN_ADDRESS ]];then
    echo "No nvim"
    nvim $@ 
elif [[ -S "$NVIM_LISTEN_ADDRESS" ]] ; then
    # There is an n in the background, so we'll load the new  file.
    NFNAME=$(realpath $@)
    echo "Loading " $NFNAME
    NARGS="'socket', path='$NVIM_LISTEN_ADDRESS'"
    (python -c "from neovim import attach;nvim = attach($NARGS);nvim.command('tabe $NFNAME')" &)
    echo $NFNAME “Loaded” 
else
    unset NVIM_LISTEN_ADDRESS
    echo "No nvim but NVIM_LISTEN_ADDRESS was set"
    nvim $@ 
fi
if [[ -n $NVIM_LISTEN_ADDRESS ]];then
    export NVIM_LISTEN_ADDRESS=$NVIM_LISTEN_ADDRESS
fi
}
