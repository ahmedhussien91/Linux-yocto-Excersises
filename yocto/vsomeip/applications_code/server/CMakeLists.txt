cmake_minimum_required (VERSION 2.8)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++0x")

find_package (vsomeip3 2.6.0 REQUIRED)
find_package( Boost COMPONENTS system thread log REQUIRED )

include_directories (
    ${Boost_INCLUDE_DIR}
    ${VSOMEIP_INCLUDE_DIRS}
)

# server-app.cpp    
add_executable(server-app server-app.cpp)
target_link_libraries(server-app vsomeip3 ${Boost_LIBRARIES})
