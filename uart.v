module tb_uart;
  reg clk;
  reg rst;
  wire [7:0] data_in;
  wire tx;
  wire tx_busy;
  wire rx;
  wire s_tick;
  wire [7:0] dout;
  wire rx_done;

  // Instantiate UART Transmitter
  transmitter u_transmitter (
    .data_in(data_in),
    .rst(rst),
    .clk(clk),
    .tx(tx),
    .tx_busy(tx_busy)
  );

  // Instantiate Baud Rate Generator for Transmitter
  BaudRateGenerator #(
    .CLOCK_RATE(100000000), // Example clock rate
    .BAUD_RATE(9600)       // Example baud rate
  ) baud_gen_tx (
    .clk(clk),
    .rxClk(s_tick),
    .txClk(tx)
  );

  // Instantiate UART Receiver
  uart_rx u_receiver (
    .rx(rx),
    .s_tick(s_tick),
    .dout(dout),
    .rx_done(rx_done),
    .reset(rst)
  );

  // Instantiate Baud Rate Generator for Receiver
  BaudRateGenerator #(
    .CLOCK_RATE(100000000), // Example clock rate
    .BAUD_RATE(9600)       // Example baud rate
  ) baud_gen_rx (
    .clk(clk),
    .rxClk(s_tick),
    .txClk(tx)
  );

  // Testbench behavior
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    data_in = 8'h55; // Example data to transmit

    // Reset and release reset
    #10 rst = 0;
    #10 rst = 1;

    // Send data to transmitter
    data_in = 8'hAA; // Change data to another value
    #100; // Wait for some time

    // Check received data
    if (rx_done) begin
      $display("Received Data: %h", dout);
    end else begin
      $display("Data reception not complete.");
    end

    // Finish simulation
    $finish;
  end

  // Clock generation (1 ns period)
  always begin
    #0.5 clk = ~clk;
  end

endmodule

// Simulation
initial begin
  $dumpfile("uart_tb.vcd");
  $dumpvars(0, tb_uart);
  $display("Starting UART Testbench");
  $monitor("Time: %t, Data In: %h, TX: %b, TX Busy: %b, RX: %b, RX Done: %b, Received Data: %h", $time, data_in, tx, tx_busy, rx, rx_done, dout);
  $stop;
end