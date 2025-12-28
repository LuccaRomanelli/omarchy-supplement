#!/bin/bash

# USB Mode Switch - Detects and switches USB adapters from storage mode to modem mode
# Runs automatically without prompts for use in start.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== USB Mode Switch ==="
echo ""

# Check if usb_modeswitch is installed, install if not
if ! command -v usb_modeswitch &>/dev/null; then
    echo "usb_modeswitch not found, installing..."
    "$SCRIPT_DIR/install-pacman-package.sh" usb_modeswitch
fi

# Check if lsusb is installed, install if not
if ! command -v lsusb &>/dev/null; then
    echo "lsusb not found, installing..."
    "$SCRIPT_DIR/install-pacman-package.sh" usbutils lsusb
fi

echo "Connected USB devices:"
echo ""
lsusb
echo ""

# Known vendors that use storage mode (can expand)
declare -A KNOWN_VENDORS=(
    ["0e8d"]="MediaTek"
    ["12d1"]="Huawei"
    ["19d2"]="ZTE"
    ["1bbb"]="T&A Mobile Phones"
)

echo "Searching for devices in storage mode..."
echo ""

found=0
while IFS= read -r line; do
    # Extract vendor and product ID
    if [[ $line =~ ID[[:space:]]([0-9a-f]{4}):([0-9a-f]{4}) ]]; then
        vendor="${BASH_REMATCH[1]}"
        product="${BASH_REMATCH[2]}"

        # Check if it's a known vendor
        if [[ -n "${KNOWN_VENDORS[$vendor]}" ]]; then
            device_name=$(echo "$line" | cut -d' ' -f7-)
            echo "Found: ${KNOWN_VENDORS[$vendor]} (ID $vendor:$product)"
            echo "  Description: $device_name"
            echo "  Executing usb_modeswitch..."

            sudo usb_modeswitch -v "$vendor" -p "$product"

            # Wait for device to reconnect
            sleep 2

            echo "  Mode switch executed"
            echo ""
            echo "  Checking new network interfaces..."
            ip link show | grep -E "^[0-9]+:" | grep -v "lo:"
            echo ""

            found=1
        fi
    fi
done < <(lsusb)

if [ $found -eq 0 ]; then
    echo "No known devices found in storage mode"
    echo ""
    echo "For manual execution with a known device ID:"
    echo "  sudo usb_modeswitch -v VENDOR_ID -p PRODUCT_ID"
    echo ""
    echo "Example for MediaTek 0e8d:2870:"
    echo "  sudo usb_modeswitch -v 0e8d -p 2870"
fi

echo ""
echo "=== Done ==="
