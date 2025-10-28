# Snake on FPGA
This project is about the implementation of a snake game on a FPGA board, the board used:

http://www.ee.ic.ac.uk/pcheung/teaching/ee2_digital/de1-soc_user_manual.pdf

Playing snake on a VGA monitor

![Snake](https://i.imgur.com/IClmkOl.gif)

The snake game is implemented by using several components. These components can either be made of out software, hardware, or synthesized from VHDL.

An overview of the components:
![system](https://user-images.githubusercontent.com/45065264/202497424-b01fb19b-e4cd-4ca1-8184-32c7d2b0e7d9.png)

## Snake driver 
The snake is a implementation of the snake game in C. It is platform independant and therefore it is able to run on a Nios II CPU. See more: https://github.com/MartBent/portable-snake

## Nios II/e
The Nios II is a VHDL component which simulates a complete CPU. this CPU can run program written in C using a memory block from the QSys platform designer in combination with a VHDL JTAG interface to program the code. It is used to run the Snake driver

## VGA Driver
The VGA driver is a VHDL components which is responsible for driving a VGA screen connected to the VGA output of the FPGA board. The components accepts RGB values for each pixel. These values are retrieved from the Frame buffer.

## Frame Buffer 
The Frame buffer is a VHDL component taken from the QSys platform designer. It is a memory array which is connected to the Nios II softcore CPU, connections are also exposed to the VHDL Top-level system. It is used to pass pixel data form the program running on the Nios to the VGA driver.

## Score display
The score display is a double 7-segment display encoder which is able to show a 6 bit number on 2 7-segemnt displays. It is used to display the game's current score.
