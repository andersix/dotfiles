" ============================================================================
" UVM Templates for SystemVerilog
" ============================================================================
" This file contains templates and abbreviations for UVM development
" It is loaded by the ASIC module when needed
" ============================================================================
"
" Command definitions:
"
" :UVMTest        - Generate a UVM test class
" :UVMSeq         - Generate a UVM sequence
" :UVMItem        - Generate a UVM sequence item
" :UVMDriver      - Generate a UVM driver
" :UVMMonitor     - Generate a UVM monitor
" :UVMAgent       - Generate a UVM agent
" :UVMEnv         - Generate a UVM environment
" :UVMScoreboard  - Generate a UVM scoreboard
" :UVMInterface   - Generate a SystemVerilog interface
" :UVMTop         - Generate a UVM testbench top module
" :UVMPackage     - Generate a UVM package declaration
" :UVMConfig      - Generate a UVM configuration class
" :UVMCoverage    - Generate a UVM coverage collector
" :UVMRegister    - Generate a UVM register model
" :UVMRegAdapter  - Generate a UVM register adapter
" :UVMRegSequence - Generate a UVM register sequence

" this module includes several useful abbreviations that automatically expand in insert mode:
"
"   uclass       - Expands to a class definition with the filename as the class name
"   uvm_comp     - Expands to the UVM component utils macro
"   uvm_obj      - Expands to the UVM object utils macro
"   uvm_phase    - Expands to a build_phase method
"   uvm_seq_item - Expands to a sequence item class definition
"

"
" ============================================================================
" UVM class and macro abbreviations
augroup uvm_files
    autocmd!
    " Set UVM file types
    autocmd BufRead,BufNewFile *uvm*.sv set filetype=verilog_systemverilog
    autocmd BufRead,BufNewFile */uvm/* set filetype=verilog_systemverilog
    
    " UVM class and macro abbreviations
    autocmd FileType verilog_systemverilog iabbrev uclass class <C-R>=expand('%:t:r')<CR> extends uvm_<C-R>=expand('%:t:r')<CR>;<CR><CR>function new(string name="<C-R>=expand('%:t:r')<CR>", uvm_component parent=null);<CR>super.new(name, parent);<CR>endfunction<CR><CR>endclass : <C-R>=expand('%:t:r')<CR>
    autocmd FileType verilog_systemverilog iabbrev uvm_comp `uvm_component_utils(<C-R>=expand('%:t:r')<CR>)
    autocmd FileType verilog_systemverilog iabbrev uvm_obj `uvm_object_utils(<C-R>=expand('%:t:r')<CR>)
    autocmd FileType verilog_systemverilog iabbrev uvm_phase function void build_phase(uvm_phase phase);<CR>super.build_phase(phase);<CR><CR>endfunction : build_phase
    autocmd FileType verilog_systemverilog iabbrev uvm_seq_item class <C-R>=expand('%:t:r')<CR> extends uvm_sequence_item;<CR><CR>`uvm_object_utils(<C-R>=expand('%:t:r')<CR>)<CR><CR>function new(string name="<C-R>=expand('%:t:r')<CR>");<CR>super.new(name);<CR>endfunction<CR><CR>endclass : <C-R>=expand('%:t:r')<CR>
augroup END

" Generate UVM test
function! GenerateUVMTest()
    let testName = input("Enter test name: ")
    if testName == ''
        echo "Test name cannot be empty"
        return
    endif
    
    let template = []
    call add(template, "class " . testName . " extends base_test;")
    call add(template, "  `uvm_component_utils(" . testName . ")")
    call add(template, "")
    call add(template, "  function new(string name=\"" . testName . "\", uvm_component parent=null);")
    call add(template, "    super.new(name, parent);")
    call add(template, "  endfunction : new")
    call add(template, "")
    call add(template, "  function void build_phase(uvm_phase phase);")
    call add(template, "    super.build_phase(phase);")
    call add(template, "    `uvm_info(get_type_name(), \"Build Phase\", UVM_LOW)")
    call add(template, "  endfunction : build_phase")
    call add(template, "")
    call add(template, "  task run_phase(uvm_phase phase);")
    call add(template, "    super.run_phase(phase);")
    call add(template, "    `uvm_info(get_type_name(), \"Run Phase\", UVM_LOW)")
    call add(template, "    phase.raise_objection(this);")
    call add(template, "    // Test body goes here")
    call add(template, "    #100;")
    call add(template, "    phase.drop_objection(this);")
    call add(template, "  endtask : run_phase")
    call add(template, "")
    call add(template, "endclass : " . testName)
    
    " Insert into buffer
    call append(line('.'), template)
endfunction
command! UVMTest call GenerateUVMTest()

" Generate UVM sequence
function! GenerateUVMSequence()
    let seqName = input("Enter sequence name: ")
    if seqName == ''
        echo "Sequence name cannot be empty"
        return
    endif
    
    let seqItemName = input("Enter sequence item name: ")
    if seqItemName == ''
        let seqItemName = "uvm_sequence_item"
    endif
    
    let template = []
    call add(template, "class " . seqName . " extends uvm_sequence #(" . seqItemName . ");")
    call add(template, "  `uvm_object_utils(" . seqName . ")")
    call add(template, "")
    call add(template, "  function new(string name=\"" . seqName . "\");")
    call add(template, "    super.new(name);")
    call add(template, "  endfunction : new")
    call add(template, "")
    call add(template, "  virtual task body();")
    call add(template, "    `uvm_info(get_type_name(), \"Starting sequence\", UVM_LOW)")
    call add(template, "    // Sequence body goes here")
    call add(template, "    req = " . seqItemName . "::type_id::create(\"req\");")
    call add(template, "    start_item(req);")
    call add(template, "    if(!req.randomize()) begin")
    call add(template, "      `uvm_error(get_type_name(), \"Randomization failed\")")
    call add(template, "    end")
    call add(template, "    finish_item(req);")
    call add(template, "  endtask : body")
    call add(template, "")
    call add(template, "endclass : " . seqName)
    
    " Insert into buffer
    call append(line('.'), template)
endfunction
command! UVMSeq call GenerateUVMSequence()

" Generate UVM driver
function! GenerateUVMDriver()
  let driverName = input("Enter driver name: ")
  if driverName == ''
    echo "Driver name cannot be empty"
    return
  endif
  
  let itemName = input("Enter transaction item name: ")
  if itemName == ''
    let itemName = "uvm_sequence_item"
  endif
  
  let template = []
  call add(template, "class " . driverName . " extends uvm_driver #(" . itemName . ");")
  call add(template, "  `uvm_component_utils(" . driverName . ")")
  call add(template, "")
  call add(template, "  // Virtual interface handle")
  call add(template, "  virtual interface vif;")
  call add(template, "")
  call add(template, "  function new(string name=\"" . driverName . "\", uvm_component parent=null);")
  call add(template, "    super.new(name, parent);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  function void build_phase(uvm_phase phase);")
  call add(template, "    super.build_phase(phase);")
  call add(template, "    // Get interface from config DB")
  call add(template, "    if(!uvm_config_db#(virtual interface)::get(this, \"\", \"vif\", vif)) begin")
  call add(template, "      `uvm_fatal(get_type_name(), \"Could not get vif from config DB\")")
  call add(template, "    end")
  call add(template, "  endfunction : build_phase")
  call add(template, "")
  call add(template, "  task run_phase(uvm_phase phase);")
  call add(template, "    " . itemName . " tx;")
  call add(template, "")
  call add(template, "    // Initial interface setup")
  call add(template, "    vif.signal = 0; // Example")
  call add(template, "")
  call add(template, "    forever begin")
  call add(template, "      // Get next item from sequencer")
  call add(template, "      seq_item_port.get_next_item(tx);")
  call add(template, "")
  call add(template, "      // Drive transaction to interface")
  call add(template, "      drive_item(tx);")
  call add(template, "")
  call add(template, "      // Signal item done to sequencer")
  call add(template, "      seq_item_port.item_done();")
  call add(template, "    end")
  call add(template, "  endtask : run_phase")
  call add(template, "")
  call add(template, "  // Task to drive a transaction to the interface")
  call add(template, "  task drive_item(" . itemName . " tx);")
  call add(template, "    @(posedge vif.clk);")
  call add(template, "    // Drive signals based on transaction")
  call add(template, "    // vif.signal = tx.signal;")
  call add(template, "  endtask : drive_item")
  call add(template, "")
  call add(template, "endclass : " . driverName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMDriver call GenerateUVMDriver()

" Generate UVM monitor
function! GenerateUVMMonitor()
  let monitorName = input("Enter monitor name: ")
  if monitorName == ''
    echo "Monitor name cannot be empty"
    return
  endif
  
  let itemName = input("Enter transaction item name: ")
  if itemName == ''
    let itemName = "uvm_sequence_item"
  endif
  
  let template = []
  call add(template, "class " . monitorName . " extends uvm_monitor;")
  call add(template, "  `uvm_component_utils(" . monitorName . ")")
  call add(template, "")
  call add(template, "  // Virtual interface handle")
  call add(template, "  virtual interface vif;")
  call add(template, "")
  call add(template, "  // Analysis port to broadcast transactions")
  call add(template, "  uvm_analysis_port #(" . itemName . ") item_collected_port;")
  call add(template, "")
  call add(template, "  function new(string name=\"" . monitorName . "\", uvm_component parent=null);")
  call add(template, "    super.new(name, parent);")
  call add(template, "    item_collected_port = new(\"item_collected_port\", this);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  function void build_phase(uvm_phase phase);")
  call add(template, "    super.build_phase(phase);")
  call add(template, "    // Get interface from config DB")
  call add(template, "    if(!uvm_config_db#(virtual interface)::get(this, \"\", \"vif\", vif)) begin")
  call add(template, "      `uvm_fatal(get_type_name(), \"Could not get vif from config DB\")")
  call add(template, "    end")
  call add(template, "  endfunction : build_phase")
  call add(template, "")
  call add(template, "  task run_phase(uvm_phase phase);")
  call add(template, "    " . itemName . " tx;")
  call add(template, "")
  call add(template, "    forever begin")
  call add(template, "      // Create new transaction")
  call add(template, "      tx = " . itemName . "::type_id::create(\"tx\");")
  call add(template, "")
  call add(template, "      // Collect transaction from interface")
  call add(template, "      collect_transaction(tx);")
  call add(template, "")
  call add(template, "      // Broadcast transaction to subscribers")
  call add(template, "      item_collected_port.write(tx);")
  call add(template, "    end")
  call add(template, "  endtask : run_phase")
  call add(template, "")
  call add(template, "  // Task to collect a transaction from the interface")
  call add(template, "  task collect_transaction(" . itemName . " tx);")
  call add(template, "    @(posedge vif.clk);")
  call add(template, "    // Sample signals from interface")
  call add(template, "    // tx.signal = vif.signal;")
  call add(template, "  endtask : collect_transaction")
  call add(template, "")
  call add(template, "endclass : " . monitorName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMMonitor call GenerateUVMMonitor()

" Generate UVM agent
function! GenerateUVMAgent()
  let agentName = input("Enter agent name: ")
  if agentName == ''
    echo "Agent name cannot be empty"
    return
  endif
  
  let itemName = input("Enter transaction item name: ")
  if itemName == ''
    let itemName = "uvm_sequence_item"
  endif
  
  let driverName = input("Enter driver name (empty for default): ")
  if driverName == ''
    let driverName = agentName . "_driver"
  endif
  
  let monitorName = input("Enter monitor name (empty for default): ")
  if monitorName == ''
    let monitorName = agentName . "_monitor"
  endif
  
  let sequencerName = input("Enter sequencer name (empty for default): ")
  if sequencerName == ''
    let sequencerName = agentName . "_sequencer"
  endif
  
  let template = []
  call add(template, "class " . agentName . " extends uvm_agent;")
  call add(template, "  `uvm_component_utils(" . agentName . ")")
  call add(template, "")
  call add(template, "  // Agent components")
  call add(template, "  " . driverName . " driver;")
  call add(template, "  " . monitorName . " monitor;")
  call add(template, "  " . sequencerName . " sequencer;")
  call add(template, "")
  call add(template, "  // Configuration")
  call add(template, "  uvm_active_passive_enum is_active = UVM_ACTIVE;")
  call add(template, "")
  call add(template, "  function new(string name=\"" . agentName . "\", uvm_component parent=null);")
  call add(template, "    super.new(name, parent);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  function void build_phase(uvm_phase phase);")
  call add(template, "    super.build_phase(phase);")
  call add(template, "")
  call add(template, "    // Always create monitor")
  call add(template, "    monitor = " . monitorName . "::type_id::create(\"monitor\", this);")
  call add(template, "")
  call add(template, "    // Create driver and sequencer only for active agent")
  call add(template, "    if(is_active == UVM_ACTIVE) begin")
  call add(template, "      driver = " . driverName . "::type_id::create(\"driver\", this);")
  call add(template, "      sequencer = " . sequencerName . "::type_id::create(\"sequencer\", this);")
  call add(template, "    end")
  call add(template, "  endfunction : build_phase")
  call add(template, "")
  call add(template, "  function void connect_phase(uvm_phase phase);")
  call add(template, "    super.connect_phase(phase);")
  call add(template, "")
  call add(template, "    // Connect driver and sequencer")
  call add(template, "    if(is_active == UVM_ACTIVE) begin")
  call add(template, "      driver.seq_item_port.connect(sequencer.seq_item_export);")
  call add(template, "    end")
  call add(template, "  endfunction : connect_phase")
  call add(template, "")
  call add(template, "endclass : " . agentName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMAgent call GenerateUVMAgent()

" Generate UVM environment
function! GenerateUVMEnv()
  let envName = input("Enter environment name: ")
  if envName == ''
    echo "Environment name cannot be empty"
    return
  endif
  
  let agentName = input("Enter agent name: ")
  if agentName == ''
    let agentName = "agent"
  endif
  
  let template = []
  call add(template, "class " . envName . " extends uvm_env;")
  call add(template, "  `uvm_component_utils(" . envName . ")")
  call add(template, "")
  call add(template, "  // Components")
  call add(template, "  " . agentName . " agent;")
  call add(template, "  // Add more components as needed (e.g., scoreboard)")
  call add(template, "")
  call add(template, "  function new(string name=\"" . envName . "\", uvm_component parent=null);")
  call add(template, "    super.new(name, parent);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  function void build_phase(uvm_phase phase);")
  call add(template, "    super.build_phase(phase);")
  call add(template, "")
  call add(template, "    // Create agent")
  call add(template, "    agent = " . agentName . "::type_id::create(\"agent\", this);")
  call add(template, "    // Create more components as needed")
  call add(template, "  endfunction : build_phase")
  call add(template, "")
  call add(template, "  function void connect_phase(uvm_phase phase);")
  call add(template, "    super.connect_phase(phase);")
  call add(template, "")
  call add(template, "    // Connect components (e.g., agent.monitor to scoreboard)")
  call add(template, "  endfunction : connect_phase")
  call add(template, "")
  call add(template, "endclass : " . envName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMEnv call GenerateUVMEnv()

" Generate UVM Scoreboard
function! GenerateUVMScoreboard()
  let sbName = input("Enter scoreboard name: ")
  if sbName == ''
    echo "Scoreboard name cannot be empty"
    return
  endif
  
  let itemName = input("Enter transaction item name: ")
  if itemName == ''
    let itemName = "uvm_sequence_item"
  endif
  
  let template = []
  call add(template, "class " . sbName . " extends uvm_scoreboard;")
  call add(template, "  `uvm_component_utils(" . sbName . ")")
  call add(template, "")
  call add(template, "  // Analysis imports")
  call add(template, "  uvm_analysis_imp#(" . itemName . ", " . sbName . ") item_collected_export;")
  call add(template, "")
  call add(template, "  // Internal queue for transaction storage")
  call add(template, "  " . itemName . " item_queue[$];")
  call add(template, "")
  call add(template, "  function new(string name=\"" . sbName . "\", uvm_component parent=null);")
  call add(template, "    super.new(name, parent);")
  call add(template, "    item_collected_export = new(\"item_collected_export\", this);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  function void build_phase(uvm_phase phase);")
  call add(template, "    super.build_phase(phase);")
  call add(template, "  endfunction : build_phase")
  call add(template, "")
  call add(template, "  // Implementation of analysis_imp write method")
  call add(template, "  virtual function void write(" . itemName . " item);")
  call add(template, "    // Process incoming transaction")
  call add(template, "    `uvm_info(get_type_name(), $sformatf(\"Received transaction: %s\", item.convert2string()), UVM_MEDIUM)")
  call add(template, "    ")
  call add(template, "    // Add item to queue")
  call add(template, "    item_queue.push_back(item);")
  call add(template, "    ")
  call add(template, "    // Compare with expected results")
  call add(template, "    check_item(item);")
  call add(template, "  endfunction : write")
  call add(template, "")
  call add(template, "  // Function to check received item against expected")
  call add(template, "  virtual function void check_item(" . itemName . " item);")
  call add(template, "    // Implement checker logic")
  call add(template, "    // if (item matches expected) begin")
  call add(template, "    //   `uvm_info(get_type_name(), \"Item PASSED check\", UVM_LOW)")
  call add(template, "    // end else begin")
  call add(template, "    //   `uvm_error(get_type_name(), \"Item FAILED check\")")
  call add(template, "    // end")
  call add(template, "  endfunction : check_item")
  call add(template, "")
  call add(template, "  // Report phase - summarize results")
  call add(template, "  function void report_phase(uvm_phase phase);")
  call add(template, "    super.report_phase(phase);")
  call add(template, "    `uvm_info(get_type_name(), $sformatf(\"Processed %0d transactions\", item_queue.size()), UVM_LOW)")
  call add(template, "  endfunction : report_phase")
  call add(template, "")
  call add(template, "endclass : " . sbName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMScoreboard call GenerateUVMScoreboard()

" Generate UVM interface
function! GenerateUVMInterface()
  let ifName = input("Enter interface name: ")
  if ifName == ''
    echo "Interface name cannot be empty"
    return
  endif
  
  let template = []
  call add(template, "interface " . ifName . "(input logic clk, input logic rst_n);")
  call add(template, "")
  call add(template, "  // Signal declarations")
  call add(template, "  logic valid;")
  call add(template, "  logic ready;")
  call add(template, "  logic [31:0] data;")
  call add(template, "")
  call add(template, "  // Clocking blocks")
  call add(template, "  clocking driver_cb @(posedge clk);")
  call add(template, "    output valid;")
  call add(template, "    output data;")
  call add(template, "    input ready;")
  call add(template, "  endclocking")
  call add(template, "")
  call add(template, "  clocking monitor_cb @(posedge clk);")
  call add(template, "    input valid;")
  call add(template, "    input data;")
  call add(template, "    input ready;")
  call add(template, "  endclocking")
  call add(template, "")
  call add(template, "  // Modport declarations")
  call add(template, "  modport driver (clocking driver_cb, input clk, input rst_n);")
  call add(template, "  modport monitor (clocking monitor_cb, input clk, input rst_n);")
  call add(template, "")
  call add(template, "endinterface : " . ifName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMInterface call GenerateUVMInterface()

" Generate UVM testbench top
function! GenerateUVMTop()
  let tbName = input("Enter testbench top name: ")
  if tbName == ''
    let tbName = "tb_top"
  endif
  
  let ifName = input("Enter interface name: ")
  if ifName == ''
    let ifName = "dut_if"
  endif
  
  let dutName = input("Enter DUT module name: ")
  if dutName == ''
    let dutName = "dut"
  endif
  
  let template = []
  call add(template, "`include \"uvm_macros.svh\"")
  call add(template, "import uvm_pkg::*;")
  call add(template, "")
  call add(template, "// Include testbench files")
  call add(template, "// `include \"dut_if.sv\"")
  call add(template, "// `include \"test_pkg.sv\"")
  call add(template, "// import test_pkg::*;")
  call add(template, "")
  call add(template, "module " . tbName . ";")
  call add(template, "")
  call add(template, "  // Clock and reset")
  call add(template, "  logic clk;")
  call add(template, "  logic rst_n;")
  call add(template, "")
  call add(template, "  // Clock generation")
  call add(template, "  initial begin")
  call add(template, "    clk = 0;")
  call add(template, "    forever #5 clk = ~clk;")
  call add(template, "  end")
  call add(template, "")
  call add(template, "  // Reset generation")
  call add(template, "  initial begin")
  call add(template, "    rst_n = 0;")
  call add(template, "    #20 rst_n = 1;")
  call add(template, "  end")
  call add(template, "")
  call add(template, "  // Interface instance")
  call add(template, "  " . ifName . " vif(clk, rst_n);")
  call add(template, "")
  call add(template, "  // DUT instance")
  call add(template, "  " . dutName . " dut (")
  call add(template, "    .clk(clk),")
  call add(template, "    .rst_n(rst_n),")
  call add(template, "    .valid(vif.valid),")
  call add(template, "    .ready(vif.ready),")
  call add(template, "    .data(vif.data)")
  call add(template, "  );")
  call add(template, "")
  call add(template, "  // Start UVM test")
  call add(template, "  initial begin")
  call add(template, "    // Set interface in config DB")
  call add(template, "    uvm_config_db#(virtual " . ifName . ")::set(null, \"*\", \"vif\", vif);")
  call add(template, "")
  call add(template, "    // Run test")
  call add(template, "    run_test();")
  call add(template, "  end")
  call add(template, "")
  call add(template, "  // Optional: Dump waveforms")
  call add(template, "  initial begin")
  call add(template, "    $dumpfile(\"dump.vcd\");")
  call add(template, "    $dumpvars(0, " . tbName . ");")
  call add(template, "  end")
  call add(template, "")
  call add(template, "endmodule : " . tbName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMTop call GenerateUVMTop()

" Generate UVM package
function! GenerateUVMPackage()
  let pkgName = input("Enter package name: ")
  if pkgName == ''
    echo "Package name cannot be empty"
    return
  endif
  
  let template = []
  call add(template, "package " . pkgName . ";")
  call add(template, "")
  call add(template, "  import uvm_pkg::*;")
  call add(template, "  `include \"uvm_macros.svh\"")
  call add(template, "")
  call add(template, "  // Forward declarations")
  call add(template, "  // typedef class my_item;")
  call add(template, "  // typedef class my_sequence;")
  call add(template, "")
  call add(template, "  // Include files")
  call add(template, "  // `include \"my_item.sv\"")
  call add(template, "  // `include \"my_sequence.sv\"")
  call add(template, "  // `include \"my_driver.sv\"")
  call add(template, "  // `include \"my_monitor.sv\"")
  call add(template, "  // `include \"my_agent.sv\"")
  call add(template, "  // `include \"my_scoreboard.sv\"")
  call add(template, "  // `include \"my_env.sv\"")
  call add(template, "  // `include \"my_test.sv\"")
  call add(template, "")
  call add(template, "endpackage : " . pkgName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMPackage call GenerateUVMPackage()

" Generate UVM sequence item
function! GenerateUVMSequenceItem()
  let itemName = input("Enter sequence item name: ")
  if itemName == ''
    echo "Sequence item name cannot be empty"
    return
  endif

  let template = []
  call add(template, "class " . itemName . " extends uvm_sequence_item;")
  call add(template, "  `uvm_object_utils(" . itemName . ")")
  call add(template, "")
  call add(template, "  // Data fields")
  call add(template, "  rand bit [31:0] addr;")
  call add(template, "  rand bit [31:0] data;")
  call add(template, "  rand bit        write;")
  call add(template, "")
  call add(template, "  // Constraints")
  call add(template, "  constraint c_addr { addr inside {[0:32'hFFFF]}; }")
  call add(template, "")
  call add(template, "  function new(string name=\"" . itemName . "\");")
  call add(template, "    super.new(name);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  // Convert to string for debug")
  call add(template, "  virtual function string convert2string();")
  call add(template, "    return $sformatf(\"addr=0x%0h, data=0x%0h, write=%0b\", addr, data, write);")
  call add(template, "  endfunction : convert2string")
  call add(template, "")
  call add(template, "  // Compare objects")
  call add(template, "  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);")
  call add(template, "    " . itemName . " rhs_;")
  call add(template, "    if(!$cast(rhs_, rhs)) begin")
  call add(template, "      return 0;")
  call add(template, "    end")
  call add(template, "    return (addr == rhs_.addr) &&")
  call add(template, "           (data == rhs_.data) &&")
  call add(template, "           (write == rhs_.write);")
  call add(template, "  endfunction : do_compare")
  call add(template, "")
  call add(template, "  // Copy object")
  call add(template, "  virtual function void do_copy(uvm_object rhs);")
  call add(template, "    " . itemName . " rhs_;")
  call add(template, "    if(!$cast(rhs_, rhs)) begin")
  call add(template, "      `uvm_error(get_type_name(), \"Cannot cast to " . itemName . "\")")
  call add(template, "      return;")
  call add(template, "    end")
  call add(template, "    addr = rhs_.addr;")
  call add(template, "    data = rhs_.data;")
  call add(template, "    write = rhs_.write;")
  call add(template, "  endfunction : do_copy")
  call add(template, "")
  call add(template, "endclass : " . itemName)

  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMItem call GenerateUVMSequenceItem()

" Generate UVM config object
function! GenerateUVMConfig()
  let configName = input("Enter config object name: ")
  if configName == ''
    echo "Config name cannot be empty"
    return
  endif
  
  let template = []
  call add(template, "class " . configName . " extends uvm_object;")
  call add(template, "  `uvm_object_utils(" . configName . ")")
  call add(template, "")
  call add(template, "  // Configuration parameters")
  call add(template, "  bit has_coverage = 1;")
  call add(template, "  uvm_active_passive_enum is_active = UVM_ACTIVE;")
  call add(template, "  int unsigned num_transactions = 100;")
  call add(template, "  bit [31:0] base_address = 32'h0000_0000;")
  call add(template, "")
  call add(template, "  function new(string name=\"" . configName . "\");")
  call add(template, "    super.new(name);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  // Convenience methods to access the configuration")
  call add(template, "  static function " . configName . " get_config(uvm_component comp, string name=\"config\");")
  call add(template, "    " . configName . " cfg;")
  call add(template, "    if (!uvm_config_db #(" . configName . ")::get(comp, \"\", name, cfg)) begin")
  call add(template, "      comp.`uvm_fatal(\"CFG_ERROR\", $sformatf(\"Cannot get() configuration %s from uvm_config_db\", name))")
  call add(template, "    end")
  call add(template, "    return cfg;")
  call add(template, "  endfunction : get_config")
  call add(template, "")
  call add(template, "  // Set config into the database")
  call add(template, "  static function void set_config(uvm_component comp, string name=\"config\", " . configName . " cfg);")
  call add(template, "    if (!uvm_config_db #(" . configName . ")::set(comp, \"\", name, cfg)) begin")
  call add(template, "      comp.`uvm_fatal(\"CFG_ERROR\", $sformatf(\"Cannot set() configuration %s in uvm_config_db\", name))")
  call add(template, "    end")
  call add(template, "  endfunction : set_config")
  call add(template, "")
  call add(template, "endclass : " . configName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMConfig call GenerateUVMConfig()

" Generate UVM subscriber/coverage
function! GenerateUVMCoverage()
  let covName = input("Enter coverage component name: ")
  if covName == ''
    echo "Coverage name cannot be empty"
    return
  endif
  
  let itemName = input("Enter transaction item name: ")
  if itemName == ''
    let itemName = "uvm_sequence_item"
  endif
  
  let template = []
  call add(template, "class " . covName . " extends uvm_subscriber #(" . itemName . ");")
  call add(template, "  `uvm_component_utils(" . covName . ")")
  call add(template, "")
  call add(template, "  // Transaction being analyzed")
  call add(template, "  " . itemName . " tx;")
  call add(template, "")
  call add(template, "  // Coverage groups")
  call add(template, "  covergroup cg_transaction;")
  call add(template, "    // Address coverage")
  call add(template, "    cp_addr: coverpoint tx.addr {")
  call add(template, "      bins low = {[0:16'h3FFF]};")
  call add(template, "      bins mid = {[16'h4000:16'h7FFF]};")
  call add(template, "      bins high = {[16'h8000:16'hFFFF]};")
  call add(template, "    }")
  call add(template, "")
  call add(template, "    // Data coverage")
  call add(template, "    cp_data: coverpoint tx.data {")
  call add(template, "      bins zeros = {0};")
  call add(template, "      bins others = {[1:$]};")
  call add(template, "    }")
  call add(template, "")
  call add(template, "    // Operation type coverage")
  call add(template, "    cp_write: coverpoint tx.write {")
  call add(template, "      bins read = {0};")
  call add(template, "      bins write = {1};")
  call add(template, "    }")
  call add(template, "")
  call add(template, "    // Cross coverage")
  call add(template, "    cx_addr_write: cross cp_addr, cp_write;")
  call add(template, "  endgroup")
  call add(template, "")
  call add(template, "  function new(string name=\"" . covName . "\", uvm_component parent=null);")
  call add(template, "    super.new(name, parent);")
  call add(template, "    cg_transaction = new();")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  // Implement analysis_port write method")
  call add(template, "  virtual function void write(" . itemName . " t);")
  call add(template, "    tx = t;")
  call add(template, "    cg_transaction.sample();")
  call add(template, "  endfunction : write")
  call add(template, "")
  call add(template, "  // Report coverage at end of test")
  call add(template, "  virtual function void report_phase(uvm_phase phase);")
  call add(template, "    super.report_phase(phase);")
  call add(template, "    `uvm_info(get_type_name(), $sformatf(\"Coverage: %0.2f%%\", cg_transaction.get_coverage()), UVM_LOW)")
  call add(template, "  endfunction : report_phase")
  call add(template, "")
  call add(template, "endclass : " . covName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMCoverage call GenerateUVMCoverage()

" Generate UVM register model
function! GenerateUVMRegister()
  let regName = input("Enter register block name: ")
  if regName == ''
    echo "Register block name cannot be empty"
    return
  endif
  
  let template = []
  call add(template, "// Individual register definition")
  call add(template, "class ctrl_reg extends uvm_reg;")
  call add(template, "  `uvm_object_utils(ctrl_reg)")
  call add(template, "")
  call add(template, "  // Register fields")
  call add(template, "  rand uvm_reg_field enable;")
  call add(template, "  rand uvm_reg_field mode;")
  call add(template, "  rand uvm_reg_field reserved;")
  call add(template, "")
  call add(template, "  function new(string name = \"ctrl_reg\");")
  call add(template, "    super.new(name, 32, UVM_NO_COVERAGE);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  virtual function void build();")
  call add(template, "    // Create fields")
  call add(template, "    enable = uvm_reg_field::type_id::create(\"enable\");")
  call add(template, "    mode = uvm_reg_field::type_id::create(\"mode\");")
  call add(template, "    reserved = uvm_reg_field::type_id::create(\"reserved\");")
  call add(template, "")
  call add(template, "    // Configure fields")
  call add(template, "    enable.configure(this, 1, 0, \"RW\", 0, 1'h0, 1, 1, 0);")
  call add(template, "    mode.configure(this, 2, 1, \"RW\", 0, 2'h0, 1, 1, 0);")
  call add(template, "    reserved.configure(this, 29, 3, \"RO\", 0, 29'h0, 1, 0, 0);")
  call add(template, "  endfunction : build")
  call add(template, "endclass : ctrl_reg")
  call add(template, "")
  call add(template, "// Register block definition")
  call add(template, "class " . regName . " extends uvm_reg_block;")
  call add(template, "  `uvm_object_utils(" . regName . ")")
  call add(template, "")
  call add(template, "  // Registers")
  call add(template, "  rand ctrl_reg CTRL;")
  call add(template, "  rand uvm_reg STATUS;")
  call add(template, "  rand uvm_reg DATA;")
  call add(template, "")
  call add(template, "  // Default map")
  call add(template, "  uvm_reg_map default_map;")
  call add(template, "")
  call add(template, "  function new(string name = \"" . regName . "\");")
  call add(template, "    super.new(name, UVM_NO_COVERAGE);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  virtual function void build();")
  call add(template, "    // Create registers")
  call add(template, "    CTRL = ctrl_reg::type_id::create(\"CTRL\");")
  call add(template, "    CTRL.configure(this);")
  call add(template, "    CTRL.build();")
  call add(template, "")
  call add(template, "    STATUS = uvm_reg::type_id::create(\"STATUS\");")
  call add(template, "    STATUS.configure(this, 32, 0);")
  call add(template, "    STATUS.build();")
  call add(template, "")
  call add(template, "    DATA = uvm_reg::type_id::create(\"DATA\");")
  call add(template, "    DATA.configure(this, 32, 0);")
  call add(template, "    DATA.build();")
  call add(template, "")
  call add(template, "    // Create address map")
  call add(template, "    default_map = create_map(\"default_map\", 0, 4, UVM_LITTLE_ENDIAN);")
  call add(template, "    default_map.add_reg(CTRL, 'h0, \"RW\");")
  call add(template, "    default_map.add_reg(STATUS, 'h4, \"RO\");")
  call add(template, "    default_map.add_reg(DATA, 'h8, \"RW\");")
  call add(template, "")
  call add(template, "    // Lock model")
  call add(template, "    lock_model();")
  call add(template, "  endfunction : build")
  call add(template, "")
  call add(template, "endclass : " . regName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMRegister call GenerateUVMRegister()

" Generate UVM Register Adapter
function! GenerateUVMRegAdapter()
  let adapterName = input("Enter register adapter name: ")
  if adapterName == ''
    echo "Adapter name cannot be empty"
    return
  endif
  
  let itemName = input("Enter transaction item name: ")
  if itemName == ''
    let itemName = "uvm_sequence_item"
  endif
  
  let template = []
  call add(template, "class " . adapterName . " extends uvm_reg_adapter;")
  call add(template, "  `uvm_object_utils(" . adapterName . ")")
  call add(template, "")
  call add(template, "  function new(string name=\"" . adapterName . "\");")
  call add(template, "    super.new(name);")
  call add(template, "    // Set adapter properties")
  call add(template, "    supports_byte_enable = 0;")
  call add(template, "    provides_responses = 1;")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  // Convert from uvm_reg_bus_op to protocol-specific transaction")
  call add(template, "  virtual function " . itemName . " reg2bus(const ref uvm_reg_bus_op rw);")
  call add(template, "    " . itemName . " tx;")
  call add(template, "    tx = " . itemName . "::type_id::create(\"tx\");")
  call add(template, "    ")
  call add(template, "    // Fill in transaction fields based on register operation")
  call add(template, "    tx.addr = rw.addr;")
  call add(template, "    tx.data = rw.data;")
  call add(template, "    tx.write = (rw.kind == UVM_WRITE) ? 1 : 0;")
  call add(template, "    ")
  call add(template, "    return tx;")
  call add(template, "  endfunction : reg2bus")
  call add(template, "")
  call add(template, "  // Convert from protocol-specific transaction to uvm_reg_bus_op")
  call add(template, "  virtual function void bus2reg(uvm_sequence_item bus_item,")
  call add(template, "                                ref uvm_reg_bus_op rw);")
  call add(template, "    " . itemName . " tx;")
  call add(template, "    if (!$cast(tx, bus_item)) begin")
  call add(template, "      `uvm_fatal(\"REG_ADAPT\", $sformatf(\"Provided bus_item is not of type %s\", " . itemName . "::get_type_name()))")
  call add(template, "      return;")
  call add(template, "    end")
  call add(template, "    ")
  call add(template, "    // Fill in register operation fields based on transaction")
  call add(template, "    rw.kind = tx.write ? UVM_WRITE : UVM_READ;")
  call add(template, "    rw.addr = tx.addr;")
  call add(template, "    rw.data = tx.data;")
  call add(template, "    rw.status = UVM_IS_OK;")
  call add(template, "  endfunction : bus2reg")
  call add(template, "")
  call add(template, "endclass : " . adapterName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMRegAdapter call GenerateUVMRegAdapter()

" Generate UVM Register Sequence
function! GenerateUVMRegSequence()
  let seqName = input("Enter register sequence name: ")
  if seqName == ''
    echo "Sequence name cannot be empty"
    return
  endif
  
  let regBlockName = input("Enter register block name: ")
  if regBlockName == ''
    let regBlockName = "reg_block"
  endif
  
  let template = []
  call add(template, "class " . seqName . " extends uvm_reg_sequence;")
  call add(template, "  `uvm_object_utils(" . seqName . ")")
  call add(template, "")
  call add(template, "  // Register block to operate on")
  call add(template, "  " . regBlockName . " regmodel;")
  call add(template, "")
  call add(template, "  function new(string name=\"" . seqName . "\");")
  call add(template, "    super.new(name);")
  call add(template, "  endfunction : new")
  call add(template, "")
  call add(template, "  virtual task body();")
  call add(template, "    uvm_status_e status;")
  call add(template, "    uvm_reg_data_t value;")
  call add(template, "")
  call add(template, "    // Check if regmodel is valid")
  call add(template, "    if (regmodel == null) begin")
  call add(template, "      `uvm_error(get_type_name(), \"Register model handle is null\")")
  call add(template, "      return;")
  call add(template, "    end")
  call add(template, "")
  call add(template, "    // Example: Reset all registers")
  call add(template, "    regmodel.reset();")
  call add(template, "")
  call add(template, "    // Example: Write to CTRL register")
  call add(template, "    regmodel.CTRL.write(status, 'h00000003, .parent(this));")
  call add(template, "    if (status != UVM_IS_OK) begin")
  call add(template, "      `uvm_error(get_type_name(), $sformatf(\"Write to CTRL register failed: %s\", status.name()))")
  call add(template, "    end")
  call add(template, "")
  call add(template, "    // Example: Read from STATUS register")
  call add(template, "    regmodel.STATUS.read(status, value, .parent(this));")
  call add(template, "    if (status != UVM_IS_OK) begin")
  call add(template, "      `uvm_error(get_type_name(), $sformatf(\"Read from STATUS register failed: %s\", status.name()))")
  call add(template, "    end else begin")
  call add(template, "      `uvm_info(get_type_name(), $sformatf(\"STATUS = 0x%0h\", value), UVM_LOW)")
  call add(template, "    end")
  call add(template, "")
  call add(template, "    // Example: Update DATA register")
  call add(template, "    regmodel.DATA.write(status, 'hDEADBEEF, .parent(this));")
  call add(template, "    if (status != UVM_IS_OK) begin")
  call add(template, "      `uvm_error(get_type_name(), $sformatf(\"Write to DATA register failed: %s\", status.name()))")
  call add(template, "    end")
  call add(template, "")
  call add(template, "    // Readback and verify")
  call add(template, "    regmodel.DATA.read(status, value, .parent(this));")
  call add(template, "    if (value != 'hDEADBEEF) begin")
  call add(template, "      `uvm_error(get_type_name(), $sformatf(\"DATA register readback mismatch: Expected 0xDEADBEEF, Got 0x%0h\", value))")
  call add(template, "    end")
  call add(template, "  endtask : body")
  call add(template, "")
  call add(template, "endclass : " . seqName)
  
  " Insert into buffer
  call append(line('.'), template)
endfunction
command! UVMRegSequence call GenerateUVMRegSequence()


