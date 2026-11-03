find_package(OpenMP COMPONENTS C CXX)

macro(patch_sources _inlist _outlist)
    foreach(_file IN ITEMS ${${_inlist}})
        cmake_path(GET _file FILENAME _name)
        if(EXISTS ${PROJECT_SOURCE_DIR}/patches/${_name}.patch)
            add_custom_command(
                OUTPUT
                    ${_file}
                COMMENT
                    "Patching ${_file}"
                COMMAND
                    ${Python_EXECUTABLE} ${PROJECT_SOURCE_DIR}/src/scripts/apply_patch.py
                        --input ${PROJECT_SOURCE_DIR}/vendor/cdhit/${_file}
                        --patch ${PROJECT_SOURCE_DIR}/patches/${_name}.patch
                        --output ${CMAKE_CURRENT_BINARY_DIR}/${_file}
                DEPENDS
                    ${PROJECT_SOURCE_DIR}/vendor/cdhit/${_file}
                    ${PROJECT_SOURCE_DIR}/patches/${_name}.patch
            )
        else()
            add_custom_command(
                OUTPUT
                    ${_file}
                COMMENT
                    "Copying ${_file}"
                COMMAND
                    cmake -E copy ${PROJECT_SOURCE_DIR}/vendor/cdhit/${_file} ${CMAKE_CURRENT_BINARY_DIR}/${_file}
                DEPENDS
                    ${PROJECT_SOURCE_DIR}/vendor/cdhit/${_file}
            )
        endif()
        set(${_outlist} ${${_outlist}} ${CMAKE_CURRENT_BINARY_DIR}/${_file})
    endforeach()
endmacro()

# --- Patch/copy headers -------------------------------------------------------

set(CDHIT_HEADERS
    cdhit-common.h
    cdhit-utility.h
)
patch_sources(CDHIT_HEADERS CDHIT_PATCHED_HEADERS)

# --- Patch/copy sources -------------------------------------------------------

set(CDHIT_SOURCES
    cdhit-2d.c++
    cdhit-454.c++
    # cdhit.c++
    cdhit-common.c++
    cdhit-div.c++
    cdhit-est-2d.c++
    cdhit-est.c++
    cdhit-utility.c++
)
patch_sources(CDHIT_SOURCES CDHIT_PATCHED_SOURCES)

# --- Compile core library -----------------------------------------------------

add_library(cdhit STATIC ${CDHIT_PATCHED_HEADERS} ${CDHIT_PATCHED_SOURCES})
target_include_directories(cdhit PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(cdhit PUBLIC OpenMP::OpenMP_CXX)