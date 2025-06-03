module magma_math::u128x128_test {
    use magma_math::u128x128::{log2, to_u128x128, from_u128x128, from_u128x128_dec};
    use magma_math::math_tests::eq_within_precision;

    #[test]
    #[expected_failure(abort_code = magma_math::u128x128::ErrLogUnderflow)]
    fun test_log_0() {
        log2(0);
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
    fun test_log_2_adv() {
        let (res, is_positive) = log2(to_u128x128(2566667, 7));
        let (int, fraction) = from_u128x128_dec(res, 5);
        std::debug::print(&int);
        std::debug::print(&fraction);
        std::debug::print(&res);
        std::debug::print(&(to_u128x128(196203, 5)));
        assert!(!is_positive && res == to_u128x128(196203, 5));

        let decimals = 16;
        let (res, is_positive) = log2(to_u128x128(8408964152537145, decimals));
        let (int, fraction) = from_u128x128(res);
        std::debug::print(&int);
        std::debug::print(&fraction);
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
}
