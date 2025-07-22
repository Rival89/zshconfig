dobz2 () {
    name=$1;
    if [ "$name" != "" ]; then
        tar cvjf $1.tar.bz2 $1
    fi
}
