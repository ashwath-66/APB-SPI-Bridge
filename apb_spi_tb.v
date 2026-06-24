`timescale 1ns / 1ps
module apb_spi_tb;
    reg clk, rst_n, psel, penable, pwrite;
    reg [31:0] paddr, pwdata;
    wire [31:0] prdata;
    wire pready, spi_sclk, spi_mosi, spi_ss_n, spi_miso;
    reg [7:0] slave_reg;
    apb_spi_core dut (clk, rst_n, paddr, psel, penable, pwrite, pwdata, prdata, pready, spi_sclk, spi_mosi, spi_miso, spi_ss_n);
    always #10 clk = ~clk;
    assign spi_miso = (!spi_ss_n) ? slave_reg[7] : 1'bz;
    always @(negedge spi_sclk or posedge spi_ss_n) begin
        if (spi_ss_n) slave_reg <= 8'hA5;
        else slave_reg <= {slave_reg[6:0], spi_mosi};
    end
    initial begin
        clk=0; rst_n=0; paddr=0; psel=0; penable=0; pwrite=0; pwdata=0;
        #50 rst_n=1;
        #20 paddr=32'h4; pwdata=32'h5A; pwrite=1; psel=1; #20 penable=1; #20 psel=0; penable=0;
        #500 paddr=32'h8; pwrite=0; psel=1; #20 penable=1; #20 psel=0; penable=0;
        #100 $finish;
    end
endmodule