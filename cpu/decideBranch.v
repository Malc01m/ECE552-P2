module decideBranch(flags, condition, branchTaken);
  input [2:0] flags, condition;
  output wire branchTaken;
  
  // Nflag, Vflag, Zflag
  wire Nflag, Vflag, Zflag, cond0, cond1, cond2, cond3, cond4, cond5, cond6, cond7;
  
  assign Zflag = flags[0];
  assign Vflag = flags[1];
  assign Nflag = flags[2];


  assign cond0 = (Zflag == 0) ? 1 : 0;
  assign cond1 = (Zflag == 1) ? 1 : 0;
  assign cond2 = (Zflag == 0 & Nflag == 0) ? 1 : 0;
  assign cond3 = (Nflag == 1) ? 1 : 0;
  assign cond4 = (Zflag == 1 | (Zflag == 0 & Nflag == 0)) ? 1 : 0;
  assign cond5 = (Nflag == 1 | Zflag == 1) ? 1 : 0;
  assign cond6 = (Vflag == 1) ? 1 : 0;
  assign cond7 = 1;

  assign branchTaken =  (condition == 3'b000) ? cond0 :
                        (condition == 3'b001) ? cond1 :
                        (condition == 3'b010) ? cond2 :
                        (condition == 3'b011) ? cond3 :
                        (condition == 3'b100) ? cond4 :
                        (condition == 3'b101) ? cond5 :
                        (condition == 3'b110) ? cond6 :
                        (condition == 3'b111) ? cond7 : 0;

endmodule