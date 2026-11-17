/// The keyboard key sent by a physical trackpad click, or the normal mouse click.
public enum ClickKey: String, Codable, Sendable, Equatable, CaseIterable {
    case normal
    case f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12
    case digit0, digit1, digit2, digit3, digit4, digit5, digit6, digit7, digit8, digit9
    case a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z

    public var title: String {
        if self == .normal { return "Normal mouse click" }
        if rawValue.hasPrefix("digit") { return String(rawValue.suffix(1)) }
        return rawValue.uppercased()
    }
    /// macOS virtual key codes. The high bit marks F keys, which need Fn for the system's media-key mapping.
    public var encoded: UInt16 {
        switch self {
        case .normal: return 0xffff
        case .f1: return 0x8000 | 122
        case .f2: return 0x8000 | 120
        case .f3: return 0x8000 | 99
        case .f4: return 0x8000 | 118
        case .f5: return 0x8000 | 96
        case .f6: return 0x8000 | 97
        case .f7: return 0x8000 | 98
        case .f8: return 0x8000 | 100
        case .f9: return 0x8000 | 101
        case .f10: return 0x8000 | 109
        case .f11: return 0x8000 | 103
        case .f12: return 0x8000 | 111
        case .digit0: return 29
        case .digit1: return 18
        case .digit2: return 19
        case .digit3: return 20
        case .digit4: return 21
        case .digit5: return 23
        case .digit6: return 22
        case .digit7: return 26
        case .digit8: return 28
        case .digit9: return 25
        case .a: return 0
        case .b: return 11
        case .c: return 8
        case .d: return 2
        case .e: return 14
        case .f: return 3
        case .g: return 5
        case .h: return 4
        case .i: return 34
        case .j: return 38
        case .k: return 40
        case .l: return 37
        case .m: return 46
        case .n: return 45
        case .o: return 31
        case .p: return 35
        case .q: return 12
        case .r: return 15
        case .s: return 1
        case .t: return 17
        case .u: return 32
        case .v: return 9
        case .w: return 13
        case .x: return 7
        case .y: return 16
        case .z: return 6
        }
    }
}

public struct ClickBindings: Codable, Sendable, Equatable {
    public var one: ClickKey = .normal
    public var two: ClickKey = .f10
    public var three: ClickKey = .f12
    public var four: ClickKey = .normal
    public init() {}
    public var packed: UInt64 {
        UInt64(one.encoded) | UInt64(two.encoded) << 16 | UInt64(three.encoded) << 32 | UInt64(four.encoded) << 48
    }
    public static func encoded(in packed: UInt64, fingers: Int32) -> UInt16? {
        guard (1...4).contains(fingers) else { return nil }
        let value = UInt16(truncatingIfNeeded: packed >> (UInt64(fingers - 1) * 16))
        return value == 0xffff ? nil : value
    }
}
