outputdir 		= "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"
build 			= "%{wks.location}/build/bin/"
build_obj 		= "%{wks.location}/build/obj/"

external = {}
external.path = "%{wks.location}/External"
external.libs = external.path .. "/Libs"

interne = {}
interne.path = "%{wks.location}"

libs = {}
libs.sdl3 = {
    include = external.libs .. "/SDL3/include",
    lib = {
        msvc = external.libs .. "/SDL3/msvc/x64",
        mingw = external.libs .. "/SDL3/mingw/lib",
        android = external.libs .. "/SDL3/android",
    }
}

libs.imgui = {
    include = external.libs .. "/imgui",
}

libs.glad2 = {
    include = external.libs .. "/Glad2/include",
}

libs.argengine = {
    include = interne.path .. "AREngine"
}

function BuildsInfos(projectName)
    targetdir ( build .. outputdir .. "/" .. projectName )
    objdir ( build_obj .. outputdir .. "/" .. projectName )
end

function PostBuilds2(path, libName, projectName)
    postbuildcommands {
        ("{COPY} " .. path .. "/" .. libName .. ".dll " .. build .. outputdir .. "/" .. projectName),
    }
end

workspace "ProjetAR"
    --location "build"
    configurations { "Debug", "Release" }
    platforms { "x64" }

    filter "system:windows"
        toolset "clang"

    filter "configurations:Debug"
        symbols "On"
        optimize "Off"
        defines { "DEBUG" }

    filter "configurations:Release"
        optimize "On"
        symbols "Off"
        defines { "NDEBUG" }

    filter {}
    
    include "AREngine"
    include "ARDemo"
