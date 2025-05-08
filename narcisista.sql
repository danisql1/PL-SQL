----------------------------------- NÚMERO NARCISISTA ------------------------------------

declare
    v_texto number;
    v_num1 number;
    v_num2 number;
    v_num3 number;
    v_pot1 number;
    v_pot2 number;
    v_pot3 number;
    v_suma number;
begin
    v_texto := &texto;
    select substr(v_texto, 1,1) into v_num1 from dual;
    select substr(v_texto, 2,1) into v_num2 from dual;
    select substr(v_texto, 3,1) into v_num3 from dual; 
    v_pot1 := v_num1*v_num1*v_num1;
    v_pot2 := v_num2*v_num2*v_num2;
    v_pot3 := v_num3*v_num3*v_num3;
    v_suma := v_pot1+v_pot2+v_pot3;
    if v_texto = v_suma THEN
        dbms_output.put_line(v_texto || ' es NARCISISTA');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_texto || ' no es narcisista');
    end if;
end;

undefine texto;