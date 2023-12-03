`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ABHAY MANOJ TIwARI
// 
// Create Date: 26.11.2023 23:08:17
// Design Name: AXI_PROTOCOL
// Module Name: AXI_MASTER
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


module AXI_MASTER(
//input signals
input clk,
input  reset_n,
input wr_en,
input rd_en,
input b_valid,
input b_response,
input wa_ready,
input wd_ready,
input [2:0]addr_in,
input ra_ready,
input rd_valid,
input [3:0] rdata_in,
input [3:0] wdata_in,

//output signals
output  wa_valid,
output  [2:0] wa_addr,
output  [3:0] wd_data,
output  wd_valid,
output  wd_strb,
output  b_ready,
output  b_error,
output  ra_valid,
output  [2:0] ra_addr,
output rd_ready,
output rd_response,
output [3:0]rd_data
 );
 
 logic axi_wa_valid;
 logic [2:0]axi_wa_addr;
 logic [3:0] axi_wd_data;
 logic axi_wd_valid;
 logic axi_wd_strb;
 logic axi_b_ready;
 logic axi_b_error;
 logic axi_ra_valid;
 logic [2:0]axi_ra_addr;
 logic axi_rd_ready;
 logic axi_rd_response;
 logic [3:0] axi_rd_data;
 
 assign wa_valid = axi_wa_valid;
 assign wa_addr = axi_wa_addr;
 assign wd_data = axi_wd_data;
 assign wd_valid = axi_wd_valid;
 assign wd_strb = axi_wd_strb;
 assign b_ready = axi_b_ready;
 assign b_error = axi_b_error;
 assign ra_valid = axi_ra_valid;
 assign ra_addr = axi_ra_addr;
 assign rd_ready = axi_rd_ready;
 assign rd_response = axi_rd_response;
 assign rd_data = axi_rd_data;
 
 
 //Write Address Channel
 always_ff @(posedge clk,negedge reset_n)
 begin:Write_Address_Channel
 if(!reset_n)
 begin
 axi_wa_addr <= 'b0;
 axi_wa_valid <= 'b0;
 end
 else
 begin
 if(wr_en)
 begin
 axi_wa_addr <= addr_in;
 axi_wa_valid <= 1'b1;
 end 
 else if(axi_wa_valid && wa_ready)
 begin
 axi_wa_valid <= 1'b0;
 axi_wa_addr <= addr_in;
 end
 else
 axi_wa_valid <= 1'b0;
 end
 end:Write_Address_Channel
 //Write Address Channel
 
 //Write Data Channel
  always_ff @(posedge clk,negedge reset_n)
 begin:Write_Data_Channel
 if(!reset_n)
 begin
 axi_wd_data <= 'b0;
 axi_wd_valid <= 'b0;
 axi_wd_strb <= 'b0;
 end
 else
 begin
 if(wr_en)
 begin
 axi_wd_data <= wdata_in;
 axi_wd_valid <= 1'b1;
 axi_wd_strb <= 1'b1;
 end 
 if(axi_wd_valid && wd_ready)
 axi_wd_valid <= 1'b0;
 axi_wd_strb <= 1'b0;
 end
 end:Write_Data_Channel
  //Write Data Channel
 
 //Write Response Channel
  always_ff @(posedge clk)
 begin:Write_Response_Channel
 if(!reset_n)
 begin
 axi_b_ready <= 'b0;
 axi_b_error<= 'b0;
 end
 else
 axi_b_ready <= 'b1;
 begin
 if(b_valid && axi_b_ready)
 begin
 if(b_response)
 axi_b_error <= 'b1;
 else
 axi_b_error <= 'b0;
 end
 end
 end:Write_Response_Channel
 //Write Response Channel
  
  //Read Address Channel
  always_ff @(posedge clk,negedge reset_n)
 begin:Read_Address_Channel
 if(!reset_n)
 begin
 axi_ra_addr <= 'b0;
 axi_ra_valid <= 'b0;
 end
 else
 begin
 if(rd_en)
 begin
 axi_ra_addr <= addr_in;
 axi_ra_valid <= 1'b1;
 end 
 else if(axi_ra_valid && ra_ready)
 begin
 axi_ra_valid <= 1'b0;
 axi_ra_addr <= addr_in;
 end
 else
 axi_ra_valid <= 1'b0;
 end
 end:Read_Address_Channel
  //Read Address Channel
 
 //Read Data Channel
 always_ff @(posedge clk,negedge reset_n)
 begin:Read_Data_Channel
 if(!reset_n)
 begin
 axi_rd_data <= 'b0;
 axi_rd_ready <= 'b0;
 axi_rd_response <= 'b0;
 end
 else
 begin
 if(rd_en)
 begin
 axi_rd_ready <= 'b1;
 axi_rd_data <= rdata_in;
 if(rd_valid && axi_rd_ready)
 axi_rd_response <='b1;
 else 
 axi_rd_response <= 'b0;
 end
 else
 begin
 axi_rd_ready <='b0;
 axi_rd_data <= axi_rd_data;
 end
 end
 end:Read_Data_Channel
 //Read Data Channel
endmodule
