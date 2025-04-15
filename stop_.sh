#!/bin/bash

stop_() {

    echo "   region="$region
    echo "     name="$name
    echo "  mirror_="$mirror
    echo "     DISK="$DISK
    echo "     boot="$boot
    echo "     root="$root
 # Остановка до нажатия клавиш
    read -p "Press key to continue.. " -n1 -s
}
 