if(DEFINED __INCLUDED_GR_PAPYRUS_GENGEN_CMAKE)
    return()
endif()
set(__INCLUDED_GR_SWIG_CMAKE TRUE)

########################################################################
# code for generating templated blocks
# 
# Creates a python script that takes the following command-line args:
#   argv[1]: root block name (e.g. gr_papyrus_blockname_XX)
#   argv[2]: location of the template file
#   argv[3]: install prefix (e.g. ../include/gr_papyrus/)
#   argv[4:]: type abbreviations to replace template file 
#             (e.g. ii, fb, cc)
# 
########################################################################
include(GrPython)

macro(write_gen_helper)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generate_helper.py "
#!${PYTHON_EXECUTABLE}

import sys, os, re
sys.path.append('${CMAKE_CURRENT_SOURCE_DIR}/../python/')
os.environ['srcdir'] = '${CMAKE_CURRENT_SOURCE_DIR}'
os.chdir('${CMAKE_CURRENT_BINARY_DIR}')

if __name__ == '__main__':
    import build_utils
    root, inp, inst_prefix = sys.argv[1:4]
    for sig in sys.argv[4:]:
        name = re.sub ('X+', sig, root)
        d = build_utils.standard_dict(name, sig, package='gr_papyrus')
        build_utils.expand_template(d, inp, extra = '', install_prefix = inst_prefix)

"

)
endmacro(write_gen_helper)

macro(expand_src root)

    if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/generate_helper.py)
        write_gen_helper()
    endif()
    
    unset(expanded_files_cc)
    unset(expanded_files_h)
    unset(expanded_files_i)
    
    #make a list of all the generated files
    foreach(sig ${ARGN})
        string(REGEX REPLACE "X+" ${sig} name ${root})
        list(APPEND expanded_files_cc ${CMAKE_CURRENT_BINARY_DIR}/${name}.cc)
        list(APPEND expanded_files_h ${CMAKE_CURRENT_BINARY_DIR}/../include/gr_papyrus/${name}.h)
        list(APPEND expanded_files_i ${CMAKE_CURRENT_BINARY_DIR}/../swig/${name}.i)
    endforeach(sig)

    #create commands to generate the header, swig, and source files
    add_custom_command(
        OUTPUT ${expanded_files_cc}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${root}.cc.t
        COMMAND ${PYTHON_EXECUTABLE} ${PYTHON_DASH_B}
            ${CMAKE_CURRENT_BINARY_DIR}/generate_helper.py
            ${root} ${root}.cc.t ./ ${ARGN}
    )
    add_custom_command(
        OUTPUT ${expanded_files_h}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../include/gr_papyrus/${root}.h.t
        COMMAND ${PYTHON_EXECUTABLE} ${PYTHON_DASH_B}
            ${CMAKE_CURRENT_BINARY_DIR}/generate_helper.py
            ${root} ../include/gr_papyrus/${root}.h.t ../include/gr_papyrus/ ${ARGN}
    )
    add_custom_command(
        OUTPUT ${expanded_files_i}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../swig/${root}.i.t
        COMMAND ${PYTHON_EXECUTABLE} ${PYTHON_DASH_B}
            ${CMAKE_CURRENT_BINARY_DIR}/generate_helper.py
            ${root} ../swig/${root}.i.t ../swig/ ${ARGN}
    )

    #make source files depends on headers to force generation
    set_source_files_properties(${expanded_files_cc}
        PROPERTIES OBJECT_DEPENDS "${expanded_files_h};${expanded_files_i}"
    )

    #install rules for the generated cc files
    list(APPEND generated_gengen_sources ${expanded_files_cc})
    list(APPEND generated_gengen_includes ${expanded_files_h})
    list(APPEND generated_gengen_swigs ${expanded_files_i})
    
endmacro(expand_src)



macro(gen_master_swig)

    set(generated_index ${CMAKE_CURRENT_BINARY_DIR}/../swig/gengen_generated.i.in)
    file(WRITE ${generated_index} "
    //
    // This file is machine generated.  All edits will be overwritten
    //
    ")

    file(APPEND ${generated_index} "%{\n")
    foreach(swig_file ${generated_gengen_swigs})
        get_filename_component(name ${swig_file} NAME_WE)
        file(APPEND ${generated_index} "#include<gr_papyrus/${name}.h>\n")
    endforeach(swig_file)
    file(APPEND ${generated_index} "%}\n")

    foreach(swig_file ${generated_gengen_swigs})
        get_filename_component(name ${swig_file} NAME)
        file(APPEND ${generated_index} "%include<${name}>\n")
    endforeach(swig_file)

    execute_process(
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${generated_index} ${CMAKE_CURRENT_BINARY_DIR}/../swig/gengen_generated.i
    )

endmacro(gen_master_swig)