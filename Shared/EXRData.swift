import simd

public struct EXRData {
    public struct VersionField {
        public let version: Int
        public let isTiled: Bool
        public let isMultiPart: Bool
        public let isNonImage: Bool
    }

    public struct Header {
        public struct Channel {
            public enum PixelType: UInt32 {
                case half = 1
                case float = 2
                case uint = 3
            }
            public let name: String
            public let pixelType: PixelType?
            public let pLinear: Bool
            public let xSampling: Int32
            public let ySampling: Int32
        }

        public let width: Int32
        public let height: Int32
        public let screenWindowCenter: simd_float2
        public let screenWindowWidth: Float
        public let pixelAspectRatio: Float
        public let lineOrder: Int32
        public let channelCount: Int32
        public let channels: Array<Channel>
    }

    public let versionField: VersionField
    public let header: Header
    public let pixels: Array<simd_float4>

    init(
        versionField: VersionField,
        header: Header,
        pixels: Array<simd_float4>
    ) {
        self.versionField = versionField
        self.header = header
        self.pixels = pixels
    }
}
