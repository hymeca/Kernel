## EXPERIMENTAL!!

# We need to use almost the same tricks as the ones used for 'add_asm_files'
# support because we are going to compile ASM files for a fixed target (16-bit x86)
# that is different from the main target.

###
### For GCC
###
function(add_asm16_bin _target _binary_file _base_address)
    set(_concatenated_asm_file ${CMAKE_CURRENT_BINARY_DIR}/${_target}.asm)
    set(_object_file ${CMAKE_CURRENT_BINARY_DIR}/${_target}.o)

    # unset(_source_file_list)

    get_defines(_directory_defines)
    get_includes(_directory_includes)
    get_directory_property(_defines COMPILE_DEFINITIONS)

    # Build a list of all the defines needed.
    foreach(_source_file ${ARGN})
        get_filename_component(_source_file_full_path ${_source_file} ABSOLUTE)
        get_source_file_property(_defines_semicolon_list ${_source_file_full_path} COMPILE_DEFINITIONS)

        # unset(_source_file_defines)

        foreach(_define ${_defines_semicolon_list})
            if(NOT ${_define} STREQUAL "NOTFOUND")
                list(APPEND _source_file_defines -D${_define})
            endif()
        endforeach()

        list(APPEND _source_file_list ${_source_file_full_path})
    endforeach()

    # We do not support 16-bit ASM linking so the only way to compile
    # many ASM files is by concatenating them into a single one and
    # compile the resulting file.
    concatenate_files(${_concatenated_asm_file} ${_source_file_list})
    set_source_files_properties(${_concatenated_asm_file} PROPERTIES GENERATED TRUE)

    ##
    ## All this part is the same as CreateBootSectorTarget
    ##
    add_custom_command(
        OUTPUT ${_object_file}
        COMMAND ${CMAKE_ASM_COMPILER} -x assembler-with-cpp -o ${_object_file} -I${REACTOS_SOURCE_DIR}/sdk/include/asm -I${REACTOS_BINARY_DIR}/sdk/include/asm ${_directory_includes} ${_source_file_defines} ${_directory_defines} -D__ASM__ -c ${_concatenated_asm_file}
        DEPENDS ${_concatenated_asm_file})

    add_custom_command(
        OUTPUT ${_binary_file}
        COMMAND native-obj2bin ${_object_file} ${_binary_file} ${_base_address}
        # COMMAND objcopy --output-target binary --image-base 0x${_base_address} ${_object_file} ${_binary_file}
        DEPENDS ${_object_file} native-obj2bin)

    add_custom_target(${_target} ALL DEPENDS ${_binary_file})
    # set_target_properties(${_target} PROPERTIES OUTPUT_NAME ${_target} SUFFIX ".bin")
    set_target_properties(${_target} PROPERTIES LOCATION_${CMAKE_BUILD_TYPE} ${_binary_file}) ## Support of $<TARGET_FILE:xxx> is limited to add_executable() or add_library()
    set_target_properties(${_target} PROPERTIES LOCATION ${_binary_file})                     ## Support of $<TARGET_FILE:xxx> is limited to add_executable() or add_library()
    add_clean_target(${_target})
endfunction()
