# SmartKnockdown
A smart knock down target system for Airsoft or Nerf use

This is the beginnings of an electronic knock down target system, the design concept is that each target is free to be stood up or knocked down manually, but an IR sensor and a servo mean that a microcontroller can detect when a target is up or down and itself choose to push the target back up, or knock it down

Included is the source for a couple of simplistic modes, really speaking it needs a web interface writing for the ESP32 and some more interesting game modes, for examples ones which put a target up for a limited time and knock it down again if the user hasn't hit it yet.

As it stands it counts the number of targets that are knocked down as of power up and if it is 1 then it does "one at a time" mode where one randomly chosen target is up, when knocked down it will be replaced by another randomly chosen target.  Any other number of downed targets will just keep all targets up and lift any that fall immediately.

Components required:
* First you need all of the 3D printed Components
* SG90S servo motors, standard 180° versions [Aliexpress](https://www.aliexpress.com/item/1005006063061561.html)
* IR beam break slot type sensors. [Aliexpress](https://www.aliexpress.com/item/1005006984775727.html)
* An ESP32 dev board, i used an ESP-WROOM-32 [Aliexpress](https://www.aliexpress.com/item/1005007061953921.html)
* A 5V power source such as a USB battery bank
* 5x M4 30mm socket cap screws + Nuts
* 5 sets of securing screws that should come with your servo. (M2.5  8mm)
* 10x M2.5 10mm machine screws + nuts to secure the IR slot sensors

A computer USB port does not supply enough current to run all of the servos at once, so it is strongly recommended you suppliment the power with the power bank when debugging, for general use just the battery bank will work.

Improvements welcome, submit a merge request

Assembly

Assemble from the back, left to right, otherwise you will find yourself blocked. 
* First install the IR slot sensors and bolt them down
* second screw the 3d printed gear to each servo
* Install each servo, from left to right, threading the cable through the slot at the rear of the mount, placing the servo behind the face plate and screw in from behind, use a nut on the face if the screw is not tight.
* Then you can work from left to right again pushing a M4 bolt through its mounting hole, the reset arm, and the target pivot, secure it loosly with a nut, make sure the pivot is free to turn.
* finally you can insert the spot or duck targets into each pivot.

When assembling you will need to use your controller to reset each servo to its rest point, and adjust the position of the gears such that the pivot and its target can freely move from upright to laying flat without fouling the reset arm. The servo then should have enough movement in both directions to push on the pivot in order to knock the target down, or stand it up, before returning to the neutral position again.

The servo timings in the file very likely need adjusting, the values there are not what i logically expected them to be, but were what was required to make my board work. So do please forgive them and adjust as necessary.
