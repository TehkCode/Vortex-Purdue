/*
  Eric Villasenor
  evillase@gmail.com

  system test bench, for connected processor (datapath+cache)
  and memory (ram).

*/

// interface
`include "system_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module system_tb;
  // clock period
  parameter PERIOD = 20;

  // signals
  logic CLK = 1, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  system_if syif();

  // test program
  test PROG (CLK,nRST,syif);

  // dut
`ifndef MAPPED
  system                              DUT (CLK,nRST,syif);
  /*
  // NOTE: All of these signals MUST be passed all the way through
  // to the write back stage and sampled in the WRITEBACK stage.
  // This means more signals that would normally be necessary
  // for correct execution must be passed along to help with debugging.
  cpu_tracker                         cpu_track0 (
    // No need to change this
    .CLK(DUT.CPU.DP.CLK),
    // This is the enable signal for the write back stage
    .wb_enable(DUT.CPU.DP.pipeline_enable),
    // The 'funct' portion of an instruction. Must be of funct_t type
    .funct(DUT.CPU.DP.MW_o.funct),
    // The 'opcode' portion of an instruction. Must be of opcode_t type
    .opcode(DUT.CPU.DP.MW_o.opcode),
    // The 'rs' portion of an instruction
    .rs(DUT.CPU.DP.MW_o.rs),
    // The 'rt' portion of an instruction
    .rt(DUT.CPU.DP.MW_o.rt),
    // The final wsel
    .wsel(DUT.CPU.DP.MW_o.wsel),
    // The 32 bit instruction
    .instr(DUT.CPU.DP.MW_o.instr),
    // Connect the PC to this
    .pc(DUT.CPU.DP.MW_o.pc),
    // Connect the next PC value (the next registered value) here
    .next_pc_val(DUT.CPU.DP.MW_o.next_pc_val),
    // The final imm/shamt signals
    // This means it should already be extended 
    .imm(DUT.CPU.DP.MW_o.imm_shamt_final),
    .shamt(DUT.CPU.DP.MW_o.imm_shamt_final),
    // the value for lui BEFORE being being shifted
     .lui_pre_shift(DUT.CPU.DP.MW_o.lui_pre_shift),
    // The branch target (aka offset added to npc)
    .branch_addr(DUT.CPU.DP.MW_o.baddr),
    // Port O of the ALU from the M/W register
    .dat_addr(DUT.CPU.DP.MW_o.portO),
    // The value that was stored in memory during MEM stage
    .store_dat(DUT.CPU.DP.MW_o.rdat2),
    // The value selected to be written into register during WB stage
    .reg_dat(DUT.CPU.DP.MW_o.wdat)
  );
  */
`else
  system                              DUT (,,,,//for altera debug ports
    CLK,
    nRST,
    syif.halt,
    syif.load,
    syif.addr,
    syif.store,
    syif.REN,
    syif.WEN,
    syif.tbCTRL
  );
`endif
endmodule

program test(input logic CLK, output logic nRST, system_if.tb syif);
  // import word type
  import cpu_types_pkg::word_t;

  // number of cycles
  int unsigned cycles = 0;

  initial
  begin
    nRST = 0;
    syif.tbCTRL = 0;
    syif.addr = 0;
    syif.store = 0;
    syif.WEN = 0;
    syif.REN = 0;
    @(posedge CLK);
    $display("Starting Processor.");
    nRST = 1;
    // wait for halt
    while (!syif.halt)
    begin
      @(posedge CLK);
      cycles++;
    end
    $display("Halted at %g time and ran for %d cycles.",$time, cycles);
    nRST = 0;
    dump_memory();
    $finish;
  end

  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    syif.tbCTRL = 1;
    syif.addr = 0;
    syif.WEN = 0;
    syif.REN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      syif.addr = i << 2;
      syif.REN = 1;
      repeat (4) @(posedge CLK);
      if (syif.load === 0)
        continue;
      values = {8'h04,16'(i),8'h00,syif.load};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),syif.load,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      syif.tbCTRL = 0;
      syif.REN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
endprogram
