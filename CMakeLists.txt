cmake_minimum_required(VERSION 2.8.12)

find_package(SofaFramework REQUIRED)

add_subdirectory(applications-dev/plugins/QmlUI)
add_subdirectory(applications-dev/plugins/SofaQtQuickGUI SofaQtQuickGUI)

find_package(image QUIET)
find_package(Compliant QUIET)
find_package(SofaQtQuickGUI QUIET)

if(image_FOUND AND SofaQtQuickGUI_FOUND)
    message("Adding (auto) image_qtquickgui (image and SofaQtQuickGUI are activated)")
    add_subdirectory(applications-dev/plugins/image_qtquickgui)
endif()

if(Compliant_FOUND AND SofaQtQuickGUI_FOUND)
    message("Adding (auto) compliant_qtquickgui (since Compliant and SofaQtQuickGUI are activated)")
    add_subdirectory(applications-dev/plugins/compliant_qtquickgui)
endif()


#optional application runSofa2
sofa_add_application(applications-dev/projects/runSofa2 runSofa2)
