#ifndef SNAKE_C
#define SNAKE_C
#include <stdio.h>

#include "snake.h"

void clear_buffer(const snake_driver_t* driver) {
    for(u8 x = 0; x < driver->resolution; x++) {
        for(u8 y = 0; y < driver->resolution; y++) {
            *(u8*)(driver->frame_buffer+(driver->resolution*x)+y) = 0x00;
        }
    }
}

void draw_square(const snake_driver_t* driver, point_t location) {
    //Location is valid
    const unsigned int square_size = driver->resolution / 32;
    const unsigned int square_diameter = square_size / 2;

    if(location.x < SIZE && location.y < SIZE) {
        for(u8 x = 0; x < driver->resolution; x++) {
            for(u8 y = 0; y < driver->resolution; y++) {
                if(is_between(location.x*square_size - square_diameter, location.x*square_size  + square_diameter, x) && 
                   is_between(location.y*square_size - square_diameter, location.y*square_size  + square_diameter, y)) {
                    *(u8*)(driver->frame_buffer+(driver->resolution*x)+y) = 0xFF;
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
            snake->current_location.y = snake->current_location.y == 0 ? SIZE-1 : snake->current_location.y - 1;
            break;
        }
        case right: {
            snake->current_location.x = snake->current_location.x == SIZE ? 1 : snake->current_location.x + 1;
            break;
        }
        case left: {
            snake->current_location.x = snake->current_location.x == 0 ? SIZE-1 : snake->current_location.x - 1;
            break;
        }
    }

    memmove(&snake->point_history[1], &snake->point_history[0], (driver->snake_length-1)*sizeof(point_t));
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

    while(1) {

        direction_t direction = driver->read_direction_cb();
        if(filter_direction(snake.current_direction, direction)) {
        	snake.current_direction = direction;
        }
        
        clear_buffer(driver);

        for(int i = 0; i < snake.length; i++) {
            draw_square(driver, snake.point_history[i]);
        }

        draw_square(driver, current_food);

        driver->display_frame_cb((const u8*)driver->frame_buffer, driver->resolution);
        driver->display_score_cb(snake.length);

        //Move snake
        move_snake(driver, &snake);

        //Detect collision with food / snake
        if(detect_collision_snake(&snake)) {
            driver->delay_function_cb(10000);
        }

        if(point_t_equals(snake.current_location, current_food)) {
            snake.length += 1;
            current_food.x = driver->random_number_cb();
            current_food.y = driver->random_number_cb();
        }

        //Process any food
        driver->delay_function_cb(200);
    }   
}

#endif
