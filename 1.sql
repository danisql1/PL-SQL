DECLARE
    v_salario doctor.SALARIO%TYPE;
    v_suma doctor.SALARIO%TYPE;
    cursor cursordoctor IS
    select salario from doctor; 
BEGIN
    select count(salario) into v_salario from doctor where hospital_cod = (select hospital_cod from HOSPITAL
    where nombre = 'la paz');
    select sum(salario) into v_suma from doctor where hospital_cod =
     (select hospital_cod from hospital where nombre = 'la paz');
    open cursordoctor;
    LOOP
        FETCH cursordoctor into v_salario, v_suma;
        if v_suma > 1000000 THEN
            v_salario := v_suma - 10000; 
        else 
            v_salario := v_suma + 10000;
        end if;     
        exit when cursordoctor%notfound;
        end loop;
    update doctor set salario = v_salario where hospital_cod =
     (select hospital_cod from hospital where nombre = 'la paz'); 
    dbms_output.put_line('Se han modificado ' || v_cuantos || ' empleados');
    close cursordoctor;  
end;