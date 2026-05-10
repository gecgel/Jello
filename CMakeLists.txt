cmake_minimum_required(VERSION 4.0)
project(Jello)

include("${CMAKE_SOURCE_DIR}/cmake/external/Yyjson.cmake")

add_executable(Jello
    "${CMAKE_SOURCE_DIR}/sources/main.c"
)
target_link_libraries(Jello PRIVATE
    yyjson
)
