local BUILD_DIR = path.join("build", _ACTION)
if _OPTIONS["cc"] ~= nil then
	BUILD_DIR = BUILD_DIR .. "_" .. _OPTIONS["cc"]
end
local BGFX_DIR = "bgfx"
local BIMG_DIR = "bimg"
local BX_DIR = "bx"
local GLFW_DIR = "glfw"

solution "bgfx-minimal-example"
	location(BUILD_DIR)
	startproject "helloworld"
	configurations { "Release", "Debug" }
	if os.is64bit() and not os.istarget("windows") then
		platforms "x86_64"
	else
		platforms { "x86", "x86_64" }
	end
	filter "configurations:Release"
		defines
		{
			"NDEBUG",
			"BX_CONFIG_DEBUG=0"
		}
		optimize "Full"
	filter "configurations:Debug*"
		defines
		{
			"_DEBUG",
			"BX_CONFIG_DEBUG=1"
		}
		optimize "Debug"
		symbols "On"
	filter "platforms:x86"
		architecture "x86"
	filter "platforms:x86_64"
		architecture "x86_64"
	filter "system:macosx"
		xcodebuildsettings {
			["MACOSX_DEPLOYMENT_TARGET"] = "10.9",
			["ALWAYS_SEARCH_USER_PATHS"] = "YES", -- This is the minimum version of macos we'll be able to run on
		};

function setBxCompat()
	filter "action:vs*"
		includedirs { path.join(BX_DIR, "include/compat/msvc") }
	filter { "system:windows", "action:gmake" }
		includedirs { path.join(BX_DIR, "include/compat/mingw") }
	filter { "system:macosx" }
		includedirs { path.join(BX_DIR, "include/compat/osx") }
		buildoptions { "-x objective-c++" }
	filter { }
end





group "tools/shaderc"

local GLSL_OPTIMIZER = path.join(BGFX_DIR, "3rdparty/glsl-optimizer")
local FCPP_DIR       = path.join(BGFX_DIR, "3rdparty/fcpp")
local GLSLANG        = path.join(BGFX_DIR, "3rdparty/glslang")
local SPIRV_CROSS    = path.join(BGFX_DIR, "3rdparty/spirv-cross")
local SPIRV_HEADERS  = path.join(BGFX_DIR, "3rdparty/spirv-headers")
local SPIRV_TOOLS    = path.join(BGFX_DIR, "3rdparty/spirv-tools")

project "spirv-opt"
	kind "StaticLib"

	includedirs {
		SPIRV_TOOLS,

		path.join(SPIRV_TOOLS, "include"),
		path.join(SPIRV_TOOLS, "include/generated"),
		path.join(SPIRV_TOOLS, "source"),
		path.join(SPIRV_HEADERS, "include"),
	}

	files {
		path.join(SPIRV_TOOLS, "source/opt/**.cpp"),
		path.join(SPIRV_TOOLS, "source/opt/**.h"),
		path.join(SPIRV_TOOLS, "source/reduce/**.cpp"),
		path.join(SPIRV_TOOLS, "source/reduce/**.h"),

		-- libspirv
		path.join(SPIRV_TOOLS, "source/assembly_grammar.cpp"),
		path.join(SPIRV_TOOLS, "source/assembly_grammar.h"),
		path.join(SPIRV_TOOLS, "source/binary.cpp"),
		path.join(SPIRV_TOOLS, "source/binary.h"),
		path.join(SPIRV_TOOLS, "source/cfa.h"),
		path.join(SPIRV_TOOLS, "source/diagnostic.cpp"),
		path.join(SPIRV_TOOLS, "source/diagnostic.h"),
		path.join(SPIRV_TOOLS, "source/disassemble.cpp"),
		path.join(SPIRV_TOOLS, "source/disassemble.h"),
		path.join(SPIRV_TOOLS, "source/enum_set.h"),
		path.join(SPIRV_TOOLS, "source/enum_string_mapping.cpp"),
		path.join(SPIRV_TOOLS, "source/enum_string_mapping.h"),
		path.join(SPIRV_TOOLS, "source/ext_inst.cpp"),
		path.join(SPIRV_TOOLS, "source/ext_inst.h"),
		path.join(SPIRV_TOOLS, "source/extensions.cpp"),
		path.join(SPIRV_TOOLS, "source/extensions.h"),
		path.join(SPIRV_TOOLS, "source/instruction.h"),
		path.join(SPIRV_TOOLS, "source/latest_version_glsl_std_450_header.h"),
		path.join(SPIRV_TOOLS, "source/latest_version_opencl_std_header.h"),
		path.join(SPIRV_TOOLS, "source/latest_version_spirv_header.h"),
		path.join(SPIRV_TOOLS, "source/libspirv.cpp"),
		path.join(SPIRV_TOOLS, "source/macro.h"),
		path.join(SPIRV_TOOLS, "source/name_mapper.cpp"),
		path.join(SPIRV_TOOLS, "source/name_mapper.h"),
		path.join(SPIRV_TOOLS, "source/opcode.cpp"),
		path.join(SPIRV_TOOLS, "source/opcode.h"),
		path.join(SPIRV_TOOLS, "source/operand.cpp"),
		path.join(SPIRV_TOOLS, "source/operand.h"),
		path.join(SPIRV_TOOLS, "source/parsed_operand.cpp"),
		path.join(SPIRV_TOOLS, "source/parsed_operand.h"),
		path.join(SPIRV_TOOLS, "source/print.cpp"),
		path.join(SPIRV_TOOLS, "source/print.h"),
		path.join(SPIRV_TOOLS, "source/software_version.cpp"),
		path.join(SPIRV_TOOLS, "source/spirv_constant.h"),
		path.join(SPIRV_TOOLS, "source/spirv_definition.h"),
		path.join(SPIRV_TOOLS, "source/spirv_endian.cpp"),
		path.join(SPIRV_TOOLS, "source/spirv_endian.h"),
		path.join(SPIRV_TOOLS, "source/spirv_optimizer_options.cpp"),
		path.join(SPIRV_TOOLS, "source/spirv_reducer_options.cpp"),
		path.join(SPIRV_TOOLS, "source/spirv_target_env.cpp"),
		path.join(SPIRV_TOOLS, "source/spirv_target_env.h"),
		path.join(SPIRV_TOOLS, "source/spirv_validator_options.cpp"),
		path.join(SPIRV_TOOLS, "source/spirv_validator_options.h"),
		path.join(SPIRV_TOOLS, "source/table.cpp"),
		path.join(SPIRV_TOOLS, "source/table.h"),
		path.join(SPIRV_TOOLS, "source/text.cpp"),
		path.join(SPIRV_TOOLS, "source/text.h"),
		path.join(SPIRV_TOOLS, "source/text_handler.cpp"),
		path.join(SPIRV_TOOLS, "source/text_handler.h"),
		path.join(SPIRV_TOOLS, "source/util/bit_vector.cpp"),
		path.join(SPIRV_TOOLS, "source/util/bit_vector.h"),
		path.join(SPIRV_TOOLS, "source/util/bitutils.h"),
		path.join(SPIRV_TOOLS, "source/util/hex_float.h"),
		path.join(SPIRV_TOOLS, "source/util/parse_number.cpp"),
		path.join(SPIRV_TOOLS, "source/util/parse_number.h"),
		path.join(SPIRV_TOOLS, "source/util/string_utils.cpp"),
		path.join(SPIRV_TOOLS, "source/util/string_utils.h"),
		path.join(SPIRV_TOOLS, "source/util/timer.h"),
		path.join(SPIRV_TOOLS, "source/val/basic_block.cpp"),
		path.join(SPIRV_TOOLS, "source/val/construct.cpp"),
		path.join(SPIRV_TOOLS, "source/val/decoration.h"),
		path.join(SPIRV_TOOLS, "source/val/function.cpp"),
		path.join(SPIRV_TOOLS, "source/val/instruction.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate.h"),
		path.join(SPIRV_TOOLS, "source/val/validate_adjacency.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_annotation.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_arithmetics.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_atomics.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_barriers.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_bitwise.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_builtins.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_capability.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_cfg.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_composites.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_constants.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_conversion.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_debug.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_decorations.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_derivatives.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_execution_limitations.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_extensions.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_function.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_id.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_image.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_instruction.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_interfaces.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_layout.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_literals.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_logicals.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_memory.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_memory_semantics.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_misc.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_mode_setting.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_non_uniform.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_primitives.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_scopes.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_small_type_uses.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validate_type.cpp"),
		path.join(SPIRV_TOOLS, "source/val/validation_state.cpp"),
	}

	--configuration { "vs*" }
	filter "action:vs*"
		buildoptions {
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4389", -- warning C4389: '==': signed/unsigned mismatch
			"/wd4702", -- warning C4702: unreachable code
			"/wd4706", -- warning C4706: assignment within conditional expression
		}

	--configuration { "mingw* or linux* or osx*" }
	filter "toolset:mingw* or system:linux* or osx*"
	--configuration { "mingw* or linux* or osx*" }
		buildoptions {
			"-Wno-switch",
		}

	filter "toolset:mingw*"
	--configuration { "mingw* or linux-gcc-*" }
		buildoptions {
			"-Wno-misleading-indentation",
		}

	filter {}
	--configuration {}

project "spirv-cross"
	kind "StaticLib"

	defines {
		"SPIRV_CROSS_EXCEPTIONS_TO_ASSERTIONS",
	}

	includedirs {
		path.join(SPIRV_CROSS, "include"),
	}

	files {
		path.join(SPIRV_CROSS, "spirv.hpp"),
		path.join(SPIRV_CROSS, "spirv_cfg.cpp"),
		path.join(SPIRV_CROSS, "spirv_cfg.hpp"),
		path.join(SPIRV_CROSS, "spirv_common.hpp"),
		path.join(SPIRV_CROSS, "spirv_cpp.cpp"),
		path.join(SPIRV_CROSS, "spirv_cpp.hpp"),
		path.join(SPIRV_CROSS, "spirv_cross.cpp"),
		path.join(SPIRV_CROSS, "spirv_cross.hpp"),
		path.join(SPIRV_CROSS, "spirv_cross_parsed_ir.cpp"),
		path.join(SPIRV_CROSS, "spirv_cross_parsed_ir.hpp"),
		path.join(SPIRV_CROSS, "spirv_cross_util.cpp"),
		path.join(SPIRV_CROSS, "spirv_cross_util.hpp"),
		path.join(SPIRV_CROSS, "spirv_glsl.cpp"),
		path.join(SPIRV_CROSS, "spirv_glsl.hpp"),
		path.join(SPIRV_CROSS, "spirv_hlsl.cpp"),
		path.join(SPIRV_CROSS, "spirv_hlsl.hpp"),
		path.join(SPIRV_CROSS, "spirv_msl.cpp"),
		path.join(SPIRV_CROSS, "spirv_msl.hpp"),
		path.join(SPIRV_CROSS, "spirv_parser.cpp"),
		path.join(SPIRV_CROSS, "spirv_parser.hpp"),
		path.join(SPIRV_CROSS, "spirv_reflect.cpp"),
		path.join(SPIRV_CROSS, "spirv_reflect.hpp"),
	}

	--configuration { "vs*" }
	filter "action:vs*"
		buildoptions {
			"/wd4018", -- warning C4018: '<': signed/unsigned mismatch
			"/wd4245", -- warning C4245: 'return': conversion from 'int' to 'unsigned int', signed/unsigned mismatch
			"/wd4706", -- warning C4706: assignment within conditional expression
			"/wd4715", -- warning C4715: '': not all control paths return a value
		}

	--configuration { "mingw* or linux* or osx*" }
	filter "toolset:mingw* or system:linux* or osx*"
		buildoptions {
			"-Wno-type-limits",
		}

	filter {}
	--configuration {}

project "glslang"
	kind "StaticLib"

	defines {
		"ENABLE_OPT=1", -- spirv-tools
		"ENABLE_HLSL=1",
	}

	includedirs {
		GLSLANG,
		path.join(GLSLANG, ".."),
		path.join(SPIRV_TOOLS, "include"),
		path.join(SPIRV_TOOLS, "source"),
	}

	files {
		path.join(GLSLANG, "glslang/**.cpp"),
		path.join(GLSLANG, "glslang/**.h"),

		path.join(GLSLANG, "hlsl/**.cpp"),
		path.join(GLSLANG, "hlsl/**.h"),

		path.join(GLSLANG, "SPIRV/**.cpp"),
		path.join(GLSLANG, "SPIRV/**.h"),

		path.join(GLSLANG, "OGLCompilersDLL/**.cpp"),
		path.join(GLSLANG, "OGLCompilersDLL/**.h"),
	}

	removefiles {
		path.join(GLSLANG, "glslang/OSDependent/Unix/main.cpp"),
		path.join(GLSLANG, "glslang/OSDependent/Windows/main.cpp"),
	}

	--configuration { "windows" }
	filter "system:windows*"
		removefiles {
			path.join(GLSLANG, "glslang/OSDependent/Unix/**.cpp"),
			path.join(GLSLANG, "glslang/OSDependent/Unix/**.h"),
		}

	--configuration { "not windows" }
	filter "system:not windows*"
		removefiles {
			path.join(GLSLANG, "glslang/OSDependent/Windows/**.cpp"),
			path.join(GLSLANG, "glslang/OSDependent/Windows/**.h"),
		}

	--configuration { "vs*" }
	filter "action: vs*"
		buildoptions {
			"/wd4005", -- warning C4005: '_CRT_SECURE_NO_WARNINGS': macro redefinition
			"/wd4065", -- warning C4065: switch statement contains 'default' but no 'case' labels
			"/wd4100", -- warning C4100: 'inclusionDepth' : unreferenced formal parameter
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4189", -- warning C4189: 'isFloat': local variable is initialized but not referenced
			"/wd4244", -- warning C4244: '=': conversion from 'int' to 'char', possible loss of data
			"/wd4310", -- warning C4310: cast truncates constant value
			"/wd4389", -- warning C4389: '==': signed/unsigned mismatch
			"/wd4456", -- warning C4456: declaration of 'feature' hides previous local declaration
			"/wd4457", -- warning C4457: declaration of 'token' hides function parameter
			"/wd4458", -- warning C4458: declaration of 'language' hides class member
			"/wd4702", -- warning C4702: unreachable code
			"/wd4715", -- warning C4715: 'spv::Builder::makeFpConstant': not all control paths return a value
			"/wd4838", -- warning C4838: conversion from 'spv::GroupOperation' to 'unsigned int' requires a narrowing conversion
		}

	--configuration { "mingw* or linux*" }
	filter "toolset:mingw* or system:linux*"
		buildoptions {
			"-Wno-logical-op",
			"-Wno-maybe-uninitialized",
		}

	--configuration { "mingw* or linux* or osx*" }
	filter "toolset:mingw* or system:linux* or osx*"
		buildoptions {
			"-fno-strict-aliasing", -- glslang has bugs if strict aliasing is used.
			"-Wno-ignored-qualifiers",
			"-Wno-implicit-fallthrough",
			"-Wno-missing-field-initializers",
			"-Wno-reorder",
			"-Wno-return-type",
			"-Wno-shadow",
			"-Wno-sign-compare",
			"-Wno-switch",
			"-Wno-undef",
			"-Wno-unknown-pragmas",
			"-Wno-unused-function",
			"-Wno-unused-parameter",
			"-Wno-unused-variable",
		}

	--configuration { "osx*" }
	filter "system:osx*"
		buildoptions {
			"-Wno-c++11-extensions",
			"-Wno-unused-const-variable",
			"-Wno-deprecated-register",
		}

	--configuration { "linux-gcc-*" }
	filter {"toolset:gcc*", "system:linux*"}
		buildoptions {
			"-Wno-unused-but-set-variable",
		}

	--configuration {}
	filter {}

project "glsl-optimizer"
	kind "StaticLib"

	includedirs {
		path.join(GLSL_OPTIMIZER, "src"),
		path.join(GLSL_OPTIMIZER, "include"),
		path.join(GLSL_OPTIMIZER, "src/mesa"),
		path.join(GLSL_OPTIMIZER, "src/mapi"),
		path.join(GLSL_OPTIMIZER, "src/glsl"),
	}

	files {
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/glcpp.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/glcpp-lex.c"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/glcpp-parse.c"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/glcpp-parse.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/pp.c"),

		path.join(GLSL_OPTIMIZER, "src/glsl/ast.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ast_array_index.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ast_expr.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ast_function.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ast_to_hir.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ast_type.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/builtin_functions.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/builtin_type_macros.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/builtin_types.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/builtin_variables.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_lexer.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_optimizer.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_optimizer.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_parser.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_parser.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_parser_extras.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_parser_extras.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_symbol_table.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_symbol_table.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_types.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glsl_types.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/hir_field_selection.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_basic_block.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_basic_block.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_builder.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_builder.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_clone.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_constant_expression.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_equals.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_expression_flattening.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_expression_flattening.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_function.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_function_can_inline.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_function_detect_recursion.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_function_inlining.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_hierarchical_visitor.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_hierarchical_visitor.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_hv_accept.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_import_prototypes.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_optimization.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_print_glsl_visitor.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_print_glsl_visitor.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_print_metal_visitor.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_print_metal_visitor.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_print_visitor.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_print_visitor.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_rvalue_visitor.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_rvalue_visitor.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_stats.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_stats.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_uniform.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_unused_structs.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_unused_structs.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_validate.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_variable_refcount.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_variable_refcount.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_visitor.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_atomics.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_functions.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_interface_blocks.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_uniform_block_active_visitor.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_uniform_block_active_visitor.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_uniform_blocks.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_uniform_initializers.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_uniforms.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_varyings.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/link_varyings.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/linker.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/linker.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/list.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/loop_analysis.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/loop_analysis.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/loop_controls.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/loop_unroll.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_clip_distance.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_discard.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_discard_flow.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_if_to_cond_assign.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_instructions.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_jumps.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_mat_op_to_vec.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_named_interface_blocks.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_noise.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_offset_array.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_output_reads.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_packed_varyings.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_packing_builtins.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_ubo_reference.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_variable_index_to_cond_assign.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_vec_index_to_cond_assign.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_vec_index_to_swizzle.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_vector.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_vector_insert.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/lower_vertex_id.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_algebraic.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_array_splitting.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_constant_folding.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_constant_propagation.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_constant_variable.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_copy_propagation.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_copy_propagation_elements.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_cse.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_dead_builtin_variables.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_dead_builtin_varyings.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_dead_code.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_dead_code_local.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_dead_functions.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_flatten_nested_if_blocks.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_flip_matrices.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_function_inlining.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_if_simplification.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_minmax.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_noop_swizzle.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_rebalance_tree.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_redundant_jumps.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_structure_splitting.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_swizzle_swizzle.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_tree_grafting.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/opt_vectorize.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/program.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/s_expression.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/s_expression.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/standalone_scaffolding.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/standalone_scaffolding.h"),
		path.join(GLSL_OPTIMIZER, "src/glsl/strtod.c"),
		path.join(GLSL_OPTIMIZER, "src/glsl/strtod.h"),

		path.join(GLSL_OPTIMIZER, "src/mesa/main/compiler.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/config.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/context.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/core.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/dd.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/errors.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/glheader.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/glminimal.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/imports.c"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/imports.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/macros.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/mtypes.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/main/simple_list.h"),

		path.join(GLSL_OPTIMIZER, "src/mesa/program/hash_table.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/program/prog_hash_table.c"),
		path.join(GLSL_OPTIMIZER, "src/mesa/program/prog_instruction.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/program/prog_parameter.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/program/prog_statevars.h"),
		path.join(GLSL_OPTIMIZER, "src/mesa/program/symbol_table.c"),
		path.join(GLSL_OPTIMIZER, "src/mesa/program/symbol_table.h"),

		path.join(GLSL_OPTIMIZER, "src/util/hash_table.c"),
		path.join(GLSL_OPTIMIZER, "src/util/hash_table.h"),
		path.join(GLSL_OPTIMIZER, "src/util/macros.h"),
		path.join(GLSL_OPTIMIZER, "src/util/ralloc.c"),
		path.join(GLSL_OPTIMIZER, "src/util/ralloc.h"),
	}

	removefiles {
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/glcpp.c"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/tests/**"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/**.l"),
		path.join(GLSL_OPTIMIZER, "src/glsl/glcpp/**.y"),
		path.join(GLSL_OPTIMIZER, "src/glsl/ir_set_program_inouts.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/main.cpp"),
		path.join(GLSL_OPTIMIZER, "src/glsl/builtin_stubs.cpp"),
	}

	--configuration { "Release" }
	filter "configurations:Release"
		optimize "Full"

--		removeflags {
--			-- GCC 4.9 -O2 + -fno-strict-aliasing don't work together...
--			"OptimizeSpeed",
--		}

	--configuration { "vs*" }
	filter "action:vs*"
		includedirs {
			path.join(GLSL_OPTIMIZER, "src/glsl/msvc"),
		}

		defines { -- glsl-optimizer
			"__STDC__",
			"__STDC_VERSION__=199901L",
			"strdup=_strdup",
			"alloca=_alloca",
			"isascii=__isascii",
		}

		buildoptions {
			"/wd4100", -- error C4100: '' : unreferenced formal parameter
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4132", -- warning C4132: 'deleted_key_value': const object should be initialized
			"/wd4189", -- warning C4189: 'interface_type': local variable is initialized but not referenced
			"/wd4204", -- warning C4204: nonstandard extension used: non-constant aggregate initializer
			"/wd4244", -- warning C4244: '=': conversion from 'const flex_int32_t' to 'YY_CHAR', possible loss of data
			"/wd4389", -- warning C4389: '!=': signed/unsigned mismatch
			"/wd4245", -- warning C4245: 'return': conversion from 'int' to 'unsigned int', signed/unsigned mismatch
			"/wd4701", -- warning C4701: potentially uninitialized local variable 'lower' used
			"/wd4702", -- warning C4702: unreachable code
			"/wd4706", -- warning C4706: assignment within conditional expression
			"/wd4996", -- warning C4996: 'strdup': The POSIX name for this item is deprecated. Instead, use the ISO C++ conformant name: _strdup.
		}

	--configuration { "mingw* or linux* or osx*" }
	filter "toolset:mingw* or system:linux* or osx*"
		buildoptions {
			"-fno-strict-aliasing", -- glsl-optimizer has bugs if strict aliasing is used.

			"-Wno-implicit-fallthrough",
			"-Wno-parentheses",
			"-Wno-sign-compare",
			"-Wno-unused-function",
			"-Wno-unused-parameter",
		}

		removebuildoptions {
			"-Wshadow", -- glsl-optimizer is full of -Wshadow warnings ignore it.
		}

	--configuration { "osx*" }
	filter "system:osx*"
		buildoptions {
			"-Wno-deprecated-register",
		}

	--configuration { "mingw* or linux-gcc-*" }
	filter "toolset:mingw* or system:linux*"
		buildoptions {
			"-Wno-misleading-indentation",
		}

	--configuration {}
	filter {}

project "fcpp"
	kind "StaticLib"

	defines { -- fcpp
		"NINCLUDE=64",
		"NWORK=65536",
		"NBUFF=65536",
		"OLD_PREPROCESSOR=0",
--		"MSG_PREFIX=\"Preprocessor: \"",
	}

	files {
		path.join(FCPP_DIR, "**.h"),
		path.join(FCPP_DIR, "cpp1.c"),
		path.join(FCPP_DIR, "cpp2.c"),
		path.join(FCPP_DIR, "cpp3.c"),
		path.join(FCPP_DIR, "cpp4.c"),
		path.join(FCPP_DIR, "cpp5.c"),
		path.join(FCPP_DIR, "cpp6.c"),
		path.join(FCPP_DIR, "cpp6.c"),
	}

	--configuration { "vs*" }
	filter "action:vs*"
		buildoptions {
			"/wd4055", -- warning C4055: 'type cast': from data pointer 'void *' to function pointer 'void (__cdecl *)(char *,void *)'
			"/wd4244", -- warning C4244: '=': conversion from 'const flex_int32_t' to 'YY_CHAR', possible loss of data
			"/wd4701", -- warning C4701: potentially uninitialized local variable 'lower' used
			"/wd4706", -- warning C4706: assignment within conditional expression
		}

	--configuration { "not vs*" }
	filter "action:not vs*"
		buildoptions {
			"-Wno-implicit-fallthrough",
			"-Wno-incompatible-pointer-types",
			"-Wno-parentheses-equality",
		}

	filter {}

project "shaderc"
	kind "ConsoleApp"
	--language "C++"
	--cppdialect "C++14"
	--exceptionhandling "Off"
	--rtti "Off"

	files {
		path.join(BGFX_DIR, "tools/shaderc/**.cpp"),
		path.join(BGFX_DIR, "tools/shaderc/**.h"),
		path.join(BGFX_DIR, "src/vertexlayout.**"),
		path.join(BGFX_DIR, "src/shader**"),
	}

	includedirs {
		path.join(BX_DIR, "include"),
		path.join(BIMG_DIR, "include"),
		path.join(BGFX_DIR, "include"),

		path.join(BGFX_DIR, "3rdparty/webgpu/include"),
		path.join(BGFX_DIR, "3rdparty/dxsdk/include"),

		FCPP_DIR,

		path.join(BGFX_DIR, "3rdparty/glslang/glslang/Public"),
		path.join(BGFX_DIR, "3rdparty/glslang/glslang/Include"),
		path.join(BGFX_DIR, "3rdparty/glslang"),

		path.join(GLSL_OPTIMIZER, "include"),
		path.join(GLSL_OPTIMIZER, "src/glsl"),

		SPIRV_CROSS,

		path.join(SPIRV_TOOLS, "include"),

	}

	links {
		"bx",
		"fcpp",
		"glslang",
		"glsl-optimizer",
		"spirv-opt",
		"spirv-cross",
	}



	filter "system:windows"
		links { "gdi32", "kernel32", "psapi" }
	filter "system:linux"
		links { "dl", "GL", "pthread", "X11" }
	filter "system:macosx"
		links { "QuartzCore.framework", "Metal.framework", "Cocoa.framework", "IOKit.framework", "CoreVideo.framework" }

	--using_bx()

	--configuration { "mingw-*" }
	filter { "system:windows", "action:gmake" }
		targetextension ".exe"

	--configuration { "osx*" }
	filter { "system:osx*" }
		links {
			"Cocoa.framework",
		}

	filter "action:vs*"
		includedirs {
			path.join(GLSL_OPTIMIZER, "include/c99"),
		}

	--configuration { "vs20* or mingw*" }
	filter { "system:windows", "action:gmake or vs20*" }
		links {
			"psapi",
		}

	--configuration { "osx* or linux*" }
	filter "system:osx* or linux*"
		links {
			"pthread",
		}

	filter {}
	setBxCompat()

	--if filesexist(BGFX_DIR, path.join(BGFX_DIR, "../bgfx-gnm"), {
	--	path.join(BGFX_DIR, "scripts/shaderc.lua"), }) then

	--	if filesexist(BGFX_DIR, path.join(BGFX_DIR, "../bgfx-gnm"), {
	--		path.join(BGFX_DIR, "tools/shaderc/shaderc_pssl.cpp"), }) then

	--		removefiles {
	--			path.join(BGFX_DIR, "tools/shaderc/shaderc_pssl.cpp"),
	--		}
	--	end

	--	dofile(path.join(BGFX_DIR, "../bgfx-gnm/scripts/shaderc.lua") )
	--end

	--strip()

group "tools"



--[[project "shaderc"
	kind "ConsoleApp"
	cppdialect "C++14"
	exceptionhandling "Off"
	defines "PREFIX=' '"
	rtti "Off"
	files
	{
		path.join(BGFX_DIR, "tools/shaderc/**"),
		path.join(BGFX_DIR, "3rdparty/meshoptimizer/src/*"),
		path.join(BGFX_DIR, "3rdparty/glsl-optimizer/src/**"),
		path.join(BGFX_DIR, "3rdparty/spirv-cross/*"),
		path.join(BGFX_DIR, "3rdparty/fcpp/cpp1.c"),
		path.join(BGFX_DIR, "3rdparty/fcpp/cpp2.c"),
		path.join(BGFX_DIR, "3rdparty/fcpp/cpp3.c"),
		path.join(BGFX_DIR, "3rdparty/fcpp/cpp4.c"),
		path.join(BGFX_DIR, "3rdparty/fcpp/cpp5.c"),
		path.join(BGFX_DIR, "3rdparty/fcpp/cpp6.c")
	}

	removefiles { path.join(BGFX_DIR, "3rdparty/glsl-optimizer/src/node/**") }

	includedirs
	{
		path.join(BGFX_DIR, "include"),
		path.join(BGFX_DIR, "3rdparty/fcpp"),
		path.join(BX_DIR, "include"),
		path.join(BX_DIR, "include/compat/msvc"),
		path.join(BGFX_DIR, "3rdparty/glsl-optimizer/include"),
		path.join(BGFX_DIR, "3rdparty/glsl-optimizer/src/getopt"),
		path.join(BGFX_DIR, "3rdparty/glsl-optimizer/src/mesa"),
		path.join(BGFX_DIR, "3rdparty/glsl-optimizer/src"),
		path.join(BGFX_DIR, "3rdparty/glsl-optimizer/src/glsl/"),
		path.join(BGFX_DIR, "3rdparty/glslang/glslang/Public"),
		path.join(BGFX_DIR, "3rdparty/glslang/glslang/Include"),
		path.join(BGFX_DIR, "3rdparty/glslang/"),
		path.join(BGFX_DIR, "3rdparty/spirv-tools/include"),
		path.join(BGFX_DIR, "3rdparty/spirv-cross"),
		path.join(BGFX_DIR, "3rdparty/webgpu/include")
	}
	links { "bgfx", "bimg", "bx" }
]]
project "helloworld_mt"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++14"
	exceptionhandling "Off"
	rtti "Off"
	files
	{
		"src/*",
		"assets/**"
	}

	includedirs
	{
		path.join(BGFX_DIR, "include"),
		path.join(BGFX_DIR, "3rdparty/fcpp"),
		path.join(BX_DIR, "include"),
		path.join(GLFW_DIR, "include"),
	}

	links { "bgfx", "bimg", "bx", "glfw" }
	
	filter "system:windows"
		links { "gdi32", "kernel32", "psapi" }
	filter "system:linux"
		links { "dl", "GL", "pthread", "X11" }
	filter "system:macosx"
		links { "QuartzCore.framework", "Metal.framework", "Cocoa.framework", "IOKit.framework", "CoreVideo.framework" }

--	filter "files:assets/**"
--		local test = ' HELLO '
--		local localDir = '%{file.reldirectory}'
--		print (localDir)
--		-- Remove everything up to and including 'assets\'
--		local new_path = localDir:match("assets\\(.*)")
--
--		buildmessage (' copying ' .. new_path)
--
--  	buildcommands {
--			'{COPYFILE} "%[%{file.relpath}]" "%[%{!cfg.objdir}/%{new_path}]"'
--	}

    --buildoutputs { "%[%{!cfg.objdir}/%{new_path}]" }
	setBxCompat()

project "bgfx"
	kind "StaticLib"
	language "C++"
	cppdialect "C++14"
	exceptionhandling "Off"
	rtti "Off"
	defines "__STDC_FORMAT_MACROS"
	files
	{
		path.join(BGFX_DIR, "include/bgfx/**.h"),
		path.join(BGFX_DIR, "src/*.cpp"),
		path.join(BGFX_DIR, "src/*.h"),
	}
	excludes
	{
		path.join(BGFX_DIR, "src/amalgamated.cpp"),
	}
	includedirs
	{
		path.join(BX_DIR, "include"),
		path.join(BIMG_DIR, "include"),
		path.join(BGFX_DIR, "include"),
		path.join(BGFX_DIR, "3rdparty"),
		path.join(BGFX_DIR, "3rdparty/dxsdk/include"),
		path.join(BGFX_DIR, "3rdparty/khronos")
	}
	filter "action:vs*"
		defines "_CRT_SECURE_NO_WARNINGS"
		excludes
		{
			path.join(BGFX_DIR, "src/glcontext_glx.cpp"),
			path.join(BGFX_DIR, "src/glcontext_egl.cpp")
		}
	filter "system:macosx"
		files
		{
			path.join(BGFX_DIR, "src/*.mm"),
		}
	setBxCompat()

project "bimg"
	kind "StaticLib"
	language "C++"
	cppdialect "C++14"
	exceptionhandling "Off"
	rtti "Off"
	files
	{
		path.join(BIMG_DIR, "include/bimg/*.h"),
		path.join(BIMG_DIR, "src/image.cpp"),
		path.join(BIMG_DIR, "src/image_gnf.cpp"),
		path.join(BIMG_DIR, "src/*.h"),
		path.join(BIMG_DIR, "3rdparty/astc-codec/src/decoder/*.cc")
	}
	includedirs
	{
		path.join(BX_DIR, "include"),
		path.join(BIMG_DIR, "include"),
		path.join(BIMG_DIR, "3rdparty/astc-codec"),
		path.join(BIMG_DIR, "3rdparty/astc-codec/include"),
	}
	setBxCompat()

project "bx"
	kind "StaticLib"
	language "C++"
	cppdialect "C++14"
	exceptionhandling "Off"
	rtti "Off"
	defines "__STDC_FORMAT_MACROS"
	files
	{
		path.join(BX_DIR, "include/bx/*.h"),
		path.join(BX_DIR, "include/bx/inline/*.inl"),
		path.join(BX_DIR, "src/*.cpp")
	}
	excludes
	{
		path.join(BX_DIR, "src/amalgamated.cpp"),
		path.join(BX_DIR, "src/crtnone.cpp")
	}
	includedirs
	{
		path.join(BX_DIR, "3rdparty"),
		path.join(BX_DIR, "include")
	}
	filter "configurations:Release"
		defines "BX_CONFIG_DEBUG=0"
	filter "configurations:Debug"
		defines "BX_CONFIG_DEBUG=1"
	filter "action:vs*"
		defines "_CRT_SECURE_NO_WARNINGS"
	setBxCompat()
		
project "glfw"
	kind "StaticLib"
	language "C"
	files
	{
		path.join(GLFW_DIR, "include/GLFW/*.h"),
		path.join(GLFW_DIR, "src/context.c"),
		path.join(GLFW_DIR, "src/egl_context.*"),
		path.join(GLFW_DIR, "src/init.c"),
		path.join(GLFW_DIR, "src/input.c"),
		path.join(GLFW_DIR, "src/internal.h"),
		path.join(GLFW_DIR, "src/monitor.c"),
		path.join(GLFW_DIR, "src/null*.*"),
		path.join(GLFW_DIR, "src/osmesa_context.*"),
		path.join(GLFW_DIR, "src/platform.c"),
		path.join(GLFW_DIR, "src/vulkan.c"),
		path.join(GLFW_DIR, "src/window.c"),
	}
	includedirs { path.join(GLFW_DIR, "include") }
	filter "system:windows"
		defines "_GLFW_WIN32"
		files
		{
			path.join(GLFW_DIR, "src/win32_*.*"),
			path.join(GLFW_DIR, "src/wgl_context.*")
		}
	filter "system:linux"
		defines "_GLFW_X11"
		files
		{
			path.join(GLFW_DIR, "src/glx_context.*"),
			path.join(GLFW_DIR, "src/linux*.*"),
			path.join(GLFW_DIR, "src/posix*.*"),
			path.join(GLFW_DIR, "src/x11*.*"),
			path.join(GLFW_DIR, "src/xkb*.*")
		}
	filter "system:macosx"
		defines "_GLFW_COCOA"
		files
		{
			path.join(GLFW_DIR, "src/cocoa_*.*"),
			path.join(GLFW_DIR, "src/posix_thread.h"),
			path.join(GLFW_DIR, "src/nsgl_context.h"),
			path.join(GLFW_DIR, "src/egl_context.h"),
			path.join(GLFW_DIR, "src/osmesa_context.h"),

			path.join(GLFW_DIR, "src/posix_thread.c"),
			path.join(GLFW_DIR, "src/nsgl_context.m"),
			path.join(GLFW_DIR, "src/egl_context.c"),
			path.join(GLFW_DIR, "src/nsgl_context.m"),
			path.join(GLFW_DIR, "src/osmesa_context.c"),                       
		}

	filter "action:vs*"
		defines "_CRT_SECURE_NO_WARNINGS"
