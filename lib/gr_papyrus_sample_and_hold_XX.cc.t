/* -*- c++ -*- */
/*
 * Copyright 2007 Free Software Foundation, Inc.
 * 
 * This file is part of GNU Radio
 * 
 * GNU Radio is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * GNU Radio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with GNU Radio; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

// @WARNING@

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gr_papyrus/@NAME@.h>
#include <gnuradio/io_signature.h>

@SPTR_NAME@
gr_papyrus_make_@BASE_NAME@ ()
{
  return @SPTR_NAME@ (new @NAME@ ());
}

@NAME@::@NAME@ ()
  : gr::sync_block ("@BASE_NAME@",
           gr::io_signature::make2 (2, 2, sizeof (@I_TYPE@), sizeof(char)),
           gr::io_signature::make (1, 1, sizeof (@O_TYPE@))),
    d_data(0)
{
}

int
@NAME@::work (int noutput_items,
           gr_vector_const_void_star &input_items,
           gr_vector_void_star &output_items)
{
  @I_TYPE@ *iptr = (@I_TYPE@ *) input_items[0];
  const char *ctrl = (const char *) input_items[1];
  @O_TYPE@ *optr = (@O_TYPE@ *) output_items[0];

  for (int i = 0; i < noutput_items; i++){
    if(ctrl[i]) {
      d_data = iptr[i];
    }
    optr[i] = d_data;
  }
  return noutput_items;
}
