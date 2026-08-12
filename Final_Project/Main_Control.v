module Main_Control(
  input wire [5:0] instruction,
  
  output reg       RegDst,
  output reg       Branch,
  output reg       MemRead,
  output reg       MemtoReg,
  output reg [1:0] ALUOP,
  output reg       MemWrite,
  output reg       ALUSrc,
  output reg       RegWrite,
  output reg       jump
  

);
 
 
 always@(*)
    begin
      RegDst=1'b0;
      Branch=1'b0;
      MemRead=1'b0;
      MemtoReg=1'b0;
      ALUOP=2'b0;
      MemWrite=1'b0;
      ALUSrc=1'b0;
      RegWrite=1'b0;
      jump=1'b0;
      case(instruction)
         
          6'b000000 :  begin                    //R-type
                   RegDst=1'b1;
                   ALUOP=2'b10;
                   RegWrite=1'b1;   
                 end  
                 
          6'b000100 :  begin               //Branching
                   Branch=1'b1;
                   ALUOP=2'b01; 
                 end 
                 
           6'b000010 :  begin               //jumping
                   jump=1'b1;   
                 end   
           
           6'b100011 :  begin               //lw
                   MemRead=1'b1;
                   MemtoReg=1'b1;
                   ALUOP=2'b00;
                   ALUSrc=1'b1;
                   RegWrite=1'b1;  
                 end        
             
          6'b101011 :  begin               //sw
                   RegDst=1'b0;
                   Branch=1'b0;
                   MemRead=1'b0;
                   MemtoReg=1'b0;
                   ALUOP=2'b00;
                   MemWrite=1'b1;
                   ALUSrc=1'b1;
                   RegWrite=1'b0;  
                   jump=1'b0; 
                 end
                 
         default :    begin               
                   RegDst=1'b0;
                   Branch=1'b0;
                   MemRead=1'b0;
                   MemtoReg=1'b0;
                   ALUOP=2'b0;
                   MemWrite=1'b0;
                   ALUSrc=1'b0;
                   RegWrite=1'b0; 
                   jump=1'b0;  
                 end
                 
         
                                   
      endcase
        
    end 
  
  
endmodule
