set(PRE_CONFIGURE_FILE  ${CMAKE_CURRENT_SOURCE_DIR}/git.cpp.in)
set(POST_CONFIGURE_FILE ${CMAKE_CURRENT_BINARY_DIR}/git.cpp)

include(${PROJECT_SOURCE_DIR}/cmake/modules/git_watcher.cmake)

add_library(git_watcher STATIC ${CMAKE_CURRENT_SOURCE_DIR}/git.hpp ${POST_CONFIGURE_FILE})
target_include_directories(git_watcher PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
add_dependencies(git_watcher check_git)