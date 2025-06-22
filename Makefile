IOS_CMAKE_DIR := ios-cmake
IOS_CMAKE_REPO := https://github.com/leetal/ios-cmake.git
TOOLCHAIN_PATH := $(IOS_CMAKE_DIR)/ios.toolchain.cmake

BUILD_DIR := build
BUILD_IOS_DIR := build/ios
BUILD_IOS_SIM_ARM64_DIR := build/ios_simulator_arm64
BUILD_IOS_SIM_X86_64_DIR := build/ios_simulator_x86_64
BUILD_MACOS_ARM64_DIR := build/macos_arm64
BUILD_MACOS_X86_64_DIR := build/macos_x86_64
INSTALL_DIR := install
ARCHIVE_DIR := archive
TMP_DIR := tmp
ZIP_FILE = $(TMP_DIR)/$(FRAMEWORK_NAME).xcframework.zip

FRAMEWORK_NAME := OpenEXRWrapper

PACKAGE_FILE = Package.swift

SCHEMES := OpenEXRWrapper OpenEXRWrapper_ios_simulator

.PHONY: prepare-ios-cmake build_ios build_ios_simulator_arm64 build_ios_simulator_x86_64 build_macos_arm64 build_macos_x86_64 clear all

prepare-ios-cmake:
	@if [ ! -d "$(IOS_CMAKE_DIR)" ]; then \
		echo "Cloning ios-cmake..."; \
		git clone $(IOS_CMAKE_REPO) $(IOS_CMAKE_DIR); \
	else \
		echo "$(IOS_CMAKE_DIR) already exists."; \
	fi

build_ios:
	@echo "Building project..."
	mkdir -p $(BUILD_IOS_DIR)
	cmake -B $(BUILD_IOS_DIR) -S . \
		-G Xcode \
		-DPLATFORM=OS64
	cmake --build $(BUILD_IOS_DIR) --config Release
	find install \( -type f -o -type l \) -name "*.dylib" -exec rm -f {} +
	@echo "Build complete."

build_ios_simulator_arm64:
	@echo "Building project for iOS Simulator..."
	mkdir -p $(BUILD_IOS_SIM_ARM64_DIR)
	cmake -B $(BUILD_IOS_SIM_ARM64_DIR) -S . \
		-G Xcode \
		-DPLATFORM=SIMULATORARM64
	cmake --build $(BUILD_IOS_SIM_ARM64_DIR) --config Release
	find install \( -type f -o -type l \) -name "*.dylib" -exec rm -f {} +
	@echo "Build for iOS Simulator complete."

build_ios_simulator_x86_64:
	@echo "Building project for iOS Simulator x86_64..."
	mkdir -p $(BUILD_IOS_SIM_X86_64_DIR)
	cmake -B $(BUILD_IOS_SIM_X86_64_DIR) -S . \
		-G Xcode \
		-DPLATFORM=SIMULATOR64
	cmake --build $(BUILD_IOS_SIM_X86_64_DIR) --config Release
	find install \( -type f -o -type l \) -name "*.dylib" -exec rm -f {} +
	@echo "Build for iOS Simulator x86_64 complete."

build_macos_arm64:
	@echo "Building project for macOS..."
	mkdir -p $(BUILD_MACOS_ARM64_DIR)
	cmake -B $(BUILD_MACOS_ARM64_DIR) -S . \
		-G Xcode \
		-DPLATFORM=MAC_ARM64
	cmake --build $(BUILD_MACOS_ARM64_DIR) --config Release
	find install \( -type f -o -type l \) -name "*.dylib" -exec rm -f {} +
	@echo "Build for macOS complete."

build_macos_x86_64:
	@echo "Building project for macOS x86_64..."
	mkdir -p $(BUILD_MACOS_X86_64_DIR)
	cmake -B $(BUILD_MACOS_X86_64_DIR) -S . \
		-G Xcode \
		-DPLATFORM=MAC
	cmake --build $(BUILD_MACOS_X86_64_DIR) --config Release
	find install \( -type f -o -type l \) -name "*.dylib" -exec rm -f {} +
	@echo "Build for macOS x86_64 complete."

archive_ios:
	echo "Archiving OpenEXRWrapper ..."
	xcodebuild archive \
		-project OpenEXRWrapper.xcodeproj \
		-scheme OpenEXRWrapper \
		-archivePath $(ARCHIVE_DIR)/OpenEXRWrapper.xcarchive \
		-destination 'generic/platform=iOS' \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES;

archive_ios_simulator_arm64:
	echo "Archiving OpenEXRWrapper_ios_simulator_arm64 ..."
	xcodebuild archive \
		-project OpenEXRWrapper.xcodeproj \
		-scheme OpenEXRWrapper_ios_simulator \
		-archivePath $(ARCHIVE_DIR)/OpenEXRWrapper_ios_simulator_arm64.xcarchive \
		-destination 'generic/platform=iOS Simulator' \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES;

archive_ios_simulator_x86_64:
	echo "Archiving OpenEXRWrapper_ios_simulator_x86_64 ..."
	xcodebuild archive \
		-project OpenEXRWrapper.xcodeproj \
		-scheme OpenEXRWrapper_ios_simulator_x86_64 \
		-archivePath $(ARCHIVE_DIR)/OpenEXRWrapper_ios_simulator_x86_64.xcarchive \
		-destination 'generic/platform=iOS Simulator' \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES;

archive_ios_simulator: archive_ios_simulator_arm64 archive_ios_simulator_x86_64
	echo "Archiving OpenEXRWrapper_macos_arm64 ..."
	mkdir -p tmp/ios-simulator
	lipo -create \
		archive/OpenEXRWrapper_ios_simulator_arm64.xcarchive/Products/Library/Frameworks/OpenEXRWrapper.framework/OpenEXRWrapper \
		archive/OpenEXRWrapper_ios_simulator_x86_64.xcarchive/Products/Library/Frameworks/OpenEXRWrapper.framework/OpenEXRWrapper \
		-output tmp/ios-simulator/OpenEXRWrapper_ios_simulator
	cp -R archive/OpenEXRWrapper_ios_simulator_arm64.xcarchive/Products/Library/Frameworks/OpenEXRWrapper.framework tmp/ios-simulator
	cp tmp/ios-simulator/OpenEXRWrapper_ios_simulator tmp/ios-simulator/OpenEXRWrapper.framework/OpenEXRWrapper

archive_macos_arm64:
	echo "Archiving OpenEXRWrapper_macos_arm64 ..."
	xcodebuild archive \
		-project OpenEXRWrapper.xcodeproj \
		-scheme OpenEXRWrapper_macos \
		-archivePath $(ARCHIVE_DIR)/OpenEXRWrapper_macos_arm64.xcarchive \
		-destination 'generic/platform=macOS' \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES;

archive_macos_x86_64:
	echo "Archiving OpenEXRWrapper_macos_x86_64 ..."
	xcodebuild archive \
		-project OpenEXRWrapper.xcodeproj \
		-scheme OpenEXRWrapper_macos_x86_64 \
		-archivePath $(ARCHIVE_DIR)/OpenEXRWrapper_macos_x86_64.xcarchive \
		-destination 'generic/platform=macOS' \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES;

archive_macos: archive_macos_arm64 archive_macos_x86_64
	echo "Archiving OpenEXRWrapper_macos ..."
	mkdir -p tmp/macos
	lipo -create \
		archive/OpenEXRWrapper_macos_arm64.xcarchive/Products/Library/Frameworks/OpenEXRWrapper.framework/OpenEXRWrapper \
		archive/OpenEXRWrapper_macos_x86_64.xcarchive/Products/Library/Frameworks/OpenEXRWrapper.framework/OpenEXRWrapper \
		-output tmp/macos/OpenEXRWrapper_macos
	cp -R archive/OpenEXRWrapper_macos_arm64.xcarchive/Products/Library/Frameworks/OpenEXRWrapper.framework tmp/macos
	cp tmp/macos/OpenEXRWrapper_macos tmp/macos/OpenEXRWrapper.framework/OpenEXRWrapper

create_xcframework: archive_ios archive_ios_simulator archive_macos
	@echo "Creating XCFramework..."
	rm -rf archive/OpenEXRWrapper.xcframework
	xcodebuild -create-xcframework \
		-framework archive/OpenEXRWrapper.xcarchive/Products/Library/Frameworks/OpenEXRWrapper.framework \
		-framework tmp/ios-simulator/OpenEXRWrapper.framework \
		-framework tmp/macos/OpenEXRWrapper.framework \
		-output archive/OpenEXRWrapper.xcframework

zip:
	@echo "Compressing $(FRAMEWORK_NAME).xcframework into $(ZIP_FILE)..."
	mkdir -p $(TMP_DIR)
	@rm -f $(ZIP_FILE)
	@cd $(ARCHIVE_DIR) && zip -r "../$(ZIP_FILE)" "$(FRAMEWORK_NAME).xcframework" > /dev/null

checksum:
	@echo "Computing checksum and updating $(PACKAGE_FILE)..."
	@CHECKSUM=$$(swift package compute-checksum $(ZIP_FILE)); \
	echo "Checksum: $$CHECKSUM"; \
	sed -i '' -E "s/(checksum: \\\")[a-f0-9]+(\\\")/\\1$$CHECKSUM\\2/" $(PACKAGE_FILE)

clear:
	@echo "Cleaning build directories..."
	rm -rf $(BUILD_DIR)
	rm -rf $(INSTALL_DIR)
	rm -rf $(ARCHIVE_DIR)
	rm -rf $(TMP_DIR)
	@echo "Clean complete."

build: prepare-ios-cmake build_ios build_ios_simulator_arm64 build_ios_simulator_x86_64 build_macos_arm64 build_macos_x86_64
