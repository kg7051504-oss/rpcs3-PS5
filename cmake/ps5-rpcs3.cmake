# Toolchain for building RPCS3 as a native PS5 title (x86_64-sie-ps5, Zen 2).
# Wraps the PS5_PayloadSDK fork's prospero.cmake (installed at deps/sdk-rpcs3).
get_filename_component(RPCS3_PS5_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)
include("${RPCS3_PS5_ROOT}/deps/sdk-rpcs3/toolchain/prospero.cmake")

# The PS5 CPU is Zen 2 (AVX2, FMA, BMI2): build for it, not -march=native.
set(CMAKE_C_FLAGS_INIT "-march=znver2")
set(CMAKE_CXX_FLAGS_INIT "-march=znver2")

# The SDK's libc holds the math functions; configure checks that link -lm get an empty archive.
set(CMAKE_EXE_LINKER_FLAGS_INIT "-L${RPCS3_PS5_ROOT}/deps/ps5-extra-libs")

# pkg-config must find nothing: the host's would add /usr/include.
set(ENV{PKG_CONFIG_LIBDIR} "/nonexistent-pkg-config-for-ps5")
set(ENV{PKG_CONFIG_PATH} "")

set(PS5 TRUE CACHE BOOL "Build for the PS5" FORCE)

# CMake's C++20 module scan runs the host clang-scan-deps on the command line,
# which bypasses the prospero-clang wrapper and so never sees the SDK's libc++
# headers. RPCS3 uses no C++ modules: turn the scan off.
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)
