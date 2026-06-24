module apb_spi_core (
    input clk, 
    input rst_n, 
    input [31:0] paddr, 
    input psel, 
    input penable,
    input pwrite, 
    input [31:0] pwdata, 
    output [31:0] prdata, 
    output pready,
    output spi_sclk, 
    output spi_mosi, 
    input spi_miso, 
    output spi_ss_n
);
    wire [7:0] tx_data, rx_data;
    wire write_en, rx_valid;
    apb_interface u_apb (
        .clk(clk), 
        .rst_n(rst_n), 
        .paddr(paddr), 
        .psel(psel), 
        .penable(penable),
        .pwrite(pwrite), 
        .pwdata(pwdata), 
        .prdata(prdata), 
        .pready(pready),
        .tx_data(tx_data), 
        .write_en(write_en), 
        .rx_data(rx_data), 
        .rx_valid(rx_valid)
    );
    spi_ctrl_fsm u_spi (
        .clk(clk), 
        .rst_n(rst_n), 
        .tx_data(tx_data), 
        .write_en(write_en),
        .rx_data(rx_data), 
        .rx_valid(rx_valid), 
        .spi_sclk(spi_sclk),
        .spi_mosi(spi_mosi), 
        .spi_miso(spi_miso), 
        .spi_ss_n(spi_ss_n)
    );
endmodule