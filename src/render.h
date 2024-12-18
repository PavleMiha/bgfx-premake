/*
 * Copyright 2024 Pavle Mihajlovic. All rights reserved.
 */

#include "types.h"
#include <bx/thread.h>
#include <bgfx/bgfx.h>

struct RenderThreadArgs
{
	bgfx::PlatformData platformData;
	uint32_t width;
	uint32_t height;
};

s32 runRenderThread(bx::Thread* self, void* userData);