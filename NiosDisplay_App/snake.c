#ifndef SNAKE_C
#define SNAKE_C
#include <stdio.h>

#include "snake.h"

void clear_buffer(const snake_driver_t* driver) {
	memset(driver->frame_buffer, 0x00, driver->resolution*driver->resolution);
}

void draw_square(const snake_driver_t* driver, point_t location, u8 color) {
    //Location is valid
    const unsigned int square_size = driver->resolution / 32;
    const unsigned int square_diameter = square_size / 2;

    const uint16_t left_x_bounds = location.x*square_size - square_diameter;
    const uint16_t right_x_bounds = location.x*square_size + square_diameter;

    const uint16_t upper_y_bounds = location.y*square_size - square_diameter;
	const uint16_t lower_y_bounds = location.y*square_size + square_diameter;


    if(location.x < SIZE && location.y < SIZE) {
        for(uint32_t x = 0; x < driver->resolution; x++) {
            for(uint32_t y = 0; y < driver->resolution; y++) {
                if(is_between(left_x_bounds, right_x_bounds, x) && is_between(upper_y_bounds, lower_y_bounds, y)) {
                    *(u8*)(driver->frame_buffer+(driver->resolution*x)+y) = color;
                }
            }
        }
    }
}

bool detect_collision_snake(const snake_t* snake) {
    for(int i = 1; i < snake->length; i++) {
        if(point_t_equals(snake->current_location, snake->point_history[i])) {
            return true;
        }
    }
    return false;
}

void move_snake(const snake_driver_t* driver, snake_t* snake) {
    switch(snake->current_direction) {
        case down: {
            snake->current_location.y = snake->current_location.y == SIZE ? 1 : snake->current_location.y + 1;
            break;
        }
        case up: {
            snake->current_location.y = snake->current_location.y == 1 ? SIZE-1 : snake->current_location.y - 1;
            break;
        }
        case right: {
            snake->current_location.x = snake->current_location.x == SIZE ? 1 : snake->current_location.x + 1;
            break;
        }
        case left: {
            snake->current_location.x = snake->current_location.x == 1 ? SIZE-1 : snake->current_location.x - 1;
            break;
        }
    }

    //Shift the points
    memmove(&snake->point_history[1], &snake->point_history[0], 32*sizeof(point_t));
    snake->point_history[0] = snake->current_location;
}

direction_t filter_direction(direction_t current_direction, direction_t direction) {
    if(direction == up && current_direction != down) {
        return up;
    }
    if(direction == down && current_direction != up) {
        return down;
    }
    if(direction == left && current_direction != right) {
        return left;
    }
    if(direction == right && current_direction != left) {
        return right;
    }
    return current_direction;
}

void snake_play(const snake_driver_t* driver) {
    
    snake_t snake = {
        .current_direction = right,
        .current_location = {16,16},
        .length = 1,
        .point_history = {}
    };
    snake.point_history[0] = snake.current_location;

    point_t current_food = {
        driver->random_number_cb(),
        driver->random_number_cb()
    };

    clear_buffer(driver);
    draw_square(driver, current_food, 0x5A);

    while(1) {

        direction_t direction = driver->read_direction_cb();
		snake.current_direction = filter_direction(snake.current_direction, direction);

    	//Move snake
		move_snake(driver, &snake);

		//Detect collision with snake
		if(detect_collision_snake(&snake)) {
			driver->delay_function_cb(10000);
		}

    	 //Detect collision food
		if(point_t_equals(snake.current_location, current_food)) {
			snake.length += 1;
			draw_square(driver, snake.point_history[0], 0xFF);
			current_food.x = driver->random_number_cb();
			current_food.y = driver->random_number_cb();
			bool valid = false;
			while(!valid) {
				for(int i = 0; i < snake.length; i++) {
					if(point_t_equals(snake.point_history[i], current_food)) {
						valid = false;
						current_food.x = driver->random_number_cb();
						current_food.y = driver->random_number_cb();
						break;
					}
				}
				valid = true;
			}
			draw_square(driver, current_food, 0x5A);
		}

		draw_square(driver, snake.point_history[snake.length], 0x00);
		draw_square(driver, snake.point_history[0], 0xFF);

        driver->display_frame_cb((const u8*)driver->frame_buffer, driver->resolution);
        driver->display_score_cb(snake.length);

        //Delay
        driver->delay_function_cb(200);
    }   
}

#endif
