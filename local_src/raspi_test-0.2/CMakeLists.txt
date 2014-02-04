cmake_minimum_required (VERSION 2.8) 
project (raspicam_test)
SET(CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/lib/cmake/ )
find_package(raspicam REQUIRED)
find_package(OpenCV)


add_executable (simpletest_raspicam simpletest_raspicam.cpp)  
target_link_libraries (simpletest_raspicam ${raspicam_LIBS})

add_executable (test_raspicam test_raspicam.cpp)  
target_link_libraries (test_raspicam ${raspicam_LIBS})

MESSAGE(STATUS "COMPILING OPENCV TESTS")
add_executable (test_raspicam_cv test_raspicam_cv.cpp)  
target_link_libraries (test_raspicam_cv  ${raspicam_CV_LIBS})
add_executable (simpletest_raspicam_cv simpletest_raspicam_cv.cpp)  
target_link_libraries (simpletest_raspicam_cv ${raspicam_CV_LIBS})
INSTALL_PROGRAMS(/bin test_raspicam_cv simpletest_raspicam_cv)
