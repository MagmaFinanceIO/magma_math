module magma_math::bit_math {
    const U256_MAX: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    const U128_MAX: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    const U64_MAX: u256 = 0xFFFFFFFFFFFFFFFF;
    const U32_MAX: u256 = 0xFFFFFFFF;
    const U16_MAX: u256 = 0xFFFF;
    const U8_MAX: u256 = 0xFF;
    const U4_MAX: u256 = 0xF;

    /**
 * @dev Returns the index of the closest bit on the right of x that is non null
 * @param x The value as a uint256
 * @param bit The index of the bit to start searching at
 * @return id The index of the closest non null bit on the right of x.
 * If there is no closest bit, it returns (, false)
 */
    public fun closest_bit_right(x: u256, bit: u8): (u8, bool) {
        let shift = 255 - bit;
        let x = x << shift;
        return if (x == 0) {
            (0, false)
        } else {
            let (msb, _) = most_significant_bit(x);
            (msb - shift, true)
        }
    }

    /**
 * @dev Returns the index of the closest bit on the left of x that is non null
 * @param x The value as a uint256
 * @param bit The index of the bit to start searching at
 * @return id The index of the closest non null bit on the left of x.
 * If there is no closest bit, it returns (, false)
 */
    public fun closest_bit_left(x: u256, bit: u8): (u8, bool) {
        let x = x >> bit;
        return if (x == 0) {
            (0, false)
        } else {
            let (lsb, _) = least_significant_bit(x);
            (lsb + bit, true)
        }
    }

    /**
 * @dev Returns the index of the most significant bit of x
 * This function returns 0 if x is 0
 * @param x The value as a uint256
 * @return msb The index of the most significant bit of x
 */
    public fun most_significant_bit(mut bits: u256): (u8, bool) {
        if (bits == 0) {
            return (0, false)
        };
        let mut msb = 0;
        if (bits > U128_MAX) {
            bits = bits >> 128;
            msb = 128;
        };
        if (bits > U64_MAX) {
            bits = bits >> 64;
            msb = msb + 64;
        };
        if (bits > U32_MAX) {
            bits = bits >> 32;
            msb = msb + 32;
        };
        if (bits > U16_MAX) {
            bits = bits >> 16;
            msb = msb + 16;
        };
        if (bits > U8_MAX) {
            bits = bits >> 8;
            msb = msb + 8;
        };
        if (bits > U4_MAX) {
            bits = bits >> 4;
            msb = msb + 4;
        };
        if (bits > 0x3) {
            bits = bits >> 2;
            msb = msb + 2;
        };
        if (bits > 0x1) {
            msb = msb + 1;
        };

        (msb, true)
    }

    /**
 * @dev Returns the index of the least significant bit of x
 * @param x The value as a uint256
 * @return lsb The index of the least significant bit of x
 */
    public fun least_significant_bit(mut bits: u256): (u8, bool) {
        if (bits == 0) {
            return (0, false)
        };
        let mut lsb = 0;
        let mut temp = bits << 128;
        if (temp != 0) {
            lsb = 128;
            bits = temp;
        };
        temp = bits << 64;
        if (temp != 0) {
            lsb = lsb + 64;
            bits = temp;
        };
        temp = bits << 32;
        if (temp != 0) {
            lsb = lsb + 32;
            bits = temp;
        };
        temp = bits << 16;
        if (temp != 0) {
            lsb = lsb + 16;
            bits = temp;
        };
        temp = bits << 8;
        if (temp != 0) {
            lsb = lsb + 8;
            bits = temp;
        };
        temp = bits << 4;
        if (temp != 0) {
            lsb = lsb + 4;
            bits = temp;
        };
        temp = bits << 2;
        if (temp != 0) {
            lsb = lsb + 2;
            bits = temp;
        };
        temp = bits << 1;
        if (temp != 0) {
            lsb = lsb + 1;
        };
        (255 - lsb, true)
    }
}
