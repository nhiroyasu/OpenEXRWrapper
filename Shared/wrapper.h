#ifndef wrapper_h
#define wrapper_h

#include <simd/simd.h>

#ifdef __cplusplus
extern "C" {
#endif

#define EXR_WRAPPER_SUCCESS 0
#define EXR_WRAPPER_FAILURE -1

// MARK: - CEXR_Channel

typedef enum {
    CEXR_HALF = 1,
    CEXR_FLOAT = 2,
    CEXR_UINT = 3
} CEXR_PixelType;


// MARK: - CEXR API Forward Declarations

typedef struct CEXR_FILE CEXR_FILE;
typedef struct CEXR_Header CEXR_Header;
typedef struct CEXR_Channel CEXR_Channel;

// MARK: - CEXR API

CEXR_FILE* cexr_open_file(const char* filename);
void destroy_cexr_file(CEXR_FILE* file);

// CEXR_FILE accessors
const simd_float4* cexr_get_pixels(CEXR_FILE* file);
void destroy_cexr_pixels(const simd_float4* pixels);
CEXR_Header* cexr_get_header(CEXR_FILE* file);
void destroy_cexr_header(CEXR_Header* header);

int cexr_get_version_field(const CEXR_FILE* file);

// Bit flag accessors for EXR version field
int cexr_get_version_number(const CEXR_FILE* file);
bool cexr_is_tiled(const CEXR_FILE* file);
bool cexr_is_multi_part(const CEXR_FILE* file);
bool cexr_is_non_image(const CEXR_FILE* file);

// CEXR_Header accessors
int cexr_header_get_width(const CEXR_Header* header);
int cexr_header_get_height(const CEXR_Header* header);
float cexr_header_get_pixel_aspect_ratio(const CEXR_Header* header);
simd_float2 cexr_header_get_screen_window_center(const CEXR_Header* header);
float cexr_header_get_screen_window_width(const CEXR_Header* header);
int cexr_header_get_line_order(const CEXR_Header* header);
int cexr_header_get_channel_count(const CEXR_Header* header);
const CEXR_Channel* cexr_header_get_channel(const CEXR_Header* header, int index);

// CEXR_ChannelList accessors
typedef struct CEXR_ChannelList CEXR_ChannelList;

const CEXR_ChannelList* cexr_header_get_channel_list(const CEXR_Header* header);
int cexr_channel_list_get_count(const CEXR_ChannelList* list);
const CEXR_Channel* cexr_channel_list_get_channel(const CEXR_ChannelList* list, int index);

// CEXR_Channel accessors
const char* cexr_channel_get_name(const CEXR_Channel* channel);
CEXR_PixelType cexr_channel_get_pixel_type(const CEXR_Channel* channel);
int cexr_channel_get_x_sampling(const CEXR_Channel* channel);
int cexr_channel_get_y_sampling(const CEXR_Channel* channel);
int cexr_channel_get_p_linear(const CEXR_Channel* channel);

#ifdef __cplusplus
}
#endif

#endif /* wrapper_h */
