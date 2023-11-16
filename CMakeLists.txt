cmake_minimum_required(VERSION 3.13)

if (CMAKE_BUILD_TYPE STREQUAL "Release")
    message(STATUS "Building in Release mode")
else ()
    message(STATUS "Building in Debug mode")
endif ()

##### Project Setup #####
project(my-project)

# Configure project files
file(GLOB_RECURSE SRC_FILES "src/*.cpp")
file(GLOB_RECURSE HEADER_FILES "inc/*.hpp")
include_directories("inc")

##### Compiler, Flags, Optimizations, ... #####

# Use C++20 
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set flags to reduce binary size in release mode:
# -s:                  Strip unused sections and debug symbols
# -flot:               Apply link time optimizations
# -ffat-lto-objects:   Use fat LTO objects
# -fdata-sections:     Apply optimizations to data-sections
# -ffunction-sections: Apply optimizations to function-sections
# --gc-sections:       Cleanup unreachable sections during linking

set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -s -flto -ffat-lto-objects -fdata-sections -ffunction-sections")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -s -flto -ffat-lto-objects -fdata-sections -ffunction-sections")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -s -flto -ffat-lto-objects -Wl,--gc-sections")


##### Libraries and other dependencies #####

set(LIBRARIES PRIVATE
    Threads::Threads 
    fmt::fmt
)

# Configure local fmt library
add_subdirectory("${PROJECT_SOURCE_DIR}/lib/fmt" EXCLUDE_FROM_ALL)

# Configure pthreads system dependency
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)


##### Executable Output #####

# Create executable output
add_executable(${PROJECT_NAME}.run ${SRC_FILES} ${HEADER_FILES})

# Link executable with the previously configured dependencies
target_link_libraries(${PROJECT_NAME}.run ${LIBRARIES})

# Statically link libstdc++ (the c++ standard library). This allows to use newer features that are
# not supported by the version that is preinstalled on the target
# target_link_options(${PROJECT_NAME}.run PRIVATE -static-libstdc++)

# Show all warnings
target_compile_options(${PROJECT_NAME}.run PRIVATE -Wall -Wextra -Wpedantic)