module magma_math::u128x128;

use std::u256;

use integer_mate::i128::{Self, I128};
use integer_mate::i32::{Self, I32};
use integer_mate::full_math_u128;

use magma_math::bit_math;

const LOG_SCALE_OFFSET: u8 = 127;
const LOG_SCALE: u256 = 1 << LOG_SCALE_OFFSET;
const LOG_SCALE_SQUARED: u256 = (1 << 127) * (1 << 127);

const INTEGER_BITS: u8 = 128;
const FIX_POINT_BITS: u8 = 128;
const MAX_U256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

#[error]
const ErrLogUnderflow: vector<u8> = b"log underflow";
#[error]
const ErrPowUnderflow: vector<u8> = b"pow underflow";

public fun to_u128x128(x: u128, decimals: u8): u256 {
    (x as u256 << 128) / u256::pow(10, decimals)
}

public fun from_u128x128(x: u256): (u128, u128) {
    ((x >> 128) as u128, (x & ((1 << 128) - 1)) as u128)
}

// @return 128.128-binary fix-point number
public fun log2(mut x: u256): (u256, bool) {
    if (x == 1) {
        return (to_u128x128(128, 0), false)
    };
    if (x == 0) {
        abort(ErrLogUnderflow)
    };

    // drop the least significant bit of the fraction part
    x = x >> 1;

    let sign_positive = if (x >= LOG_SCALE) {
        true
    } else {
        x = LOG_SCALE_SQUARED / x;
        false
    };

    let n = bit_math::most_significant_bit((x >> LOG_SCALE_OFFSET) as u256);
    let mut result = n as u256 << LOG_SCALE_OFFSET;
    let mut y = x >> n;
    if (y != LOG_SCALE) {
        let mut delta = 1 << (LOG_SCALE_OFFSET - 1);
        while (delta > 0) {
            y = (y * y) >> LOG_SCALE_OFFSET;
            if (y >= (1 << (LOG_SCALE_OFFSET + 1))) {
                result = result + delta;
                y = y >> 1;
            };
            delta = delta >> 1;
        };
    };

    (result << 1, sign_positive)
}

fun max_u(): u256 {
    let bits = (FIX_POINT_BITS as u16) + (INTEGER_BITS as u16);
    assert!(bits <= 256);
    if (bits == 256) {
        MAX_U256
    } else {
        (1 << (FIX_POINT_BITS + INTEGER_BITS)) - 1
    }
}

public fun pow(x: u256, y: I32): u256 {
    let mut invert = false;

    if (x == 0) {
        return 0
    };

    if (y.eq(i32::zero())) {
        return 1 << FIX_POINT_BITS
    };

    let abs_y = y.abs_u32() as u128;
    if (y.is_neg()) {
        invert = !invert;
    };
    let mut result = 0u256;
    if (abs_y < 0x100000) {
        result = 1 << FIX_POINT_BITS;

        let mut squared = x;
        if (x > ((1 << FIX_POINT_BITS) - 1)) {
            squared = (max_u() / squared);
            invert = !invert;
        };

        if (abs_y & 0x1 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS ;
        if (abs_y & 0x2 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x4 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x8 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x10 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x20 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x40 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x80 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x100 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x200 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x400 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x800 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x1000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x2000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x4000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x8000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x10000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x20000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x40000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        squared = (squared * squared) >> FIX_POINT_BITS;
        if (abs_y & 0x80000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
    };

    // revert if y is too big or if x^y underflowed
    if (result == 0) {
        abort(ErrPowUnderflow)
    };

    if (invert) {
        (max_u() / result)
    } else {
        result
    }
}
