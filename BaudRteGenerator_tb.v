module BaudRateGenerator_tb;
    reg clk;
    wire rxClk;
    wire txClk;

    BaudRateGenerator dut (
        .clk(clk),
        .rxClk(rxClk),
        .txClk(txClk)
    );

    initial begin
        $dumpfile("dump.vcd"); // Specify the VCD file for waveform dumping
        $dumpvars(0, BaudRateGenerator_tb); // Dump all variables in the module
        clk = 0;
        #0.25; // Wait for 0.25 microseconds for half of the clock period
        repeat (20) begin // Simulate for 20 clock cycles
            #0.5; // Toggle clock every 0.5 microseconds for one full clock period
            clk = ~clk;
        end
        $finish; // End the simulation
    end

    always @(posedge rxClk) begin
        $display("RX Clock: %d", rxClk);
    end

    always @(posedge txClk) begin
        $display("TX Clock: %d", txClk);
    end

endmodule
