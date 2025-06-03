module magma_math::u256;

use magma_math::bit_math::most_significant_bit;

public fun sqrt(x: u256): u256 {
    if (x == 0) {
        return 0
    };

    let (msb, _) = most_significant_bit(x);
    let mut sqrt_x = 1 << (msb >> 1);
    sqrt_x = (sqrt_x + x / sqrt_x) >> 1;
    sqrt_x = (sqrt_x + x / sqrt_x) >> 1;
    sqrt_x = (sqrt_x + x / sqrt_x) >> 1;
    sqrt_x = (sqrt_x + x / sqrt_x) >> 1;
    sqrt_x = (sqrt_x + x / sqrt_x) >> 1;
    sqrt_x = (sqrt_x + x / sqrt_x) >> 1;
    sqrt_x = (sqrt_x + x / sqrt_x) >> 1;

    let x = x / sqrt_x;

    if (sqrt_x < x) {
        sqrt_x
    } else {
        x
    }
}

#[test]
fun test_sqrt_basis() {
    assert!(sqrt(10000) == 100);
    assert!(sqrt(144) == 12);
    assert!(sqrt(2626092456031396) == 51245414);
}
