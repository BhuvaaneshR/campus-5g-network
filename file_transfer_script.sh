#!/bin/bash

# File Transmission Script for srsRAN Project
# This script sets up full-duplex file transfer between UE1 and UE2

echo "=================================="
echo "File Transmission Module"
echo "=================================="
echo ""
echo "Select UE to run:"
echo "1) UE1 - Receiver (Server Mode)"
echo "2) UE2 - Sender (Client Mode)"
echo "3) Exit"
echo ""
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        echo ""
        echo "Starting UE1 as Receiver..."
        echo "Creating directory: /home/bhuvaan/ue1_rx"
        echo "Listening on 10.45.1.2:7103"
        echo "Waiting for files from UE2..."
        echo "Press Ctrl+C to stop"
        echo ""
        sudo ip netns exec ue1 bash -lc '
        mkdir -p /home/bhuvaan/ue1_rx;
        socat -d -d -v TCP-LISTEN:7103,bind=10.45.1.2,reuseaddr,fork \
        SYSTEM:"sh -c '\''cat > /home/bhuvaan/ue1_rx/ue2_$(date +%Y%m%d_%H%M%S).bin'\''"
        '
        ;;
    2)
        echo ""
        read -p "Enter full path of file to send (e.g., /home/bhuvaan/Desktop/myfile.txt): " filepath
        
        if [ ! -f "$filepath" ]; then
            echo "Error: File not found at $filepath"
            exit 1
        fi
        
        echo ""
        echo "Starting UE2 as Sender..."
        echo "Sending file: $filepath"
        echo "Target: UE1 at 10.45.1.2:7103"
        echo "Press Ctrl+C to cancel"
        echo ""
        sudo ip netns exec ue2 bash -lc \
        "socat -v FILE:$filepath TCP:10.45.1.2:7103,bind=10.45.1.4"
        
        echo ""
        echo "File transfer completed!"
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac