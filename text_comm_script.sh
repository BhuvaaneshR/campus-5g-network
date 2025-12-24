#!/bin/bash

# Text Communication Script for srsRAN Project
# This script sets up full-duplex text communication between UE1 and UE2

echo "=================================="
echo "Text Communication Module"
echo "=================================="
echo ""
echo "Select UE to run:"
echo "1) UE2 - Server (Listen Mode)"
echo "2) UE1 - Client (Connect Mode)"
echo "3) Exit"
echo ""
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        echo ""
        echo "Starting UE2 in Server Mode..."
        echo "Listening on 10.45.1.4:7000"
        echo "Waiting for UE1 to connect..."
        echo "Type your messages and press Enter to send"
        echo "Press Ctrl+C to stop"
        echo ""
        sudo ip netns exec ue2 socat -d -d TCP-LISTEN:7000,bind=10.45.1.4,reuseaddr,fork STDIO
        ;;
    2)
        echo ""
        echo "Starting UE1 in Client Mode..."
        echo "Connecting to UE2 at 10.45.1.4:7000"
        echo "Type your messages and press Enter to send"
        echo "Press Ctrl+C to stop"
        echo ""
        sudo ip netns exec ue1 socat -d -d STDIO TCP:10.45.1.4:7000,bind=10.45.1.2
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