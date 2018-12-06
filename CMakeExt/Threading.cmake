## Flags to enable support for multi-threading

##
# At the moment, DART_ENABLE_THREADSUPPORT enables DART_HAVE_PTHREADS since
# Pthreads are the only threading implementation currently supported.
##

if (ENABLE_THREADSUPPORT)

    MESSAGE(STATUS "Checking for C11 128-bit atomics")
    TRY_COMPILE(HAVE_128B_ATOMICS ${CMAKE_BINARY_DIR}
                ${CMAKE_SOURCE_DIR}/CMakeExt/Code/test_atomics.c
                LINK_LIBRARIES atomic
                CMAKE_FLAGS -DCMAKE_C_STANDARD=11
                OUTPUT_VARIABLE output)

    if (HAVE_128B_ATOMICS)
      message(STATUS "Found C11 128-bit atomics")
      set(CMAKE_C_FLAGS
          "${CMAKE_C_FLAGS} -DDART_HAVE_C11_128B_ATOMICS")
    else ()
      message(WARNING "Failed to find C11 128-bit atomics: ${output}")
    endif ()

    MESSAGE(STATUS "Checking for builtin __sync_add_and_fetch")
    TRY_COMPILE(DART_SYNC_BUILTINS ${CMAKE_BINARY_DIR}
                ${CMAKE_SOURCE_DIR}/CMakeExt/Code/test_builtin_sync.c
                OUTPUT_VARIABLE OUTPUT)
    if (DART_SYNC_BUILTINS)
      MESSAGE(STATUS "Found builtin __sync_add_and_fetch")
      set(CMAKE_C_FLAGS
        "${CMAKE_C_FLAGS} -DDART_HAVE_SYNC_BUILTINS")
      set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -DDART_HAVE_SYNC_BUILTINS")
    else()
      # error out for now
      MESSAGE(STATUS "Compiling builtin __sync_add_and_fetch failed with error "
                     ${OUTPUT})
      MESSAGE(FATAL_ERROR "Support for builtin __sync atomics required if "
                          "building with thread support enabled!")
    endif()

    # Find support for pthreads
    find_package(Threads REQUIRED)
    set(CMAKE_C_FLAGS
        "${CMAKE_C_FLAGS} -pthread")
    set(CMAKE_C_FLAGS
        "${CMAKE_C_FLAGS} -DDART_HAVE_PTHREADS")
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -pthread")
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -DDART_HAVE_PTHREADS")
    set(CMAKE_EXE_LINKER_FLAGS
        "${CMAKE_EXE_LINKER_FLAGS} -pthread")

endif()
