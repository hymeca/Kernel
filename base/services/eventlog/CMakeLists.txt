
include_directories(
    ${REACTOS_SOURCE_DIR}/sdk/include/reactos/idl
    ${CMAKE_CURRENT_BINARY_DIR})

add_rpc_files(server ${REACTOS_SOURCE_DIR}/sdk/include/reactos/idl/eventlogrpc.idl)

list(APPEND SOURCE
    eventlog.c
    eventsource.c
    logport.c
    rpc.c
    file.c
    eventlog.h
    ${CMAKE_CURRENT_BINARY_DIR}/eventlogrpc_s.c)

add_executable(eventlog ${SOURCE} eventlog.rc)

target_link_libraries(eventlog ${PSEH_LIB})

set_module_type(eventlog win32cui UNICODE)
add_importlibs(eventlog advapi32 rpcrt4 msvcrt kernel32 ntdll)
add_pch(eventlog eventlog.h SOURCE)
add_cd_file(TARGET eventlog DESTINATION reactos/system32 FOR all)
