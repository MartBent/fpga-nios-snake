#ifndef SNAKE_C
#define SNAKE_C
#include <stdio.h>

#include "snake.h"

void draw_game_over(const snake_driver_t* driver) {
	const u8 game_over_points_x[96] = {
			2,2,2,2,2,2,2,2,2,2,2,
			3,3,3,3,3,3,3,3,
			4,4,4,4,4,4,4,4,4,4,4,4,4,4,
			5,5,5,5,5,5,5,
			6,6,6,6,6,6,6,6,6,6,6,6,

			10,10,10,10,10,10,10,10,10,10,10,
			11,11,11,11,11,11,11,
			12,12,12,12,12,12,12,12,12,12,
			13,13,13,13,13,13,13,
			14,14,14,14,14,14,14,14,14
	};
	const u8 game_over_points_y[96] = {
			5,6,7,13,14,19,23,27,28,29,30,
			4,12,15,19,20,22,23,27,
			4,6,7,8,12,13,14,15,19,21,23,27,28,29,
			4,8,12,15,19,23,27,
			5,6,7,8,12,15,19,23,27,28,29,30,

			5,6,12,14,19,20,21,22,27,28,29,
			4,7,12,14,19,27,30,
			4,7,12,14,19,20,21,27,28,29,
			4,7,12,14,19,27,29,
			5,6,13,19,20,21,22,27,30
	};
	fill_buffer(driver, driver->background_color);
	for(int i = 0; i < 96; i++) {
		point_t point = {
				.x = game_over_points_x[i],
				.y = game_over_points_y[i]
		};
		draw_square(driver,point, driver->snake_color); 
	}
}
void fill_buffer(const snake_driver_t* driver, u8 color) {
	memset(driver->frame_buffer, color, driver->resolution*driver->resolution);
}

void draw_square(const snake_driver_t* driver, point_t location, u8 color) {
    //Location is valid
    const unsigned int square_size = driver->resolution / 32;
    const unsigned int square_diameter = square_size / 2;

	u8* start = driver->frame_buffer + (driver->resolution*location.x*square_size - square_diameter) + (location.y*square_size);

	for(int i = 0; i < square_size; i++) {
		memset(start, color, square_size);
		start += driver->resolution;
	}

	return;
	//Old algorithm
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

char* snake_play(const snake_driver_t* driver) {

	if(driver->frame_buffer == NULL) {
		return "Frame buffer is NULL, possibly a memory issue?";
	}
	if(driver->display_frame_cb == NULL || driver->delay_function_cb == NULL || driver->display_score_cb == NULL || driver->random_number_cb == NULL || driver->read_direction_cb == NULL) {
		return "Not all callbacks are defined!";
	}

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

    fill_buffer(driver, driver->background_color);
    draw_square(driver, current_food, driver->food_color);

    while(1) {

        direction_t direction = driver->read_direction_cb();
		snake.current_direction = filter_direction(snake.current_direction, direction);

    	//Move snake
		move_snake(driver, &snake);

		//Detect collision with snake
		if(detect_collision_snake(&snake)) {
			draw_game_over(driver);
			driver->delay_function_cb(15000);
			return "Game over, you lost!\n";
		}

    	 //Detect collision food
		if(point_t_equals(snake.current_location, current_food)) {
			snake.length += 1;
			draw_square(driver, snake.point_history[0], driver->snake_color);
			if(snake.length == driver->snake_length) {

				draw_game_over(driver);
				driver->delay_function_cb(15000);
				return "Game over, you won!\n";
			}
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
			draw_square(driver, current_food, driver->food_color);
		}

		draw_square(driver, snake.point_history[snake.length], driver->background_color);
		draw_square(driver, snake.point_history[0], driver->snake_color);

        driver->display_frame_cb((const u8*)driver->frame_buffer, driver->resolution);
        driver->display_score_cb(snake.length);

        //Delay
        driver->delay_function_cb(200);
    }   
}

#endif
