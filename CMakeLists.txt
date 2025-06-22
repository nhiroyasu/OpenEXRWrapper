cmake_minimum_required(VERSION 3.19)
cmake_policy(SET CMP0114 NEW)
project(OpenEXRWrapper)

include(ExternalProject)

message("Processor: ${CMAKE_SYSTEM_PROCESSOR}")

if(NOT DEFINED PLATFORM)
    message(FATAL_ERROR "PLATFORM not specified. Please run cmake with -DPLATFORM=OS64 or -DPLATFORM=OS32")
endif()

set(INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/${PLATFORM})
set(TOOLCHAIN_PATH ${CMAKE_CURRENT_SOURCE_DIR}/ios-cmake/ios.toolchain.cmake)

# 1. libdeflate
ExternalProject_Add(libdeflate
    GIT_REPOSITORY https://github.com/ebiggers/libdeflate.git
    GIT_TAG        v1.23
    UPDATE_DISCONNECTED TRUE
    CMAKE_ARGS
        -G Xcode
        -DCMAKE_BUILD_TYPE=Release
        -DPLATFORM=${PLATFORM}
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_PATH}
        -DLIBDEFLATE_BUILD_GZIP=OFF
)

# 2. Imath
ExternalProject_Add(Imath
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/Imath.git
    GIT_TAG        v3.1.12
    UPDATE_DISCONNECTED TRUE
    CMAKE_ARGS
        -G Xcode
        -DCMAKE_BUILD_TYPE=Release
        -DPLATFORM=${PLATFORM}
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_PATH}
)

# 3. OpenEXR
ExternalProject_Add(
    OpenEXR
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/openexr.git 
    GIT_TAG        v3.3.3
    UPDATE_DISCONNECTED TRUE

    CMAKE_ARGS
        -G Xcode
        -DCMAKE_BUILD_TYPE=Release
        -DPLATFORM=${PLATFORM}
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
        -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/lib
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_PATH}
        -DOPENEXR_BUILD_TOOLS=OFF
        -DOPENEXR_INSTALL_TOOLS=OFF
        -DOPENEXR_BUILD_EXAMPLES=OFF
        -DOPENEXR_IS_SUBPROJECT=ON
        -DOPENEXR_MISSING_ARM_VLD1=OFF

    DEPENDS Imath libdeflate
)