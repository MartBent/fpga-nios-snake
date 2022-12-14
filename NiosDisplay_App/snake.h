#ifndef SNAKE_H
#define SNAKE_H

#define SIZE 32 //Game will always be 32 tiles
#define SQUARE_SIZE SNAKE_RESOLUTION/SIZE //Adjust the square sizes to the resolution ratio
#define SQUARE_DIAMETER SQUARE_SIZE/2 //Used to draw the squares on the left and right side of the point

#include <stdbool.h>  
#include <string.h>
#include <stdlib.h>

#include "types.h"

typedef void (*delayFunction)() ; 
typedef void (*displayFrameFunction)(const u8* buffer, unsigned long resolution);
typedef void (*displayScoreFunction)(const u8 score);
typedef direction_t (*readDirectionFunction)();
typedef u8 (*randomNumberFunction)();

typedef struct {
    uint32_t resolution;
    u8* frame_buffer;
    u8 snake_length;
    u8 background_color;
    u8 food_color;
    u8 snake_color;
    delayFunction delay_function_cb;
    displayFrameFunction display_frame_cb;
    displayScoreFunction display_score_cb;
    readDirectionFunction read_direction_cb;
    randomNumberFunction random_number_cb;
} snake_driver_t;

void draw_game_over(const snake_driver_t* driver);
void fill_buffer(const snake_driver_t* driver, u8 color);
void draw_square(const snake_driver_t* driver, point_t location, u8 color);

bool detect_collision_snake(const snake_t* snake);
void move_snake(const snake_driver_t* driver, snake_t* snake);
char* snake_play(const snake_driver_t* driver);

#endif
