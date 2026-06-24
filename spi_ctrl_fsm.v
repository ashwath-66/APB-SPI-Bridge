module spi_ctrl_fsm (
    input clk,
    input rst_n,
    input [7:0] tx_data,
    input write_en,
    output reg [7:0] rx_data,
    output reg rx_valid,
    output reg spi_sclk,
    output reg spi_mosi,
    input spi_miso,
    output reg spi_ss_n
);
    reg [3:0] count;
    reg [7:0] shift_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            spi_sclk <= 0; spi_ss_n <= 1; count <= 0; rx_valid <= 0;
        end else if (write_en) begin
            shift_reg <= tx_data; spi_ss_n <= 0; count <= 8;
        end else if (count > 0) begin
            spi_sclk <= ~spi_sclk;
            if (spi_sclk) begin
                spi_mosi <= shift_reg[7];
                shift_reg <= {shift_reg[6:0], spi_miso};
                count <= count - 1;
            end
            if (count == 1 && spi_sclk) begin
                rx_data <= {shift_reg[6:0], spi_miso};
                rx_valid <= 1;
                spi_ss_n <= 1;
            end
        end else begin
            rx_valid <= 0; spi_sclk <= 0;
        end
    end
endmodule