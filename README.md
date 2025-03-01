# SmartKnockdown
A smart knock down target system for Airsoft or Nerf use

This is the beginnings of an electronic knock down target system, the design concept is that each target is free to be stood up or knocked down manually, but an IR sensor and a servo mean that a microcontroller can detect when a target is up or down and itself choose to push the target back up, or knock it down

Included is the source for a couple of simplistic modes, really speaking it needs a web interface writing for the ESP32 and some more interesting game modes, for examples ones which put a target up for a limited time and knock it down again if the user hasn't hit it yet.

As it stands it counts the number of targets that are knocked down as of power up and if it is 1 then it does "one at a time" mode where one randomly chosen target is up, when knocked down it will be replaced by another randomly chosen target.  Any other number of downed targets will just keep all targets up and lift any that fall immediately.

Components required:
* First you need all of the 3D printed Components
* SG90S servo motors, standard 180° versions
* IR beam break slot type sensors.
* An ESP32 dev board, i used an ESP-WROOM-32 
* A 5V power source such as a USB battery bank

A computer USB port does not supply enough current to run all of the servos at once, so it is strongly recommended you suppliment the power with the power bank when debugging, for general use just the battery bank will work.

https://www.aliexpress.com/item/1005006984775727.html
https://www.aliexpress.com/item/1005006063061561.html
https://www.aliexpress.com/item/1005007061953921.html


