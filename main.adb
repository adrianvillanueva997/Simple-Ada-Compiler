procedure Main is

   
   variable_char : Character;
   variable_int1 : Integer;
   variable_int2 : Integer;
   
begin
   
   begin
      variable_int1 := 1;
   end;
   begin
      variable_int2 := 2;
   end;

   if variable_int1 = variable_int2 then
      begin
         variable_char := 'a';
      end;
   else
      begin
         variable_char := 'b';
      end;
        
   end if;
   begin
      variable_int1 := 0;
      for I in 1..10 loop
         variable_int2 := variable_int1 + 1;
      end loop;
   end;
      --  Insert code here.
end Main;
