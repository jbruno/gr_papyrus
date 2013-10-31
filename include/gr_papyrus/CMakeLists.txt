INCLUDE(GrMiscUtils)

list(APPEND gr_papyrus_headers
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_api.h
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_frame_acquisition.h
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_frame_sink.h
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_insert_preamble.h
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_mapper_bcv.h
    ${CMAKE_CURRENT_SOURCE_DIR}/gr_papyrus_ofdm_sampler.h
)

install(FILES
    ${gr_papyrus_headers}
    DESTINATION include/gr_papyrus
)
