#!/usr/bin/env bash
#==================HEADER============================================|
#AUTOR
# Jefferson Rocha
#
# Resolve o problema para ativar o led no teclado CM-DEVASTATOR
# Cooler Master Devastator - LED Gaming Keyboard 
#====================================================================|

#=======================VARS

led_off='00000000'
key_code='78'

# LED Mask
LED_STATUS=$(xset -q | grep "LED" | awk '{print $10}')

# Scroll Lock off
xmodmap -e 'keycode ${key_code}='

# On
if [[ "$LED_STATUS" = "${led_off}" ]]; then
    xset led 3 # on LED
else
    xset -led 3 # off LED
fi

exit 0
