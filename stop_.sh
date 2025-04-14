#!/bin/bash

stop_() {
    echo "DISK="$DISK
    echo "boot="$boot
    echo "root="$root
 # Остановка до нажатия клавиш
    read -p "Press key to continue.. " -n1 -s
}
