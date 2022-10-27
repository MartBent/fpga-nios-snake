#include "sys/alt_irq.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <stdio.h>
#include <unistd.h>
#include "sys/alt_irq.h"
#include "snake.h"

volatile int edge_capture;
static direction_t direction = down;

void delay(unsigned long msec)
{
    usleep(msec*100);
}

void display_flush(const u8* grid, const unsigned long resolution) {
    //memcpy(FRAME_BUFFER_BASE, grid, resolution*resolution);
}
u8 rnd() {
    return rand() % 32;
}

void display_score(u8 score) {

}

direction_t read_direction() {
    return direction;
}

static void interrupt(void* c) {
	volatile int* edge_capture_ptr = (volatile int*)c;
	*edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(BTN_PIO_BASE);
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BTN_PIO_BASE, 0);

	//Direction are calculated differently because the frame is rotated
	switch(edge_capture) {
		case 8:
			printf("Left");
			direction = up;
			break;
		case 4:
			printf("Down");
			direction = right;
			break;
		case 2:
			printf("Up");
			direction = left;
			break;
		case 1:
			printf("Right");
			direction = down;
			break;
	}
	//No debounce required in this particular application
}

int main(void) {

	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(BTN_PIO_BASE, 0xf);
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BTN_PIO_BASE, 0x0);
	void* edge_capture_ptr = (void*) &edge_capture;
	alt_ic_isr_register(BTN_PIO_IRQ_INTERRUPT_CONTROLLER_ID, BTN_PIO_IRQ, interrupt, edge_capture_ptr, NULL);

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
