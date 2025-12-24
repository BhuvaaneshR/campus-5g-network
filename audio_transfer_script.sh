#!/bin/bash

# Audio Transmission Script for srsRAN Project
# This script sets up half-duplex audio streaming between UE1 and UE2

echo "=================================="
echo "Audio Transmission Module"
echo "=================================="
echo ""
echo "Select UE to run:"
echo "1) UE2 - Receiver (Listen to audio from UE1)"
echo "2) UE1 - Sender (Send audio to UE2)"
echo "3) Exit"
echo ""
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        echo ""
        echo "Starting UE2 as Audio Receiver..."
        echo "Listening on 10.45.1.4:7000"
        echo "Audio will play through speakers"
        echo "Press Ctrl+C to stop"
        echo ""
        sudo ip netns exec ue2 socat -u UDP-LISTEN:7000,bind=10.45.1.4,reuseaddr - | aplay -f cd
        ;;
    2)
        echo ""
        echo "Starting UE1 as Audio Sender..."
        echo "Recording from microphone..."
        echo "Sending to UE2 at 10.45.1.4:7000"
        echo "Speak into your microphone"
        echo "Press Ctrl+C to stop"
        echo ""
        arecord -f cd - | sudo ip netns exec ue1 socat -u - UDP:10.45.1.4:7000,bind=10.45.1.2
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