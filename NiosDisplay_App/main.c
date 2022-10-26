/*
* main.c
*
* Created on: Oct 17, 2017
* Author: chris @ Saxion
*/
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include "snake.h"

void delay(unsigned long msec)
{
    //usleep(msec*1000);
}

void display_flush(const u8* grid, const unsigned long resolution) {
    memcpy(FRAME_BUFFER_BASE, grid, resolution*resolution);
}
u8 rnd() {
    return rand() % 32;
}

void display_score(u8 score) {

}

direction_t read_direction() {
	//Read IOs
	static direction_t direction = down;

	uint8_t data = IORD_ALTERA_AVALON_PIO_DATA(BTN_PIO_BASE);

	if(data == 11) {
		direction = right;
	}
	else if(data == 7) {
		direction = up;
	}
	else if(data == 14) {
		direction = down;
	}
	else if(data == 13) {
		direction = left;
	}
    return direction;
}

int main(void) {
	srand(1235);

	snake_driver_t driver;
	driver.delay_function_cb = delay;
	driver.display_frame_cb = display_flush;
	driver.display_score_cb = display_score;
	driver.random_number_cb = rnd;
	driver.read_direction_cb = read_direction;
	driver.resolution = 512;
	driver.snake_length = 16;
	driver.frame_buffer = FRAME_BUFFER_BASE;
	printf("start snake\n");
	snake_play(&driver);
	printf("err\n");
}
