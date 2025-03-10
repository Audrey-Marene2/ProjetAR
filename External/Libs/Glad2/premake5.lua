project "Glad2"
    kind "StaticLib"
    language "C++"
    cppdialect "C++20"
    staticruntime "off"

    BuildsInfos("%{prj.name}")

    files {
        "./include/**.h",
        "./src/**.c"
    }

    includedirs {
        "./include"
    }

    defines
	{
		"_CRT_SECURE_NO_WARNINGS",
		"GLFW_INCLUDE_NONE"
	}

    filter "system:windows"
        systemversion "latest"

    filter "system:macosx"
        xcodebuildsettings
        {
            ["MACOSX_DEPLOYMENT_TARGET"] = "10.15",
            ["USeModernBuildSystem"] = "NO"
        }

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"

    filter {}
