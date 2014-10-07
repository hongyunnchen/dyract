module filter_x(
input            i_clk,
input [7:0]      i_pixel_1,
input [7:0]      i_pixel_2,
input [7:0]      i_pixel_3,
input            i_pixel_valid,
output           o_pixel_ack,
output reg       o_pixel_valid,
input            i_pixel_ack,
output  [7:0]    o_pixel
);


reg [23:0] line1;
reg [23:0] line2;
reg [23:0] line3;
reg        pix_val_int;
reg        pix_val_int_p;
reg        pix_val_int_1;
reg [9:0] line1_filt;
reg [9:0] line2_filt;
reg [9:0] line3_filt;
reg [11:0]int_pixel_1;
reg [7:0] int_pixel;

assign o_pixel_ack = i_pixel_ack;

assign o_pixel = int_pixel;

initial
begin
    line1    <=  0;
    line2    <=  0;
    line3    <=  0;
end

always @(posedge i_clk)
begin
    if(i_pixel_valid)
	 begin
	   line1  <=  {i_pixel_1,i_pixel_2,i_pixel_3};
		line2  <=  line1;
		line3  <=  line2;
	 end
end

always @(posedge i_clk)
begin
   line1_filt   <=  line1[7:0] + line1[15:8] + line1[23:16];
   line2_filt   <=  line2[7:0] + line2[15:8] + line2[23:16];
   line3_filt   <=  line3[7:0] + line3[15:8] + line3[23:16];
end

always @(posedge i_clk)
begin
    int_pixel_1  <=  (line1_filt + line2_filt + line3_filt);
    int_pixel    <=  int_pixel_1/9;
end

always @(posedge i_clk)
begin
   pix_val_int    <=   i_pixel_valid & o_pixel_ack; //valid data transfer
	pix_val_int_p  <=   pix_val_int;
   pix_val_int_1  <=   pix_val_int_p;
end

always @(posedge i_clk)
begin
    if(pix_val_int_1)
	     o_pixel_valid   <=    1'b1;
	  else if(o_pixel_valid & i_pixel_ack)
        o_pixel_valid   <=    1'b0;
end		  

endmodule