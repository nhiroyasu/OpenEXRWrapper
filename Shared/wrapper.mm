#import <Foundation/Foundation.h>
#import <os/log.h>
#import <simd/simd.h>
#import "ImfRgbaFile.h"
#import "ImfArray.h"
#import "ImfChannelList.h"
#import "ImfVersion.h"
#import "ImfHeader.h"
#import "wrapper.h"
#import "openexr.h"

using namespace std;
using namespace Imf;
using namespace Imath;

struct CEXR_FILE {
    RgbaInputFile *file;
};

struct CEXR_Channel {
    std::string name;
    CEXR_PixelType pixelType;
    int xSampling;
    int ySampling;
    int pLinear;
};

struct CEXR_Header {
    int width;
    int height;
    float pixelAspectRatio;
    simd_float2 screenWindowCenter;
    float screenWindowWidth;
    int lineOrder;
    std::vector<CEXR_Channel> channels;
};

// MARK: - CEXR_ChannelList
struct CEXR_ChannelList {
    std::vector<CEXR_Channel>* channels;
};

CEXR_FILE* cexr_open_file(const char *path) {
    try {
        CEXR_FILE *exrFile = (CEXR_FILE *)malloc(sizeof(CEXR_FILE));
        if (!exrFile) {
            os_log_error(OS_LOG_DEFAULT, "Memory allocation failed for CEXR_FILE.");
            return nullptr;
        }
        exrFile->file = new RgbaInputFile(path);
        return exrFile;
    } catch (const std::exception &e) {
        os_log_error(OS_LOG_DEFAULT, "Error opening EXR file: %s", e.what());
        return nullptr;
    }
}

void destroy_cexr_file(CEXR_FILE* file) {
    if (file) {
        if (file->file) {
            delete file->file;
        }
        free(file);
    }
}

// MARK: - CEXR_FILE Accessors

const simd_float4* cexr_get_pixels(CEXR_FILE* file) {
    if (!file || !file->file) return nullptr;

    Box2i dw = file->file->dataWindow();
    int width = dw.max.x - dw.min.x + 1;
    int height = dw.max.y - dw.min.y + 1;

    Array2D<Rgba> pixels(height, width);
    file->file->setFrameBuffer(&pixels[0][0], 1, width);
    file->file->readPixels(dw.min.y, dw.max.y);

    simd_float4 *outputPixels = (simd_float4 *)malloc(sizeof(simd_float4) * width * height);
    if (!outputPixels) {
        os_log_error(OS_LOG_DEFAULT, "Memory allocation failed for pixel data.");
        return nullptr;
    }

    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            Rgba &pixel = pixels[y][x];
            outputPixels[y * width + x] = {
                static_cast<Float32>(pixel.r),
                static_cast<Float32>(pixel.g),
                static_cast<Float32>(pixel.b),
                static_cast<Float32>(pixel.a)
            };
        }
    }

    return outputPixels;
}

void destroy_cexr_pixels(const simd_float4* pixels) {
    if (pixels) {
        free((void *)pixels);
    }
}

CEXR_Header* cexr_get_header(CEXR_FILE* file) {
    if (!file || !file->file) return nullptr;

    Header rawHeader = file->file->header();

    Box2i dw = file->file->dataWindow();
    int width = dw.max.x - dw.min.x + 1;
    int height = dw.max.y - dw.min.y + 1;

    CEXR_Header* header = new CEXR_Header();
    header->width = width;
    header->height = height;
    header->pixelAspectRatio = rawHeader.pixelAspectRatio();
    header->lineOrder = rawHeader.lineOrder();
    V2f center = rawHeader.screenWindowCenter();
    header->screenWindowCenter = simd_float2{center.x, center.y};
    header->screenWindowWidth = rawHeader.screenWindowWidth();

    for (ChannelList::ConstIterator it = rawHeader.channels().begin(); it != rawHeader.channels().end(); ++it) {
        const Channel &ch = it.channel();
        CEXR_Channel channel;
        channel.name = it.name();
        channel.pixelType = static_cast<CEXR_PixelType>(ch.type);
        channel.xSampling = ch.xSampling;
        channel.ySampling = ch.ySampling;
        channel.pLinear = ch.pLinear ? 1 : 0;
        header->channels.push_back(channel);
    }
    return header;
}

void destroy_cexr_header(CEXR_Header* header) {
    delete header;
}

// MARK: - CEXR_FILE Version Accessor

int cexr_get_version_field(const CEXR_FILE* file) {
    return file ? file->file->version() : 0;
}

int cexr_get_version_number(const CEXR_FILE* file) {
    return file ? getVersion(file->file->version()) : 0;
}

bool cexr_is_tiled(const CEXR_FILE* file) {
    return file ? isTiled(file->file->version()) : false;
}

bool cexr_is_multi_part(const CEXR_FILE* file) {
    return file ? isMultiPart(file->file->version()) : false;
}

bool cexr_is_non_image(const CEXR_FILE* file) {
    return file ? isNonImage(file->file->version()) : false;
}

// MARK: - CEXR_Header Accessors

int cexr_header_get_width(const CEXR_Header* header) {
    return header ? header->width : 0;
}

int cexr_header_get_height(const CEXR_Header* header) {
    return header ? header->height : 0;
}

float cexr_header_get_pixel_aspect_ratio(const CEXR_Header* header) {
    return header ? header->pixelAspectRatio : 1.0f;
}

simd_float2 cexr_header_get_screen_window_center(const CEXR_Header* header) {
    return header ? header->screenWindowCenter : simd_make_float2(0, 0);
}

float cexr_header_get_screen_window_width(const CEXR_Header* header) {
    return header ? header->screenWindowWidth : 0.0f;
}

int cexr_header_get_line_order(const CEXR_Header* header) {
    return header ? header->lineOrder : 0;
}

int cexr_header_get_channel_count(const CEXR_Header* header) {
    return header ? static_cast<int>(header->channels.size()) : 0;
}

const CEXR_Channel* cexr_header_get_channel(const CEXR_Header* header, int index) {
    if (!header || index < 0 || index >= static_cast<int>(header->channels.size())) return nullptr;
    return &header->channels[index];
}

// MARK: - CEXR_Channel Accessors

const char* cexr_channel_get_name(const CEXR_Channel* channel) {
    return channel ? channel->name.c_str() : nullptr;
}

CEXR_PixelType cexr_channel_get_pixel_type(const CEXR_Channel* channel) {
    return channel ? channel->pixelType : CEXR_HALF;
}

int cexr_channel_get_x_sampling(const CEXR_Channel* channel) {
    return channel ? channel->xSampling : 0;
}

int cexr_channel_get_y_sampling(const CEXR_Channel* channel) {
    return channel ? channel->ySampling : 0;
}

int cexr_channel_get_p_linear(const CEXR_Channel* channel) {
    return channel ? channel->pLinear : 0;
}

// MARK: - CEXR_ChannelList Accessors

int cexr_channel_list_get_count(const CEXR_ChannelList* list) {
    return list && list->channels ? static_cast<int>(list->channels->size()) : 0;
}

const CEXR_Channel* cexr_channel_list_get_channel(const CEXR_ChannelList* list, int index) {
    if (!list || !list->channels || index < 0 || index >= static_cast<int>(list->channels->size())) return nullptr;
    return &(*list->channels)[index];
}
