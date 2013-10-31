# Copyright 2011 Free Software Foundation, Inc.
#
# This file is part of GNU Radio
#
# GNU Radio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# GNU Radio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GNU Radio; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.



########################################################################
# Invoke macro to generate various templated blocks
########################################################################

include(GrPapyrusGengen)

expand_src(gr_papyrus_peak_detector_XX             fb ib sb)
expand_src(gr_papyrus_sample_and_hold_XX           bb ss ii ff)

#allow generated headers to be included
include_directories ("${CMAKE_CURRENT_BINARY_DIR}/../include/")

#Create the master gengen swig interface that includes the other
#generated interface files
gen_master_swig()

########################################################################
# Setup library
########################################################################

include(GrPlatform) #define LIB_SUFFIX

list(APPEND gr_papyrus_sources
    ${generated_gengen_sources}
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_frame_acquisition.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_frame_sink.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_insert_preamble.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_mapper_bcv.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_sampler.cc
)

add_library(gr_papyrus SHARED ${gr_papyrus_sources})
target_link_libraries(gr_papyrus ${Boost_LIBRARIES} ${GRUEL_LIBRARIES} ${GNURADIO_CORE_LIBRARIES})
set_target_properties(gr_papyrus PROPERTIES DEFINE_SYMBOL "gr_papyrus_EXPORTS")

########################################################################
# Install built library files
########################################################################
install(TARGETS gr_papyrus
    LIBRARY DESTINATION lib${LIB_SUFFIX} # .so/.dylib file
    ARCHIVE DESTINATION lib${LIB_SUFFIX} # .lib file
    RUNTIME DESTINATION bin              # .dll file
)

install(FILES
    ${generated_gengen_includes}
    DESTINATION include/gr_papyrus
)

if(ENABLE_PYTHON)
    install(FILES
        ${generated_gengen_swigs}
        DESTINATION include/gr_papyrus/swig
    )
endif(ENABLE_PYTHON)