module magma_math::u128x128 {
    use integer_mate::{full_math_u128, i128::{Self, I128}, i32::{Self, I32}};
    use magma_math::bit_math;
    use std::{u256, u128};

    const LOG_SCALE_OFFSET: u8 = 127;
    const LOG_SCALE: u256 = 1 << LOG_SCALE_OFFSET;
    const LOG_SCALE_SQUARED: u256 = (1 << LOG_SCALE_OFFSET) * (1 << LOG_SCALE_OFFSET);

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

    public fun from_u128x128_dec(x: u256, decimals: u8): (u128, u128) {
        let int = (x >> 128) as u128;
        let fractional_part = (x & ((1 << 128) - 1)) as u128;
        let fraction_base = u128::pow(10, decimals + 5);
        let mut fraction_decimal = 0;
        let mut i = 1;
        while (i < 128) {
            if (fractional_part & (1 << (128 - i)) != 0 ) {
                let x = fraction_base / u128::pow(2, i);
                if (x == 0) {
                    break
                } else {
                    fraction_decimal = fraction_decimal + x;
                };
            };

            i = i + 1;
        };

        (int, fraction_decimal / u128::pow(10, 5))
    }

    // @param x is a Q128 fix-point number
    // @return 128.128-binary fix-point number
    // @return the return number is positive
    public fun log2(mut x: u256): (u256, bool) {
        if (x == 1) {
            return (to_u128x128(128, 0), false)
        };
        if (x == 0) {
            abort (ErrLogUnderflow)
        };

        // XXX: This is only a precaution against bits overflow.
        // Discard the least significant bits of the fraction part.
        x = x >> (128 - LOG_SCALE_OFFSET);
        // LOG_SCALE means "1".
        let sign_positive = if (x >= LOG_SCALE) {
            true
        } else {
            // log₂(x) = -log₂(1/x)
            x = LOG_SCALE_SQUARED / x;
            false
        };
        // integer part
        let (msb, _) = bit_math::most_significant_bit((x >> LOG_SCALE_OFFSET) as u256);
        let mut result = msb as u256 << LOG_SCALE_OFFSET;
        // fractional part
        let mut y = x >> msb;
        if (y != LOG_SCALE) {
            let mut bit_cursor = 1 << (LOG_SCALE_OFFSET - 1);
            while (bit_cursor > 0) {
                y = (y * y) >> LOG_SCALE_OFFSET;
                if (y >= (1 << (LOG_SCALE_OFFSET + 1))) {
                    result = result + bit_cursor;
                    y = y >> 1;
                };
                bit_cursor = bit_cursor >> 1;
            };
        };

        // XXX: Back to Q128.
        (result << (128 - LOG_SCALE_OFFSET), sign_positive)
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

    // @param x: base number in Q128
    // @param y: power in I32 ∈ (-0x100000, 0x100000)
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
            if (x >= (1 << FIX_POINT_BITS)) {
                squared = (max_u() / squared);
                invert = !invert;
            };

            let mut cursor = 0x1;
            while (cursor <= abs_y) {
                if (abs_y & cursor != 0) {
                    result  = (result * squared) >> FIX_POINT_BITS;
                };
                squared = (squared * squared) >> FIX_POINT_BITS;
                cursor = cursor << 1;
            };
            // if (abs_y & 0x1 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x2 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x4 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x8 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x10 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x20 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x40 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x80 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x100 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x200 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x400 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x800 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x1000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x2000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x4000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x8000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x10000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x20000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x40000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
            // squared = (squared * squared) >> FIX_POINT_BITS;
            // if (abs_y & 0x80000 != 0) { result = (result * squared) >> FIX_POINT_BITS; };
        };
        // revert if y is too big or if x^y underflowed
        if (result == 0) {
            abort (ErrPowUnderflow)
        };
        if (invert) {
            (max_u() / result)
        } else {
            result
        }
    }
}
