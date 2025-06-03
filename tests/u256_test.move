module magma_math::u256_test{
    use magma_math::u256::sqrt;

    #[test]
    fun test_sqrt_basis() {
        assert!(sqrt(10000) == 100);
        assert!(sqrt(144) == 12);
        assert!(sqrt(2626092456031396) == 51245414);
        assert!(sqrt(15129) == 123);
        assert!(sqrt(1871341081) == 43259);
        assert!(sqrt(975460423716) == 987654);
        assert!(sqrt(235959788242427929) == 485756923);
        assert!(sqrt(0) == 0);
        assert!(sqrt(1) == 1);
        assert!(sqrt(4) == 2);
        assert!(sqrt(9) == 3);
        assert!(sqrt(16) == 4);
        assert!(sqrt(25) == 5);
        assert!(sqrt(36) == 6);
        assert!(sqrt(49) == 7);
        assert!(sqrt(64) == 8);
        assert!(sqrt(81) == 9);
        assert!(sqrt(100) == 10);
        assert!(sqrt(121) == 11);
    }
}
