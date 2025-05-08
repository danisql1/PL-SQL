DECLARE
    v_texto varchar2(50);
    v_longitud int;
    v_numero char(1);
    conv_numero int;
    v_suma int;
begin
    v_texto := '&texto';
    v_suma := 0;
    v_longitud := length(v_texto);
    for i in 1..v_longitud loop
        v_numero := substr(v_texto,i,1);
        conv_numero := to_number(v_numero);
        v_suma := v_suma+conv_numero;
    end loop;
    dbms_output.put_line(v_suma);
    dbms_output.put_line('Fin del programa');
end;

undefine texto;

