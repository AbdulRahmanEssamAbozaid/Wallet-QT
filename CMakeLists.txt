cmake_minimum_required(VERSION 3.16)

project(Wallet VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appWallet
    main.cpp
    WalletBridge.h
    WalletBridge.cpp
    User.h
    User.cpp
)

qt_add_qml_module(appWallet
    URI Wallet
    VERSION 1.0
    NO_RESOURCE_TARGET_PATH
    QML_FILES
        Main.qml
        LoginScreen.qml
        HomeScreen.qml
        TransactionScreen.qml
)

set_target_properties(appWallet PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appWallet
    PRIVATE Qt6::Quick
)

install(TARGETS appWallet
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
