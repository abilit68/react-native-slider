cmake_minimum_required(VERSION 3.13)
set(CMAKE_VERBOSE_MAKEFILE on)

set(rnoh_slider_generated_dir "${CMAKE_CURRENT_SOURCE_DIR}/generated")
file(GLOB_RECURSE rnoh_slider_generated_SRC "${rnoh_slider_generated_dir}/**/*.cpp")
file(GLOB rnoh_slider_SRC CONFIGURE_DEPENDS *.cpp)
add_library(rnoh_slider SHARED ${rnoh_slider_SRC} ${rnoh_slider_generated_SRC})
target_include_directories(rnoh_slider PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${rnoh_slider_generated_dir})
target_link_libraries(rnoh_slider PUBLIC rnoh)