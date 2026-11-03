cmake_minimum_required(VERSION 3.20)
project(${SKBUILD_PROJECT_NAME} VERSION ${SKBUILD_PROJECT_VERSION} LANGUAGES C CXX)

set(BUILD_SHARED_LIBS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

message(STATUS "Building ${SKBUILD_PROJECT_NAME} for ${CMAKE_SYSTEM_PROCESSOR}")

# --- Setup include folders ----------------------------------------------------

set_property(GLOBAL PROPERTY PYTHON_EXTENSIONS_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(CYTHON_HEADERS_DIR ${CMAKE_CURRENT_LIST_DIR}/include)

# --- Add scripts for Cython ---------------------------------------------------

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/src/scripts/cmake")
include(CythonExtension)

# --- Compile code -------------------------------------------------------------

add_subdirectory("src")
