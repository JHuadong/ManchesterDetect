`timescale 1 ns/1 ns
module t;
  reg CLK;
  reg Sign;
  reg rst;
  wire Dect;

initial 
  begin
   Sign=0;
   CLK=0;
   rst=1;
   #22 rst=0;
   #133 rst=1;
  end

always #50 CLK=~CLK;

always @ (posedge CLK)
   begin
      Sign=1;
     #2000 Sign=0;
     #1620 Sign=1;
     #1580 Sign=0;
     #390 Sign=1;
     #1000 Sign=0;
     #500 Sign=1;
     #500 Sign=0;
     #1570 Sign=1;
     #1300 Sign=0;
     #1500 Sign=1;
     #1500 Sign=0;
     #1570  Sign=1;
     #1520  Sign=0;
     #490   Sign=1;
     #1000;

     
   end


edge_detect Mt(.clk(CLK),.rst_n(rst),.data_in(Sign),.Dec_Swith(Dect));

endmodule
