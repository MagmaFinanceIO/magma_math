#[test_only]
module magma_math::math_tests {
    use std::u256;

    use integer_mate::i32;
    use magma_math::u128x128::{log2, pow, to_u128x128, from_u128x128};

    const FIX_POINT_BITS: u8 = 128;

    #[test]
    fun test_pow_2() {
        let x = vector[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 101, 103, 115, 333, 10001, 555555, 897654];
        let mut i = 0;
        while (i < x.length()) {
            let r = x[i] * x[i];
            assert!(r == (pow(x[i] << FIX_POINT_BITS, i32::from(2))) >> FIX_POINT_BITS);
            i = i + 1;
        }
    }

    #[test]
    fun test_to_u128x128() {
        assert!(to_u128x128(0, 0) == 0);
        assert!(to_u128x128(1, 0) == 0x0000000000000000000000000000000100000000000000000000000000000000);
        assert!(to_u128x128(2, 0) == 0x0000000000000000000000000000000200000000000000000000000000000000);
    }

    #[test_only]
    fun eq_within_precision(a: u256, b: u256, p: u8) {
        if (p == 0) {
            assert!(a == b);
            return
        };

        let mut denom: u256 = 1;
        let mut x = a;
        while (x > 10) {
            x = x / 10;
            denom = denom * 10;
        };
        assert!(u256::pow(10, p) < denom);
        let mut i = 0;
        let mut a_ = a;
        let mut b_ = b;
        while (i < p) {
            let a_digit = a_ / denom;
            let b_digit = b_ / denom;
            assert!(a_digit == b_digit);

            a_ = a_ - a_digit * denom;
            b_ = b_ - b_digit * denom;
            denom = denom / 10;

            i = i +  1;
        };
    }

    #[test]
    fun test_log_2_adv() {
        let decimals = 16;
        let (res, is_positive) = log2(to_u128x128(8408964152537145, decimals));
        assert!(!is_positive);
        eq_within_precision(res, to_u128x128(25, 2), decimals - 1);

        let decimals = 15;
        let (res, is_positive) = log2(to_u128x128(934087755852287, decimals));
        assert!(!is_positive);
        eq_within_precision(res, to_u128x128(9837, 5), decimals - 1);

        let decimals = 14;
        let (res, is_positive) = log2(to_u128x128(71946679000541, decimals));
        assert!(!is_positive);
        eq_within_precision(res, to_u128x128(475, 3), decimals - 1);

        let decimals = 14;
        let (res, is_positive) = log2(to_u128x128(71946679000541, decimals));
        assert!(!is_positive);
        eq_within_precision(res, to_u128x128(475, 3), decimals - 1);

        let (res, is_positive) = log2(to_u128x128(31554436208840472, 46));
        assert!(!is_positive);
        eq_within_precision(res, to_u128x128(98, 0), 10);

    }

    #[test]
    fun test_log_2_basis() {
        let (res, is_positive) = log2(to_u128x128(1, 0));
        assert!(res == 0 && is_positive);

        let (res, is_positive) = log2(to_u128x128(2, 0));
        assert!(is_positive && res == to_u128x128(1, 0));

        let (res, is_positive) = log2(to_u128x128(4, 0));
        assert!(is_positive && res == to_u128x128(2, 0));

        let (res, is_positive) = log2(to_u128x128(8, 0));
        assert!(is_positive && res == to_u128x128(3, 0));

        let (res, is_positive) = log2(to_u128x128(16, 0));
        assert!(is_positive && res == to_u128x128(4, 0));

        let (res, is_positive) = log2(to_u128x128(5, 1)); // 0.5
        assert!(!is_positive && res == to_u128x128(1, 0));

        let (res, is_positive) = log2(to_u128x128(25, 2)); // 0.25
        assert!(!is_positive && res == to_u128x128(2, 0));

        let (res, is_positive) = log2(to_u128x128(9765625, 10));
        assert!(!is_positive && res == to_u128x128(10, 0));

        let (res, is_positive) = log2(to_u128x128(170141183460469231731687303715884105728, 0));
        assert!(is_positive && res == to_u128x128(127, 0));
    }

    #[test]
    fun test_pow_1001() {
        let powers = vector[
            i32::from(0),
            i32::from(1),
            i32::from(2),
            i32::from(3),
            i32::from(4),
            i32::from(5),
            i32::from(6),
            i32::from(7),
            i32::from(8),
            i32::from(9),
            i32::from(10),
            i32::from(11),
            i32::from(12),
            i32::from(13),
            i32::from(14),
            i32::from(15),
            i32::from(101),
            i32::from(103),
            i32::from(115),
            i32::from(333),
            i32::from(789),
            i32::from(10001),
            i32::from(155555),
            i32::from(300001),
            i32::from(500001),
            // i128::from(10).neg(),
        ];
        let answers = vector[
            to_u128x128(1, 0),
            to_u128x128(10001, 4),
            to_u128x128(100020001, 8),
            to_u128x128(10003000300009999, 16),
            to_u128x128(1000400060004, 12),
            to_u128x128(10005001000100004, 16),
            to_u128x128(10006001500200015, 16),
            to_u128x128(10007002100350033, 16),
            to_u128x128(1000800280056007, 15),
            to_u128x128(10009003600840125, 16),
            to_u128x128(1001000450120021, 15),
            to_u128x128(1001100550165033, 15),
            to_u128x128(10012006602200494, 16),
            to_u128x128(10013007802860714, 16),
            to_u128x128(10014009103641, 13),
            to_u128x128(10015010504551363, 16),
            to_u128x128(10101506670590847, 16),
            to_u128x128(10103527072940033, 16),
            to_u128x128(10115657975978702, 16),
            to_u128x128(10338589296556986, 16),
            to_u128x128(10820918384727864, 16),
            to_u128x128(2718417741417608, 15),
            to_u128x128(5692854084090833, 9),
            to_u128x128(10671524998652945, 3),
            to_u128x128(5172277991425458569216, 0),
        ];
        let precisions = vector[
            0,
            3,
            7,
            13,
            10,
            14,
            14,
            14,
            13,
            14,
            13,
            13,
            14,
            14,
            11,
            13,
            14,
            14,
            14,
            13,
            13,
            12,
            8,
            10,
            10,
        ];
        let base: u256 = (1 << FIX_POINT_BITS) + (1 << FIX_POINT_BITS) / 10000; // 1.0001
        let mut i = 0;
        while (i < powers.length()) {
            let c = pow(base, powers[i]);
            eq_within_precision(c, answers[i], precisions[i]);
            i = i + 1;
        }
    }
}
