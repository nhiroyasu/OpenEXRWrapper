import Testing
import simd
@testable import OpenEXRWrapper

class DummyTestClass {}

struct OpenEXRWrapperTests {
    @Test func testEXRData_Metadata() throws {
        guard let url = Bundle(for: DummyTestClass.self).url(forResource: "texture_sample", withExtension: "exr") else {
            fatalError("Failed to load texture_sample.exr")
        }

        let data = try readEXR(url: url)

        // versionField
        #expect(data.versionField.version == 2)
        #expect(data.versionField.isTiled == false)
        #expect(data.versionField.isMultiPart == false)
        #expect(data.versionField.isNonImage == false)

        // header
        #expect(data.header.width == 1200)
        #expect(data.header.height == 600)
        #expect(data.header.screenWindowCenter == simd_float2(599.5, 299.5))
        #expect(data.header.screenWindowWidth == 1200.0)
        #expect(data.header.pixelAspectRatio == 1.0)
        #expect(data.header.lineOrder == 0)
        #expect(data.header.channelCount == 4)
        #expect(data.header.channels[0].name == "A")
        #expect(data.header.channels[0].xSampling == 1)
        #expect(data.header.channels[0].ySampling == 1)
        #expect(data.header.channels[0].pLinear == false)
        #expect(data.header.channels[0].pixelType == .half)
        #expect(data.header.channels[1].name == "B")
        #expect(data.header.channels[1].xSampling == 1)
        #expect(data.header.channels[1].ySampling == 1)
        #expect(data.header.channels[1].pLinear == false)
        #expect(data.header.channels[1].pixelType == .half)
        #expect(data.header.channels[2].name == "G")
        #expect(data.header.channels[2].xSampling == 1)
        #expect(data.header.channels[2].ySampling == 1)
        #expect(data.header.channels[2].pLinear == false)
        #expect(data.header.channels[2].pixelType == .half)
        #expect(data.header.channels[3].name == "R")
        #expect(data.header.channels[3].xSampling == 1)
        #expect(data.header.channels[3].ySampling == 1)
        #expect(data.header.channels[3].pLinear == false)
        #expect(data.header.channels[3].pixelType == .half)
    }

    @Test func testEXRData_RawData() throws {
        guard let url = Bundle(for: DummyTestClass.self).url(forResource: "pixel_data", withExtension: "exr") else {
            fatalError("Failed to load texture_sample.exr")
        }

        let data = try readEXR(url: url)

        var pixels: [simd_float4] = []

        for y in 0..<10 {
            for x in 0..<10 {
                let g = Float16(x) / 9.0
                let b = Float16(y) / 9.0
                let g_f32 = Float(g)
                let b_f32 = Float(b)
                let rgba = simd_float4(0, g_f32, b_f32, 1.0)
                pixels.append(rgba)
            }
        }

        print("Pixels match expected values.")
        #expect(data.pixels == pixels)
    }
}
