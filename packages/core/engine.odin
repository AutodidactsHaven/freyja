package core

import "../ral"
import "core:c"
import "core:fmt"
import "vendor:glfw"

Engine :: struct {
	window: glfw.WindowHandle,
}

engine_init :: proc(engine: ^Engine, window_width: int, window_height: int) {
	fmt.println("Engine init")

	if !glfw.Init() {
		fmt.println("Failed to initialise GLFW")
		return
	}

	glfw.WindowHint(glfw.RESIZABLE, glfw.FALSE) // TODO: Make our renderer resizable on the fly
	when ral.GPU_API == .Vulkan || ral.GPU_API == .Metal {
		glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	}
	fmt.println("Created window")

	engine.window = glfw.CreateWindow(i32(window_width), i32(window_height), "Celeritas Engine Test", nil, nil)
	if engine.window == nil {
		fmt.println("Unable to create window")
		return
	}

	ral.backend_init(engine.window, window_width, window_height)
	fmt.println("Initialised RAL backend")

	glfw.MakeContextCurrent(engine.window)
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(engine.window, handle_keys)
}

engine_shutdown :: proc(engine: ^Engine) {}

handle_keys :: proc "c" (window: glfw.WindowHandle, key: i32, scancode: i32, action: i32, mods: i32) {
	if key == glfw.KEY_ESCAPE {
		glfw.SetWindowShouldClose(window, true)
	}
}
