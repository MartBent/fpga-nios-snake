#include "types.h"

bool point_t_equals(const point_t rhs, const point_t lhs) {
    return (rhs.x == lhs.x) && (rhs.y == lhs.y);
}

bool is_between(u8 min, u8 max, u8 val) {
    return ((val < max) && (val > min)) || val == min;
}