# Copyright (c) 2016, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# - Try to find Argus
# Once done this will define
#  ARGUS_FOUND - System has Argus
#  ARGUS_INCLUDE_DIRS - The Argus include directories
#  ARGUS_LIBRARIES - The libraries needed to use Argus
#  ARGUS_DEFINITIONS - Compiler switches required for using Argus

find_package(PkgConfig)

find_path(ARGUS_INCLUDE_DIR Argus/Argus.h
          HINTS /usr/src/jetson_multimedia_api/argus/include)

find_library(ARGUS_LIBRARY NAMES nvargus
             HINTS /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}/tegra)
find_library(ARGUS_LIBRARY_MULTIPROCESS NAMES nvargus_socketclient
             HINTS /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}/tegra)

if (DISABLE_MULTIPROCESS)
set(ARGUS_LIBRARIES ${ARGUS_LIBRARY})
else()
set(ARGUS_LIBRARIES ${ARGUS_LIBRARY_MULTIPROCESS})
endif()

set(ARGUS_INCLUDE_DIRS ${ARGUS_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set ARGUS_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(Argus DEFAULT_MSG
                                  ARGUS_LIBRARY ARGUS_INCLUDE_DIR)

mark_as_advanced(ARGUS_INCLUDE_DIR ARGUS_LIBRARY)
