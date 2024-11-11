#!/bin/bash

# Matar el proceso de Waybar si está corriendo
pkill waybar

# Esperar un momento para asegurarse de que el proceso ha terminado
sleep 1

# Iniciar Waybar nuevamente
waybar &

