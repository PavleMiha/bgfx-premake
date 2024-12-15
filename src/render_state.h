/*
 * Copyright 2024 Pavle Mihajlovic. All rights reserved.
 */

#include "types.h"
#include <atomic>
#include <bx/math.h>
#include <bx/thread.h>
#include <bgfx/bgfx.h>

#define NUM_RENDER_STATES 3
struct RenderState
{
	std::atomic<bool> isBusy;
	s64				  timeGenerated;

	f32				  dummy;
	bool			  showStats;

	bx::Vec3 at = { 0.0f, 1.0f,  0.0f };
	bx::Vec3 eye = { 0.0f, 1.0f, -2.5f };

};

extern RenderState g_renderState[NUM_RENDER_STATES];
