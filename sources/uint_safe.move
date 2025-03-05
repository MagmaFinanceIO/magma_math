module magma_math::uint_safe;

#[error]
const ErrSafe32: vector<u8> = b"not safe 32";
#[error]
const ErrSafe64: vector<u8> = b"not safe 64";
#[error]
const ErrSafe128: vector<u8> = b"not safe 128";

public fun safe32(x: u256): u32 {
    assert!(x >> 32 == 0, ErrSafe32);
    x as u32
}

public fun safe64(x: u256): u64 {
    assert!(x >> 64 == 0, ErrSafe64);
    x as u64
}

public fun safe128(x: u256): u128 {
    assert!(x >> 128 == 0, ErrSafe128);
    x as u128
}
