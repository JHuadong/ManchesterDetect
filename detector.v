module edge_detect(input clk, 
                   input data_in, 
                   input rst_n,
                   output Dec_Swith,
                   output first );

parameter Start=3'b000;
parameter Fall=3'b001;
parameter Raise=3'b010;
parameter Judge=3'b011;
parameter Detect=3'b100;
parameter limit=14;
          

reg data_in_d1;
reg data_in_d2;
reg raising;
reg falling;
reg same;
reg [2:0] state;
reg [4:0] number;
reg Dec;
reg first_Sign;
assign Dec_Swith=Dec;
assign first=first_Sign;

initial
  begin
   data_in_d1=0;
   data_in_d2=0;
   raising=0;
   falling=0;
   number=5'b00000;
   state=3'b000;
   same=0;
   Dec=0;
   first_Sign=0;
  end



always @ (posedge clk or negedge rst_n)
          if(!rst_n)
             begin data_in_d1 = 1'b0; 
                   data_in_d2 = 1'b0;
                   state=Start;
                 end 
          else
        begin 
            data_in_d2 = data_in_d1;
            data_in_d1 = data_in;        
            raising=data_in_d1&(~data_in_d2);
            falling=(~data_in_d1)&data_in_d2;
            same=~(data_in_d1^data_in_d2);
            
            if(same) number=number+1;  
               

            case(state)
              Start:if(same) state=Start;
                    else if(falling)  begin
                                   state=Fall;
                                   number=0;
                                 end
                    else if(raising) begin
                                      if(number>=limit) begin
                                                       state=Raise;
                                                       number=0;
                                                     end
                                      else begin 
                                             state=Start;
                                             number=0;
                                      end
                                      end
                                          
              Fall: if(same) state=Fall;
                    else if(raising) begin
                                   if(number<limit) begin
                                                     state=Start;
                                                     number=0;
                                                 end
                                   else begin
                                           state=Raise;
                                           number=0;
                                   end
                                 end

              Raise:if(same) state=Raise; 
                    else if(falling) begin                             
                                  if(number==(limit+5))
                                              begin
                                                state= Detect;
                                                number=0;
                                                first_Sign=1;
                                                Dec=1;
                                              end

                                  else if(number==limit) 
                                              begin
                                                state=Judge;
                                                number=0;
                                              end
                                  else  begin
                                            state=Start;
                                            number=0;
                                        end
                                  end

              Judge: if(same) state=Judge;
                     else if(raising) begin
                                 if(number==(limit-10))
                                         begin
                                           state=Detect;
                                           number=0;
                                           first_Sign=0;
                                           Dec=1;
                                         end
                                  else if(number>=limit)
                                         begin
                                           state=Raise;
                                           number=0;
                                         end
                                  else begin
                                          state=Start;
                                          number=0;
                                       end
                                 end

               Detect: 
                       if(!rst_n) begin
                                    state=Start;
                                    number=0;
                                    Dec=0;
                                  end
                       else  begin 
                                state=Detect;
                                number=number+1;
                                    
                             end
                             
        endcase
   end
                                          
                                                                  
endmodule   
