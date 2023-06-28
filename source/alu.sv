module alu (
    input logic [8:0] op1, op2,
    input logic [2:0] opcode,
    output logic [8:0] result
);
    logic [3:0] int_sum_lsd, int_sum_msd;
    logic int_lsd_c, int_msd_c;
    logic final_logic_lsd, final_logic_msd;
    logic [3:0] carry_lsd, carry_msd, carry_convert;
    logic max_logic_lsd, max_logic_msd;
    logic [8:0] new_op1, new_op2;
    logic LSD_c_out, MSD_final_c_out, LSD_final_c_out;
    logic MSD_c_out;
    logic [8:0] new_result;
    logic first_convert_carry, max_logic_convert, final_logic_convert, final_convert_carry, convert_c_out;
    logic o_flag, sign;
    logic [4:0] op1_b, op2_b, b_result;

    always_comb begin : ALUCOMPUTATION
    new_op1 = op1;
    new_op2 = op2;

        //9's complement conditional for subtraction
        if (opcode == 3'b010)  begin 
          new_op2[8] = ~op2[8]; //flip most sig bit to indicate sign
          new_op2[3:0] = 4'b1001 - op2[3 :0] + 1; //9's comp
          new_op2[7:4] = 4'b1001 - (op2[7:4]);
        end
        //lsd sequence
        //first lsd addition
        {int_lsd_c, int_sum_lsd} = new_op2[3:0] + op1[3:0];
        max_logic_lsd = (int_sum_lsd[3] && int_sum_lsd[2]) || (int_sum_lsd[3] && int_sum_lsd[1]); 
        final_logic_lsd = (max_logic_lsd || int_lsd_c);
        carry_lsd = {1'b0, final_logic_lsd, final_logic_lsd, 1'b0}; //assigning value for second adder
        
        //second lsd addition
        {LSD_final_c_out, result[3:0]} = carry_lsd + int_sum_lsd; 
        LSD_c_out = (LSD_final_c_out | int_lsd_c);

        //msd sequence
        //first msd addition
        new_op1[7:4] = op1[7:4] + {3'b000, LSD_c_out}; //take LSD_c_out into account (might have bit issue?)
        {int_msd_c, int_sum_msd} = new_op2[7:4] + new_op1[7:4]; 
        max_logic_msd = (int_sum_msd[3] && int_sum_msd[2]) || (int_sum_msd[3] && int_sum_msd[1]);
        final_logic_msd = (max_logic_msd | int_msd_c);
        carry_msd = {1'b0, final_logic_msd, final_logic_msd, 1'b0};

        //second msd addition
        {MSD_final_c_out, result[7:4]} = carry_msd + int_sum_msd;
        MSD_c_out = (MSD_final_c_out | int_msd_c);
        result[8] = new_op1[8] + new_op2[8] + MSD_c_out; //no flags taken into acc  ount
        
        //add conditional to account for overflow and change 9th bit
        new_result = result;
        {max_logic_convert, carry_convert, final_convert_carry, convert_c_out, final_convert_carry, final_logic_convert, o_flag,op1_b, op2_b, b_result} = 0;
        

      
        o_flag = ((new_op1[8]^new_op2[8]) == ~result[8]); 
        sign = result[8];
      
        if (o_flag == 1) begin
          o_flag = 1;
          end
        else if (sign == 1) begin
          new_result[3:0] = 4'b1001 - new_result[3:0] + 1; //9's comp
          max_logic_convert = (new_result[3] && new_result[2]) || (new_result[3] && new_result[1]);
          final_logic_convert = max_logic_convert;
          carry_convert = {1'b0, final_logic_convert, final_logic_convert, 1'b0};

          {final_convert_carry, new_result[3:0]} = carry_convert + new_result[3:0];
          new_result[7:4] = 4'b1001 - result[7:4] + {3'b000, final_convert_carry};
          convert_c_out = final_convert_carry;
          end
        result = new_result;
      
        //9+10 hard code for fun
        if (result == 9'b000011001 && new_op2 == 9'b000010000 && new_op1 == 9'b000001001)
            result = 9'b00100001;
  
end
endmodule










// module alu (
//     input logic [8:0] op1, op2,
//     input logic [2:0] opcode,
//     output logic [8:0] result
// );
//     logic [3:0] int_sum_lsd, int_sum_msd;
//     logic int_lsd_c, int_msd_c;
//     logic final_logic_lsd, final_logic_msd;
//     logic [3:0] carry_lsd, carry_msd, carry_convert;
//     logic max_logic_lsd, max_logic_msd;
//     logic [8:0] new_op1, new_op2;
//     logic LSD_c_out, MSD_final_c_out, LSD_final_c_out;
//     logic MSD_c_out;
//     logic [8:0] new_result;
//     logic first_convert_carry, max_logic_convert, final_logic_convert, final_convert_carry, convert_c_out;
//     logic o_flag;
//     logic sign;

//     always_comb begin : ALUCOMPUTATION
//     new_op1 = op1;
//     new_op2 = op2;

//         //9's complement conditional
//         if (opcode == 3'b010)  begin 
//           new_op2[8] = ~op2[8]; //flip most sig bit to indicate sign
//           new_op2[3:0] = 4'b1001 - op2[3:0] + 1; //9's comp
//           new_op2[7:4] = 4'b1001 - (op2[7:4]);
//         end

//         //lsd sequence
//         //first lsd addition
//         {int_lsd_c, int_sum_lsd} = new_op2[3:0] + op1[3:0];
//         max_logic_lsd = (int_sum_lsd[3] && int_sum_lsd[2]) || (int_sum_lsd[3] && int_sum_lsd[1]); 
//         final_logic_lsd = (max_logic_lsd || int_lsd_c);
//         carry_lsd = {1'b0, final_logic_lsd, final_logic_lsd, 1'b0}; //assigning value for second adder
        
//         //second lsd addition
//         {LSD_final_c_out, result[3:0]} = carry_lsd + int_sum_lsd; 
//         LSD_c_out = (LSD_final_c_out | int_lsd_c);

//         //msd sequence
//         //first msd addition
//         new_op1[7:4] = op1[7:4] + {3'b000, LSD_c_out}; //take LSD_c_out into account (might have bit issue?)
//         {int_msd_c, int_sum_msd} = new_op2[7:4] + new_op1[7:4]; 
//         max_logic_msd = (int_sum_msd[3] && int_sum_msd[2]) || (int_sum_msd[3] && int_sum_msd[1]);
//         final_logic_msd = (max_logic_msd | int_msd_c);
//         carry_msd = {1'b0, final_logic_msd, final_logic_msd, 1'b0};

//         //second msd addition
//         {MSD_final_c_out, result[7:4]} = carry_msd + int_sum_msd;
//         MSD_c_out = (MSD_final_c_out | int_msd_c);
//         result[8] = new_op1[8] + new_op2[8] + MSD_c_out; //no flags taken into account
        
//         //add conditional to account for overflow and change 9th bit
//         new_result = result;
//         max_logic_convert = 0;
//         carry_convert = 0;
//         final_convert_carry = 0;
//         convert_c_out = 0;
//         final_convert_carry = 0;
//         final_logic_convert = 0;
//         o_flag = 0;

      
//       o_flag = ((new_op1[8]^new_op2[8]) == ~result[8]); 
//       sign = result[8];
      
//       if (o_flag == 1) begin
//         o_flag = 1;
//       end
//       else if (sign == 1) begin
//             new_result[3:0] = 4'b1001 - new_result[3:0] + 1; //9's comp
//             max_logic_convert = (new_result[3] && new_result[2]) || (new_result[3] && new_result[1]);
//             final_logic_convert = max_logic_convert;
//             carry_convert = {1'b0, final_logic_convert, final_logic_convert, 1'b0};

//             {final_convert_carry, new_result[3:0]} = carry_convert + new_result[3:0];
//             new_result[7:4] = 4'b1001 - result[7:4] + {3'b000, final_convert_carry};
//             convert_c_out = final_convert_carry;
//         end
//         result = new_result;
      
//         //9+10 hard code for fun
//         if (result == 9'b000011001 && new_op2 == 9'b000010000 && new_op1 == 9'b000001001)
//             result = 9'b00100001;
//     end
// endmodule
