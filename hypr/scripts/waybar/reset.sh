#!/usr/bin/bash
# Matar el proceso de Waybar si está corriendo
killall waybar
sleep 0.25
waybar &
# Iniciar Waybar nuevamente
