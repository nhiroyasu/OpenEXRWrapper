import Foundation
import simd

public func readEXR(url: URL) throws -> EXRData {
    var cchar: [CChar] = Array(url.path.utf8CString)
    guard let cEXR_FILE = cexr_open_file(&cchar) else {
        throw NSError(domain: "readEXR", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to open EXR file."])
    }
    defer {
        destroy_cexr_file(cEXR_FILE)
    }

    let versionNum = Int(cexr_get_version_number(cEXR_FILE))
    let isTiled = cexr_is_tiled(cEXR_FILE)
    let isMultiPart = cexr_is_multi_part(cEXR_FILE)
    let isNonImage = cexr_is_non_image(cEXR_FILE)
    let versionField = EXRData.VersionField(
        version: versionNum,
        isTiled: isTiled,
        isMultiPart: isMultiPart,
        isNonImage: isNonImage
    )

    guard let cHeader = cexr_get_header(cEXR_FILE) else {
        throw NSError(domain: "readEXR", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to read EXR header."])
    }
    defer {
        destroy_cexr_header(cHeader)
    }

    let width = Int32(cexr_header_get_width(cHeader))
    let height = Int32(cexr_header_get_height(cHeader))
    let pixelAspectRatio = cexr_header_get_pixel_aspect_ratio(cHeader)
    let screenWindowCenter = cexr_header_get_screen_window_center(cHeader)
    let screenWindowWidth = cexr_header_get_screen_window_width(cHeader)
    let lineOrder = Int32(cexr_header_get_line_order(cHeader))

     let channelCount = Int32(cexr_header_get_channel_count(cHeader))

    var channels: [EXRData.Header.Channel] = []
    for i in 0..<channelCount {
        guard let ch = cexr_header_get_channel(cHeader, i) else { continue }
        let name = String(cString: cexr_channel_get_name(ch))
        let typeRaw = cexr_channel_get_pixel_type(ch).rawValue
        let pixelType = EXRData.Header.Channel.PixelType(rawValue: typeRaw)
        let xSampling = Int32(cexr_channel_get_x_sampling(ch))
        let ySampling = Int32(cexr_channel_get_y_sampling(ch))
        let pLinear = cexr_channel_get_p_linear(ch) != 0

        let channel = EXRData.Header.Channel(
            name: name,
            pixelType: pixelType,
            pLinear: pLinear,
            xSampling: xSampling,
            ySampling: ySampling
        )
        channels.append(channel)
    }

    let header = EXRData.Header(
        width: width,
        height: height,
        screenWindowCenter: screenWindowCenter,
        screenWindowWidth: screenWindowWidth,
        pixelAspectRatio: pixelAspectRatio,
        lineOrder: lineOrder,
        channelCount: channelCount,
        channels: channels
    )

    guard let pixelPtr = cexr_get_pixels(cEXR_FILE) else {
        throw NSError(domain: "readEXR", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to read pixel data."])
    }
    defer {
        destroy_cexr_pixels(pixelPtr)
    }

    let pixelCount = Int(width * height)
    let pixels = Array(UnsafeBufferPointer(start: pixelPtr, count: pixelCount))

    return EXRData(
        versionField: versionField,
        header: header,
        pixels: pixels
    )
}
