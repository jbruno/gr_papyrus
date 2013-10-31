/* -*- c++ -*- */

#define GR_PAPYRUS_API

%include "gnuradio.i"			// the common stuff
%{
#include "gr_papyrus/gr_papyrus_ofdm_frame_acquisition.h"
#include "gr_papyrus/gr_papyrus_ofdm_frame_sink.h"
#include "gr_papyrus/gr_papyrus_ofdm_insert_preamble.h"
#include "gr_papyrus/gr_papyrus_ofdm_mapper_bcv.h"
#include "gr_papyrus/gr_papyrus_ofdm_sampler.h"
%}

GR_SWIG_BLOCK_MAGIC(gr_papyrus, ofdm_frame_acquisition);
%include "gr_papyrus/gr_papyrus_ofdm_frame_acquisition.h"

GR_SWIG_BLOCK_MAGIC(gr_papyrus, ofdm_frame_sink);
%include "gr_papyrus/gr_papyrus_ofdm_frame_sink.h"

GR_SWIG_BLOCK_MAGIC(gr_papyrus, ofdm_insert_preamble);
%include "gr_papyrus/gr_papyrus_ofdm_insert_preamble.h"

GR_SWIG_BLOCK_MAGIC(gr_papyrus, ofdm_mapper_bcv);
%include "gr_papyrus/gr_papyrus_ofdm_mapper_bcv.h"

GR_SWIG_BLOCK_MAGIC(gr_papyrus, ofdm_sampler);
%include "gr_papyrus/gr_papyrus_ofdm_sampler.h"

%include "gengen_generated.i"

