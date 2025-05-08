-- GESTIÓN DE EXCEPCIONES
-- Capturar una excepción del sistema

DECLARE
    v_numero1 number := &numero1;
    v_numero2 number := &numero2;
    v_division number;
BEGIN
    v_division := v_numero1/v_numero2;
    dbms_output.put_line('La división es ' || v_division);
EXCEPTION
    when zero_divide THEN
    dbms_output.put_line('Error al dividir entre 0');    
end;
undefine numero1;
undefine numero2;

-- Cuando los empleados tengan una comisión con valor 0, lanzaremos una excepción
-- Tendremos una tabla donde almacenaremos los empleados con comisión mayor a 0

create table emp_comision (apellido varchar2(50), comision number(9));

declare
    cursor cursor_emp IS
    select apellido, comision from emp order by comision desc;
    exception_comision exception;
BEGIN
    for v_record in cursor_emp
    LOOP
        insert into emp_comision values (v_record.apellido, v_record.comision);
        if (v_record.comision = 0) THEN
            raise exception_comision;
        end if;
    end loop;    
EXCEPTION
    when exception_comision THEN
    dbms_output.put_line('Comisiones a 0');
end;

select * from emp_comision;

-- PRAGMA EXCEPTIONS

DECLARE
    exception_nulos exception;
    pragma exception_init(exception_nulos, -1400);
BEGIN
    insert into dept values (null, 'DEPARTAMENTO', 'PRAGMA');
exception
    when exception_nulos THEN
    dbms_output.put_line('No me sirven los nulos');
end;

DECLARE
    v_id number;
BEGIN
    select dept_no into v_id from dept where dnombre = 'VENTAS';
    dbms_output.put_line('Ventas es el número ' || v_id);
EXCEPTION
    when too_many_rows THEN
        dbms_output.put_line('Demasiadas filas en cursor');
    when others THEN
        dbms_output.put_line(to_char(SQLCODE) || ' ' || SQLERRM);    
end;






