cmake_minimum_required(VERSION 4.0)
project(Jello)

include("${CMAKE_SOURCE_DIR}/cmake/external/Yyjson.cmake")

set(BUILD_SHARED_LIBS              OFF)
set(CMAKE_C_EXTENSIONS             ON )
set(CMAKE_C_STANDARD               23 )
set(CMAKE_C_STANDARD_REQUIRED      ON )
set(CMAKE_COMPILE_WARNING_AS_ERROR OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS  ON )

add_executable(Jello
    "${CMAKE_SOURCE_DIR}/sources/main.c"
)
target_link_libraries(Jello PRIVATE
    yyjson
)

if(WIN32)
    target_compile_definitions(Jello PUBLIC _USE_MATH_DEFINES)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
    # cSpell: disable
    target_compile_options(Jello PRIVATE
        "-Weverything"
        "-Wno-declaration-after-statement"
        "-Wno-pre-c23-compat"
    )
    # cSpell: enable
endif()
