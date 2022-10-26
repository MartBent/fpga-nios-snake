#include "types.h"

bool point_t_equals(const point_t rhs, const point_t lhs) {
    return (rhs.x == lhs.x) && (rhs.y == lhs.y);
}

bool is_between(uint16_t min, uint16_t max, uint16_t val) {
    return ((val < max) && (val > min)) || val == min;
}
