/// Stable bucketing with 64-bit FNV-1a. `hashValue` can't be used because Swift seeds it per process.
public enum Rollout {
    public static func bucket(for identifier: String) -> Int {
        var hash: UInt64 = 0xcbf2_9ce4_8422_2325
        for byte in identifier.utf8 {
            hash ^= UInt64(byte)
            hash &*= 0x0000_0100_0000_01b3
        }
        return Int(hash % 100)
    }
}
