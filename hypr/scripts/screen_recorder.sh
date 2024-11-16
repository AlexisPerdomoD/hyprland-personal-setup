#!/usr/bin/env zsh

# Este script se encarga de grabar la pantalla en un archivo de vídeo utilizando slurp y wf-recorder.

# Se utiliza slurp para seleccionar la región de captura y wf-recorder para grabar la pantalla.

# El archivo de vídeo se guarda en la carpeta "Videos/Screencasts" del usuario.
# El script comprueba si slurp y wf-recorder están instalados y si se ha seleccionado una región de captura antes de iniciar la grabación.
# Si se selecciona una región de captura, el script ejecuta slurp para seleccionar la región y luego ejecuta wf-recorder para grabar la pantalla.
# Si no se selecciona una región de captura, el script notifica al usuario y finaliza la grabación.
# Si existe un archivo de vídeo en curso, el script notifica al usuario y finaliza la grabación.
if ! command -v slurp &>/dev/null; then
    notify-send -i dialog-warning "Missing dependency" "slurp is not installed. Please install it to use this feature."
    exit 1
fi

if ! command -v wf-recorder &>/dev/null; then
    notify-send -i dialog-warning "Missing dependency" "wf-recorder is not installed. Please install it to use this feature."
    exit 1
fi

if [ -f /tmp/wf-recorder.pid ]; then
    kill $(cat /tmp/wf-recorder.pid)
    rm /tmp/wf-recorder.pid
    notify-send -i dialog-information "Recording stopped" "Recording stopped. File properly saved."
else

    output_file="$HOME/Videos/Screencasts/recording-$(date +%F_%T).mkv"
    mkdir -p "$(dirname "$output_file")"
    slurp_output=$(slurp)
    if [ -n "$slurp_output" ]; then
        wf-recorder -g "$slurp_output" -f "$output_file" &
        echo $! >/tmp/wf-recorder.pid
        notify-send -i dialog-information "Recording started" "Recording started. File is being saved in $output_file"
    else
        notify-send -i dialog-error "No region selected" "No region selected. Recording  propcess stopped."
    fi
fi

sleep 300
if [ -f /tmp/wf-recorder.pid ]; then
    kill $(cat /tmp/wf-recorder.pid)
    rm /tmp/wf-recorder.pid
    notify-send -i dialog-information "Recording stopped" "Recording stopped. File properly saved."
fi
# Referencia para convertir mka a mp4:
# ffmpeg -i recording-2024-10-24_16:25:29.mkv -codec copy demo-filtros.mp4
