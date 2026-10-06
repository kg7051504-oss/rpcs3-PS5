#!/usr/bin/env bash
# Build the PS5_Vulkan RADV driver chain for the rpcs3-PS5 port.
set -euo pipefail
cd "$(dirname "$0")/../deps/PS5_Vulkan"
export PS5VK_MAKO_PATH="$(cd .. && pwd)/pylib"
export PYTHONPATH="$PS5VK_MAKO_PATH${PYTHONPATH:+:$PYTHONPATH}"
export PS5_OPENGL_SDK="$(cd .. && pwd)/ps5-opengl-src/ps5-opengl"
step() { echo "==> $*"; }
if [[ ! -f .deps/native/psbc/PROVENANCE.txt ]]; then step psbc; bash tools/build-psbc-ps5.sh; fi
unset PS5_OPENGL_SDK
if [[ ! -f .deps/native/opengl-sdk/README.md && ! -d .deps/native/opengl-sdk/toolchain ]]; then step adapt; bash tools/adapt-opengl-sdk.sh ../ps5-opengl-sdk-0.3.0; fi
step mesa;    bash tools/fetch-mesa.sh
step runtime; bash tools/build-vulkan-runtime.sh
step radv;    bash tools/build-radv.sh release
step done
