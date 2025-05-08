-- PROCEDIMIENTOS ALMACENADOS

-- Ejemplo procedimiento para mostrar un mensaje
-- STORED PROCEDURE
create or replace procedure sp_mensaje 
is -- también admite AS
BEGIN
    -- Mostramos un mensaje
    dbms_output.put_line('Hola');
end;
-- Llamada al procedimiento
BEGIN
    sp_mensaje;
end;

exec sp_mensaje;
-- En consola, SET SERVEROUTPUT ON; primero

-- Creamos el procedimiento
create or replace procedure sp_ejemplo_plsql
as
BEGIN
    DECLARE
        v_numero number;
    BEGIN
        v_numero := 14;
        if v_numero > 0 THEN
            dbms_output.put_line('Positivo');
        ELSE    
            dbms_output.put_line('Negativo');
        end if;
    end;
end;
-- LLAMADA
BEGIN
    sp_ejemplo_plsql;
end;
------------------------------------
-- Tenemos otra sintaxis para tener variables dentro de un procedimiento
-- No se utiliza la palabra DECLARE
create or replace procedure sp_ejemplo_plsql2
AS
    v_numero number := 14;
BEGIN
    if v_numero > 0 THEN
        dbms_output.put_line('Positivo');
    ELSE    
        dbms_output.put_line('Negativo');
    end if;
end;

BEGIN
    SP_EJEMPLO_PLSQL2;
end;
------------------------------------
-- Procedimiento para sumar dos números
create or replace procedure sp_sumar_numeros
(p_numero1 number, p_numero2 number)
as
    v_suma number;
begin
    v_suma := p_numero1 + p_numero2;
    dbms_output.put_line('La suma de ' || p_numero1 || ' y ' || p_numero2 || ' es ' || v_suma);
end;

BEGIN
    SP_SUMAR_NUMEROS(5, 6);
end;
-------------
-- Necesito un procedimiento para dividir dos números. Se llamará sp_dividir_numeros

create or replace procedure sp_dividir_numeros
(p_numero1 number, p_numero2 NUMBER)
as
BEGIN
    DECLARE
        v_division number;
    begin
    v_division := p_numero1 / p_numero2;
    dbms_output.put_line('La división entre ' || p_numero1 || ' y ' || p_numero2 || ' es ' || v_division);
EXCEPTION
    when zero_divide THEN
        DBMS_OUTPUT.PUT_LINE('División entre 0. PL/SQL inner');    
end; 
EXCEPTION
    when zero_divide THEN
        DBMS_OUTPUT.PUT_LINE('División entre 0 procedure');    
end;    
-- Llamada
BEGIN
    SP_DIVIDIR_NUMEROS(10,0);
EXCEPTION
    when zero_divide THEN
        dbms_output.put_line('División entre 0, PL/SQL outer');
end;
-- El zero_divide del procedure prevalece sobre el de la llamada

-- Procedimiento para insertar un departamento
/*create or replace procedure sp_insertardepartamento
(p_id number, p_nombre varchar2(50), p_localidad varchar2(50))
AS
BEGIN
    insert into dept values (p_id, p_nombre, p_localidad);
end;
-- En este caso el procedimiento se crea, pero con errores. No puede llevar un varchar2(50), debe ser sólo varchar2, o el TYPE, que sería lo ideal.
-- Procedimiento correcto:
create or replace procedure sp_insertardepartamento
(p_id dept.dept_no%TYPE, p_nombre dept.dnombre%TYPE, p_localidad dept.loc%TYPE)
AS
BEGIN
    insert into dept values (p_id, p_nombre, p_localidad);
    -- commit;
end;
-- Llamada al procedimiento
begin
    sp_insertardepartamento(11, '11', '11');
end;*/
rollback; -- Un ROLLBACK sí deshace el procedimiento que hemos hecho.
-- Normalmente, dentro de los procedimientos de acción se incluye COMMIT o ROLLBACK si diera una excepción

-- VERSIÓN 2: Generamos el id con el max automático dentro del procedure

create or replace procedure sp_insertardepartamento
(p_nombre dept.dnombre%TYPE, p_localidad dept.loc%TYPE)
AS
    v_max_id dept.dept_no%type;
BEGIN
    -- Realizamos el cursor implícito para buscar el MAX ID
    select max(dept_no)+1 into v_max_id from dept;
    insert into dept values (v_max_id, p_nombre, p_localidad);
    commit;
EXCEPTION
    when no_data_found THEN
        dbms_output.put_line('No existen datos');
        rollback;
end;
-- Llamada al procedimiento
begin
    sp_insertardepartamento('miercoles','miercoles');
end;
rollback;

-- Realizar un procedimiento para incrementar el salario de los empleados por un oficio.
-- Debemos enviar el oficio y el incremento.

create or replace procedure sp_incremento
(p_oficio emp.oficio%type, p_incremento number)
AS
begin
    update emp set salario = salario+p_incremento where upper(oficio) = upper(p_oficio);
end;
-- Llamada al procedimiento
begin
    sp_incremento('analista', 5);
end;
rollback;

-- Necesito un procedimiento para insertar un doctor.
-- Enviaremos todos los datos del doctor, excepto el ID.
-- Debemos recuperar el MAX ID de doctor dentro del procedimiento

create or replace procedure sp_insertardoctor
(p_hospital_cod doctor.hospital_cod%type, p_apellido doctor.apellido%type, p_especialidad doctor.especialidad%type,
p_salario doctor.salario%type)
AS
    v_max_id doctor.doctor_no%type;
BEGIN
    -- Realizamos el cursor implícito para buscar el MAX ID
    select max(doctor_no)+1 into v_max_id from doctor;
    insert into doctor values (p_hospital_cod, v_max_id, p_apellido, p_especialidad, p_salario);
end;
-- Llamada al procedimiento
begin
    sp_insertardoctor(99, '99', '99', 99);
end;
-- Si hay un COMMIT y después un ROWCOUNT, el ROWCOUNT nunca muestra el número de filas afectadas. Al igual que si hay un ROLLBACK

-- VERSIÓN 2: 
-- Procedimiento para insertar un doctor.
-- Enviaremos todos los datos del doctor, excepto el ID.
-- Debemos recuperar el MAX ID de doctor dentro del procedimiento.
-- Enviamos el nombre del hospital en lugar del ID del hospital.
-- Controlar si no existe el hospital enviado.

create or replace procedure sp_insertardoctor
(p_nombre_hospital hospital.nombre%type, p_apellido doctor.apellido%type, p_especialidad doctor.especialidad%type,
p_salario doctor.salario%type)
AS
    v_max_id doctor.doctor_no%type;
    v_hospital doctor.hospital_cod%TYPE;
BEGIN
    select max(doctor_no)+1 into v_max_id from doctor;
    select HOSPITAL_COD into v_hospital from hospital where upper(nombre) = upper(p_nombre_hospital);
    insert into doctor values (v_hospital, v_max_id, p_apellido, p_especialidad, p_salario);
    DBMS_OUTPUT.PUT_LINE('Insertados ' || SQL%ROWCOUNT);
    commit;
EXCEPTION    
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('No existe el hospital' || p_nombre_hospital);
end;
-- Llamada al procedimiento
begin
    sp_insertardoctor('la paz', '99', '99', 99);
end;

-- Podemos utilizar cursores explícitos dentro de los procedimientos.
-- Realizar un procedimiento para mostrar los empleados de un número determinado de departamento.
create or replace procedure sp_empleados_dept
(p_deptno emp.dept_no%type)
AS
    cursor cursor_emp IS
    select * from emp where dept_no = p_deptno;
BEGIN
    for v_reg_emp in cursor_emp
    LOOP
        DBMS_OUTPUT.PUT_LINE('Apellido: ' || v_reg_emp.apellido || ', Oficio: ' || v_reg_emp.oficio);
    end loop;    
end;
-- Llamada al procedimiento
BEGIN
    SP_EMPLEADOS_DEPT(10);
end;    
-- En caso de que el departamento no exista, el cursor explícito no va a dar ningún fallo, los que dan fallo son los implícitos
-- Si devuelven más de una fila tampoco da error, al igual que con no_data_found

-- Vamos a realizar un procedimiento para enviar el nombre del departamento y devolver el número de dicho departamento
create or replace procedure sp_numerodepartamento
(p_nombre dept.dnombre%type, p_iddept out dept.dept_no%TYPE) 
as
    v_iddept dept.DEPT_NO%TYPE;
BEGIN
    select dept_no into v_iddept from dept where upper(dnombre) = upper(p_nombre);
    p_iddept := v_iddept;
    dbms_output.put_line('El número de departamento es ' || v_iddept);
end;
-- Llamada al procedimiento
begin
    SP_numerodepartamento('ventas');
end;

-- Necesito un procedimiento para incrementar en 1 el salario de los empleados de un departamento.
-- Enviaremos al procedimiento el nombre del departamento.
create or replace procedure sp_incrementar_sal_dept
(p_nombre dept.dnombre%TYPE)
as
    v_num dept.DEPT_NO%TYPE;
begin
    -- Llamamos al procedimiento de número para recuperar el número a partir del nombre
    sp_numerodepartamento(p_nombre, v_num);
    update emp set salario = salario+1 where dept_no = v_num;
    dbms_output.put_line('Salarios modificados: ' || SQL%ROWCOUNT);
end;
-- Llamada al procedimiento
BEGIN
    sp_incrementar_sal_dept('ventas');
end;








