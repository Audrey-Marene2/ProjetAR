project "AREngine"
    kind "StaticLib"
    language "C++"
    cppdialect "C++20"
    --location "build/ProjetAR"

    BuildsInfos("%{prj.name}")

    files { "src/**.cpp", "src/**.h" }

    includedirs { 
        "src", 
        libs.imgui.include, 
        libs.glad2.include 
    }

    links { "Glad2", "Imgui", "opengl32" }

    filter "system:windows"
        links { "msvcrt", "SDL3" }
        buildoptions { "/Wall" }
        includedirs { libs.sdl3.include }
        libdirs { libs.sdl3.lib.msvc }
        PostBuilds2(libs.sdl3.lib.msvc, "SDL3", "%{prj.name}")

    filter "system:linux"
        links { "pthread", "dl" }
        buildoptions { "-Wall", "-Wextra", "-Wpedantic", "-Wshadow", "-Werror" }
        linkoptions { "-static-libstdc++" }

    filter "system:macosx"
        buildoptions { "-Wall", "-Wextra", "-Wpedantic", "-Wshadow", "-Werror" }
        linkoptions { "-stdlib=libc++" }
