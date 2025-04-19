" ============================================================================
" ASIC Development Module
" ============================================================================
" This module provides additional functionality specifically for ASIC development
" with a focus on Synopsys tools and UVM.
"
" It can be loaded on-demand with :LoadModule asic
" ============================================================================

echo "Loading ASIC development module..."

" ============================================================================
" Load Additional ASIC-specific Plugins {{{
" ============================================================================
" Load Verilog instance plugin for UVM port connection
if !exists('g:loaded_verilog_instance')
  silent! packadd vim-verilog-instance
  let g:verilog_instance_port_connected_by_net = 1
  let g:verilog_instance_keep_comments = 1
endif
" }}}

" ============================================================================
" UVM Templates for SystemVerilog {{{
" ============================================================================
" Load UVM templates
if filereadable(expand("~/.vim/modules/uvm_templates.vim"))
  source ~/.vim/modules/uvm_templates.vim
endif
" }}}

" ============================================================================
" Synopsys Tool Integration {{{
" ============================================================================
" Load Synopsys tools integration
if filereadable(expand("~/.vim/modules/synopsys_tools.vim"))
  source ~/.vim/modules/synopsys_tools.vim
endif
" }}}

" ============================================================================
" ASIC-Specific ALE Configuration {{{
" ============================================================================
" Override ALE settings for ASIC development
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'c': ['gcc'],
\   'cpp': ['gcc'],
\   'verilog': ['spyglass'],
\   'systemverilog': ['spyglass'],
\}

" Custom SpyGlass linting
let g:ale_verilog_spyglass_executable = 'spyglass'
let g:ale_verilog_spyglass_options = '-tcl linting_rules.tcl'

" Disable linting for certain file types commonly used in ASIC flow
let g:ale_pattern_options = {
\   '\.sdc$': {'ale_enabled': 0},
\   '\.tcl$': {'ale_enabled': 0},
\   '\.lib$': {'ale_enabled': 0},
\}
" }}}

" ============================================================================
" Custom Functions for ASIC Development {{{
" ============================================================================
" ASIC Liberty and SDC file syntax
augroup liberty_sdc_files
    autocmd!
    " Liberty files
    autocmd BufRead,BufNewFile *.lib,*.liberty set filetype=liberty
    " SDC files
    autocmd BufRead,BufNewFile *.sdc,*.sdf set filetype=tcl
augroup END

" Create/update module header comments
function! UpdateVerilogHeader()
  let line = line(".")
  let col = col(".")
  
  " Find the module declaration
  let moduleLineNum = search('\<module\>\s\+\w\+', 'bcnW')
  if moduleLineNum == 0
    echo "No module found"
    return
  endif
  
  let moduleLine = getline(moduleLineNum)
  let moduleName = matchstr(moduleLine, '\<module\>\s\+\zs\w\+\ze')
  
  " Create a header template
  let header = []
  call add(header, "//-----------------------------------------------------------------------------")
  call add(header, "// Module: " . moduleName)
  call add(header, "// Description: ")
  call add(header, "//")
  call add(header, "// Author: " . $USER)
  call add(header, "// Date: " . strftime("%Y-%m-%d"))
  call add(header, "//-----------------------------------------------------------------------------")
  
  " Check if there's already a header
  let headerStart = max([1, moduleLineNum - 10])
  let headerEnd = moduleLineNum - 1
  let hasHeader = 0
  
  for i in range(headerStart, headerEnd)
    if getline(i) =~ '^\s*\/\/\s*Module:\s*' . moduleName
      let hasHeader = 1
      break
    endif
  endfor
  
  if hasHeader
    echo "Header for " . moduleName . " already exists"
  else
    call append(moduleLineNum - 1, header)
    echo "Added header for " . moduleName
  endif
  
  call cursor(line + len(header), col)
endfunction
command! VerilogHeader call UpdateVerilogHeader()

" Generate module instantiation template
function! GenerateModuleInst()
    let moduleName = expand('%:t:r')
    let moduleFile = expand('%:p')
    
    " Extract module ports
    let ports = []
    let inFile = readfile(moduleFile)
    let inModuleBlock = 0
    
    for line in inFile
        " Check for module declaration
        if line =~ '^\s*module\s\+' . moduleName && !inModuleBlock
            let inModuleBlock = 1
            continue
        endif
        
        " End of module definition
        if inModuleBlock && line =~ '^\s*);'
            break
        endif
        
        " Extract port declarations
        if inModuleBlock && line =~ '^\s*\(input\|output\|inout\)'
            let portLine = substitute(line, '^\s*\(input\|output\|inout\)\s\+\(.*\)\s*,\?\s*$', '\2', '')
            let portName = substitute(portLine, '.*\(\<\w\+\>\).*$', '\1', '')
            if portName != portLine
                call add(ports, portName)
            endif
        endif
    endfor
    
    " Generate instantiation template
    let template = []
    call add(template, moduleName . ' ' . tolower(moduleName) . '_inst (')
    
    for i in range(len(ports))
        let port = ports[i]
        let line = '    .' . port . '(' . port . ')'
        if i < len(ports) - 1
            let line .= ','
        endif
        call add(template, line)
    endfor
    
    call add(template, ');')
    
    " Insert into buffer
    call append(line('.'), template)
endfunction
command! GenInst call GenerateModuleInst()

" CDC (Clock Domain Crossing) check and highlight
function! HighlightCDCSignals()
    " Search for clock definitions
    let clocks = []
    let pos = 1
    while pos > 0
        let pos = search('\<\(input\|wire\|logic\|reg\)\>\s\+\(clk\|clock\)\w*', 'W')
        if pos > 0
            let line = getline(pos)
            let clock = matchstr(line, '\<\(clk\|clock\)\w*\>')
            if clock != ''
                call add(clocks, clock)
            endif
        endif
    endwhile
    
    " Now search for signals crossing clocks
    let crossings = []
    for clock1 in clocks
        for clock2 in clocks
            if clock1 != clock2
                " Search for patterns like "assign in_clk1 = out_clk2"
                let pattern = 'assign.*\<\w*' . clock1 . '\w*\>.*\<\w*' . clock2 . '\w*\>'
                let pos = 1
                while pos > 0
                    let pos = search(pattern, 'W')
                    if pos > 0
                        let line = getline(pos)
                        call add(crossings, {'line': pos, 'text': line})
                        " Highlight this line
                        execute 'highlight CDCWarning ctermbg=yellow guibg=#ffff00'
                        execute 'match CDCWarning /\%' . pos . 'l.*/'
                    endif
                endwhile
            endif
        endfor
    endfor
    
    if len(crossings) > 0
        echo "Found " . len(crossings) . " potential clock domain crossings"
        " Create a quickfix list
        let qf_list = []
        for crossing in crossings
            call add(qf_list, {'filename': expand('%:p'), 'lnum': crossing.line, 'text': 'CDC Warning: Consider using Synopsys VC CDC for formal verification: ' . crossing.text})
        endfor
        call setqflist(qf_list)
        copen
    else
        echo "No clock domain crossings found"
    endif
endfunction
command! CDCCheck call HighlightCDCSignals()

" Parse and analyze VCD files with VCS
function! ParseVCSVCDFile()
    let vcdFile = expand('%:p')
    if expand('%:e') != 'vcd'
        let vcdFile = input("Enter VCD file path: ")
        if vcdFile == '' || !filereadable(vcdFile)
            echo "Invalid VCD file"
            return
        endif
    endif
    
    " Open a new buffer for analysis
    execute 'new VCD_Analysis_' . fnamemodify(vcdFile, ':t:r')
    
    " Run a basic analysis using Synopsys DVE commands
    echo "Starting Synopsys DVE for VCD analysis..."
    let cmd = 'dve -vpd ' . shellescape(vcdFile) . ' &'
    call system(cmd)
    
    let output = []
    call add(output, "VCD Analysis for " . vcdFile)
    call add(output, "----------------------------------------")
    call add(output, "Opened file in Synopsys DVE for visualization")
    call add(output, "")
    call add(output, "Basic file info:")
    
    " Extract basic file info
    let fileSize = system('ls -lh ' . shellescape(vcdFile) . ' | awk \'{print $5}\'')
    call add(output, "File size: " . fileSize)
    
    " Insert into buffer
    call append(0, output)
    setlocal nomodified
    setlocal buftype=nofile
endfunction
command! VCDParse call ParseVCSVCDFile()


" ============================================================================
" ASIC-Specific Keymappings {{{
" ============================================================================
" Format alignment with Tabularize for HDL
vnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a: :Tabularize /:<CR>
vnoremap <leader>a, :Tabularize /,<CR>
vnoremap <leader>a{ :Tabularize /{<CR>
vnoremap <leader>a} :Tabularize /}<CR>
vnoremap <leader>a( :Tabularize /(<CR>
vnoremap <leader>a) :Tabularize /)<CR>

" Quick HDL module commands
nnoremap <leader>vh :VerilogHeader<CR>
nnoremap <leader>gi :GenInst<CR>
nnoremap <leader>cc :CDCCheck<CR>
" }}}

echo "ASIC development module loaded successfully!"
" vim: set foldmethod=marker foldlevel=0 ts=2 sts=2 sw=2 noet :

