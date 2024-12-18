/*
 * Copyright 2024 Pavle Mihajlovic. All rights reserved.
 */

#include "render.h"

#include "input.h"
#include "GLFW/glfw3.h"
#include "render_state.h"
#include "logo.h"
#include "bx/os.h"
#include "resources.h"

extern bx::SpScUnboundedQueue s_systemEvents;

s32 runRenderThread(bx::Thread *self, void *userData)
{
	auto args = (RenderThreadArgs *)userData;
	// Initialize bgfx using the native window handle and window resolution.
	bgfx::Init init;
	init.platformData = args->platformData;
	init.resolution.width = args->width;
	init.resolution.height = args->height;
	init.resolution.reset = BGFX_RESET_VSYNC;
	if (!bgfx::init(init))
		return 1;

	loadResources();

	// Set view 0 to the same dimensions as the window and to clear the color buffer.
	const bgfx::ViewId kClearView = 0;
	bgfx::setViewClear(kClearView, BGFX_CLEAR_COLOR);
	bgfx::setViewRect(kClearView, 0, 0, bgfx::BackbufferRatio::Equal);
	uint32_t width = args->width;
	uint32_t height = args->height;
	bool exit = false;
	while (!exit) {
		// Handle events from the main thread.
		while (auto ev = (EventType *)s_systemEvents.pop()) {
			
			if (*ev == EventType::Resize) {
				auto resizeEvent = (ResizeEvent *)ev;
				bgfx::reset(resizeEvent->width, resizeEvent->height, BGFX_RESET_VSYNC);
				bgfx::setViewRect(kClearView, 0, 0, bgfx::BackbufferRatio::Equal);
				width = resizeEvent->width;
				height = resizeEvent->height;
			}
			delete ev;
		}

		bool found			 = false;
		s32 renderStateIndex = 0;

		while (!found) {
			s64 newestTime = -1;

			for (s32 i = 0; i < NUM_RENDER_STATES; i++) {
				if (!g_renderState[i].isBusy.load()) {
					if (g_renderState[i].timeGenerated > newestTime) {
						renderStateIndex = i;
						newestTime = g_renderState[i].timeGenerated;
					}
				}
			}
			
			bool expected = false;
			if (g_renderState[renderStateIndex].isBusy.compare_exchange_weak(expected, true)) {
				found = true;
			}
		}

		const RenderState& renderState = g_renderState[renderStateIndex];

		// This dummy draw call is here to make sure that view 0 is cleared if no other draw calls are submitted to view 0.
		bgfx::touch(kClearView);
		// Use debug font to print information about this example.
		bgfx::dbgTextClear();
		bgfx::dbgTextImage(bx::max<uint16_t>(uint16_t(width / 2 / 8), 20) - 20, bx::max<uint16_t>(uint16_t(height / 2 / 16), 6) - 6, 40, 12, s_logo, 160);
		bgfx::dbgTextPrintf(0, 0, 0x0f, "Press F1 to toggle stats.");
		bgfx::dbgTextPrintf(0, 1, 0x0f, "Color can be changed with ANSI \x1b[9;me\x1b[10;ms\x1b[11;mc\x1b[12;ma\x1b[13;mp\x1b[14;me\x1b[0m code too.");
		bgfx::dbgTextPrintf(80, 1, 0x0f, "\x1b[;0m    \x1b[;1m    \x1b[; 2m    \x1b[; 3m    \x1b[; 4m    \x1b[; 5m    \x1b[; 6m    \x1b[; 7m    \x1b[0m");
		bgfx::dbgTextPrintf(80, 2, 0x0f, "\x1b[;8m    \x1b[;9m    \x1b[;10m    \x1b[;11m    \x1b[;12m    \x1b[;13m    \x1b[;14m    \x1b[;15m    \x1b[0m");
		const bgfx::Stats* stats = bgfx::getStats();
		bgfx::dbgTextPrintf(0, 2, 0x0f, "Backbuffer %dW x %dH in pixels, debug text %dW x %dH in characters.", stats->width, stats->height, stats->textWidth, stats->textHeight);
		bgfx::dbgTextPrintf(0, 3, 0x0f, "Dummy value is %f.", renderState.dummy);

		bgfx::setDebug(renderState.showStats ? BGFX_DEBUG_STATS : BGFX_DEBUG_TEXT);

		// Enable stats or debug text.

		// Advance to next frame. Main thread will be kicked to process submitted rendering primitives.
		//bx::sleep(50);
		g_renderState[renderStateIndex].isBusy.store(false);
		bgfx::frame();
	}
	bgfx::shutdown();
	return 0;
}