`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2023 23:29:02
// Design Name: 
// Module Name: AXI_SLAVE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AXI_SLAVE(
input  clk,
input  reset_n,
input [2:0]wa_addr,
input wa_valid,
input [3:0] wd_data,
input wd_valid,
input wd_strb,
input b_ready,
input [2:0]ra_addr,
input ra_valid,
input rd_ready,
input rd_response,

output logic wd_ready,
output logic wa_ready,
output logic b_response,
output logic b_valid,
output logic ra_ready,
output logic rd_data,
output logic rd_valid
);
reg [3:0] memory[7:0]; 
logic [3:0] temp;
 always_ff @(posedge clk, negedge reset_n)
 begin:write_addr
 if(!reset_n)
 wa_ready <= 'b0;
 else
 begin
 if(wa_valid)
 wa_ready <= 'b1;
 end
 end:write_addr
 
 always_ff @(posedge clk, negedge reset_n)
 begin:write_data
 if(!reset_n)
 begin
 wd_ready <= 'b0;
 memory[wa_addr] <= 'b0;
 end
 else
 begin
 if(wd_valid && wd_strb)
 wd_ready <= 'b1;
 memory[wa_addr] <= wd_data;
 end
 end:write_data
 
 always_ff @(posedge clk, negedge reset_n)
 begin:buff_response
 if(!reset_n)
 begin
 b_valid <= 'b0;
 b_response <= 'b0;
 end
 else
 begin
 if(memory[wa_addr] != 'b0)
 begin
 b_response <= 'b1;
 b_valid <= 'b1;
 end
 else if(b_valid && b_ready)
 begin
 b_valid <= 'b0;
 b_response <= 'b0;
 end
 end
 end:buff_response
 
 always_ff @(posedge clk, negedge reset_n)
 begin:read_addr
 if(!reset_n)
 ra_ready <= 'b0;
 else
 begin
 if(ra_valid)
 ra_ready <= 'b1;
 end
 end:read_addr
 
 always_ff @(posedge clk, negedge reset_n)
 begin:read_data
 if(!reset_n)
 begin
 rd_valid <= 'b0;
 rd_data <= 'b0;
 end
 else
 begin
 if(rd_ready)
 begin
 rd_valid <= 'b0;
 rd_data <= 'bz;
 end
 else
 begin
 if(!rd_response)
 rd_valid <= 'b1;
 rd_data <= memory[ra_addr];
 end
 end
 end:read_data
 
endmodule
