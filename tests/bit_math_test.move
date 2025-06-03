#[test_only]
module magma_math::bit_math_test {
    use magma_math::bit_math::most_significant_bit;

    #[test]
    fun test_most_significant() {
        let v = vector[1, 2, 4, (1 << 255) + ((1 << 255) - 1)];
        let t = vector[0, 1, 2, 255];
        let (_, ok) = most_significant_bit(0);
        assert!(!ok);
        let mut i = 0;
        while (i < v.length()) {
            let (x, ok) = most_significant_bit(v[i]);
            assert!(ok && x == t[i]);
            i = i + 1;
        };
    }
}
