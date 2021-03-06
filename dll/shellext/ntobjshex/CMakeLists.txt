
project(SHELL)

set_cpp(WITH_RUNTIME)

# HACK: this should be enabled globally!
add_compile_flags_language("-std=c++11" "CXX")

include_directories(
    ${REACTOS_SOURCE_DIR}/sdk/lib/atl
    ${REACTOS_SOURCE_DIR})

spec2def(ntobjshex.dll ntobjshex.spec)

file(GLOB_RECURSE ntobjshex_rc_deps resources/*.*)
add_rc_deps(ntobjshex.rc ${ntobjshex_rc_deps})

add_library(ntobjshex SHARED
    ntobjenum.cpp
    ntobjfolder.cpp
    ntobjshex.cpp
    ntobjshex.rc
    regfolder.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/ntobjshex.def)

set_module_type(ntobjshex win32dll UNICODE)
target_link_libraries(ntobjshex uuid wine atlnew)

add_importlibs(ntobjshex
    advapi32
    winmm
    ole32
    oleaut32
    shlwapi
    shell32
    comctl32
    msvcrt
    gdi32
    user32
    kernel32
    ntdll)

add_cd_file(TARGET ntobjshex DESTINATION reactos/system32 FOR all)
