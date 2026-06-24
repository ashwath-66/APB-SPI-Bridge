module apb_interface (
    input clk,
    input rst_n,
    input [31:0] paddr,
    input psel,
    input penable,
    input pwrite,
    input [31:0] pwdata,
    output reg [31:0] prdata,
    output reg pready,
    output reg [7:0] tx_data,
    output reg write_en,
    input [7:0] rx_data,
    input rx_valid
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prdata <= 0;
            pready <= 1;
            write_en <= 0;
            tx_data <= 0;
        end else begin
            write_en <= 0;
            if (psel && penable) begin
                if (pwrite) begin
                    if (paddr == 32'h4) begin
                        tx_data <= pwdata[7:0];
                        write_en <= 1;
                    end
                end else begin
                    if (paddr == 32'h8) prdata <= {24'b0, rx_data};
                end
            end
        end
    end
endmodule