#[test_only]
module magma_math::uint_safe_test {
    use magma_math::uint_safe;

    #[test]
    fun test_safe_32() {
        let x: u64 = (1 << 32) - 1; 
        assert!(((1u64 << 32) - 1) as u32 == uint_safe::safe32(x as u256));
    }

    #[test]
    #[expected_failure(abort_code = magma_math::uint_safe::ErrSafe32)]
    fun test_unsafe_32() {
        let x: u64 = (1 << 32);
        uint_safe::safe32(x as u256);
    }

    #[test]
    fun test_safe_64() {
        let x: u128 = (1 << 64) - 1; 
        assert!(((1u128 << 64) - 1) as u64 == uint_safe::safe64(x as u256));
    }

    #[test]
    #[expected_failure(abort_code = magma_math::uint_safe::ErrSafe64)]
    fun test_unsafe_64() {
        let x: u128 = (1 << 64);
        uint_safe::safe64(x as u256);
    }

    #[test]
    fun test_safe_128() {
        let x: u256 = (1 << 128) - 1; 
        assert!(((1u256 << 128) - 1) as u128 == uint_safe::safe128(x as u256));
    }

    #[test]
    #[expected_failure(abort_code = magma_math::uint_safe::ErrSafe128)]
    fun test_unsafe_128() {
        let x: u256 = (1 << 128);
        uint_safe::safe128(x as u256);
    }
}
