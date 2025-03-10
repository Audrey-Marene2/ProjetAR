project "ARDemo"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++20"
    --location "build/ProjetAR"

    BuildsInfos("%{prj.name}")

    files { "%{prj.location}/**.cpp", "%{prj.location}/**.h" }

    includedirs {
        "%{prj.location}",
        libs.imgui.include,    -- Doit pointer vers "External/Libs/imgui" ou similaire
        libs.glad2.include,    -- OK pour Glad2
        libs.arengine,         -- Chemin pour AREngine
        "External/Libs/SDL3/include"  -- Ajoute explicitement le chemin vers SDL3
    }
    

    links { "AREngine", "Glad2", "Imgui", "opengl32" }

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
