#!/usr/bin/bash

STEP=5
VCP=10    # código VCP para brillo
MONITOR=1 # número del monitor si tienes más de uno

current=$(ddcutil getvcp $VCP --brief --display $MONITOR | awk '{print $4}')
action=$1

case "$action" in
up)
    new=$((current + STEP))
    ;;
down)
    new=$((current - STEP))
    ;;
*)
    echo "Uso: $0 up | down"
    exit 1
    ;;
esac

# limita entre 0 y 100
new=$(($new < 0 ? 0 : ($new > 100 ? 100 : $new)))

sudo ddcutil setvcp $VCP $new --display $MONITOR
echo "Brillo ajustado a $new"
