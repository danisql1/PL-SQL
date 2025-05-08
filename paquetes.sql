-- Creamos nuestro primer paquete de prueba
-- Tiene HEADER y BODY, aunque el BODY es opcional
-- HEADER
create or replace package pk_ejemplo
AS
    -- En el HEADER, solamente se incluyen las declaraciones
    procedure mostrarmensaje;
end pk_ejemplo;
-- BODY
create or replace package body pk_ejemplo
AS
    -- En el HEADER, solamente se incluyen las declaraciones
    procedure mostrarmensaje
    as
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Soy un paquete');
    end;    
end pk_ejemplo;
-- Llamada
BEGIN
    PK_EJEMPLO.MOSTRARMENSAJE;
end;
--------------------------------
-- Vamos a realizar un paquete que contenga acciones de eliminar sobre EMP, DEPT, DOCTOR y ENFERMO
create or replace package pk_delete
AS
    procedure eliminarEMP(p_empno emp.emp_no%type);
    procedure eliminarDEPT(p_deptno dept.dept_no%type);
    procedure eliminarDOCTOR(p_doctorno doctor.doctor_no%type);
    procedure eliminarENFERMO(p_inscripcion enfermo.inscripcion%type);
end pk_delete;
--body
create or replace package body pk_delete
AS
    procedure eliminarEMP(p_empno emp.emp_no%type)
    as
    BEGIN
        delete from emp where emp_no = p_empno;
        commit;
    end;    
    procedure eliminarDEPT(p_deptno dept.dept_no%type)
    as
    BEGIN
        delete from dept where dept_no = p_deptno;
        commit;
    end;    
    procedure eliminarDOCTOR(p_doctorno doctor.doctor_no%type)
    AS
    BEGIN
        delete from doctor where doctor_no = p_doctorno;
        commit;
    end;    
    procedure eliminarENFERMO(p_inscripcion enfermo.inscripcion%type)
    AS
    BEGIN
        -- eliminarDEPT(45); -- Si estás dentro del paquete no hay que poner el nombre del paquete
        delete from enfermo where inscripcion = p_inscripcion;
        commit;
    end;    
end pk_delete;
-- Llamada
BEGIN
    pk_delete.ELIMINARDEPT(10);
end;
--------------------------------
-- Crear un paquete para devolver máximo, mínimo y diferencia de salario de todos los empleados
create or replace package pk_empleados_salarios
AS
    function minimo return number;
    function maximo return number;
    function diferencia return number;
end pk_empleados_salarios;
create or replace package body pk_empleados_salarios
AS
    function minimo return number
    AS
        v_minimo emp.SALARIO%TYPE;
    BEGIN
        select min(salario) into v_minimo from emp;
        return v_minimo;
    end;    
    function maximo return number
    AS
        v_maximo emp.SALARIO%TYPE;
    BEGIN
        select max(salario) into v_maximo from emp;
        return v_maximo;
    end;        
    function diferencia return number
    AS
        v_diferencia emp.SALARIO%TYPE;
    BEGIN
        v_diferencia := maximo - minimo; -- Restas la función mínimo y la función máximo. No se podría restar v_maximo y v_minimo porque son de otras funciones
        return v_diferencia;
    end;        
end pk_empleados_salarios;
-- Llamada
select PK_EMPLEADOS_SALARIOS.MAXIMO as MAXIMO, PK_EMPLEADOS_SALARIOS.MINIMO as MINIMO, PK_EMPLEADOS_SALARIOS.DIFERENCIA as DIFERENCIA from dual;
--------------------------------
-- Necesito un paquete para realizar INSERT, UPDATE y DELETE sobre departamentos
-- Llamamos al package pk_departamentos
create or replace package pk_departamentos
AS
    procedure insert_dept(p_dept dept.dept_no%type,p_dnombre dept.dnombre%type, p_loc dept.loc%type);
    procedure update_dept(p_dept dept.dept_no%type,p_dnombre dept.dnombre%type, p_loc dept.loc%type);
    procedure delete_dept(p_dept dept.dept_no%TYPE); 
end pk_departamentos;
create or replace package body pk_departamentos
as
    procedure insert_dept(p_dept dept.dept_no%type, p_dnombre dept.dnombre%type, p_loc dept.loc%type)
    AS
    BEGIN
        insert into dept values (p_dept, p_dnombre, p_loc);
        commit;
    end;    
    procedure update_dept(p_dept dept.dept_no%type,p_dnombre dept.dnombre%type, p_loc dept.loc%type)
    AS
    begin
        update dept set dnombre = p_dnombre, loc = p_loc where dept_no = p_dept;
        commit;
    end;
    procedure delete_dept(p_dept dept.dept_no%type)
    as
    BEGIN
        delete from dept where dept_no = p_dept;
        commit;
    end;    
end pk_departamentos;
-- Llamada
begin
    PK_DEPARTAMENTOS.INSERT_DEPT(55,'PRUEBA','PRUEBA');
end;
--------------------------------
-- Necesito una funcionalidad que nos devuelva el apellido, oficio, salario y lugar de trabajo de todas las personas de nuestra bbdd.
-- Necesito otra funcionalidad que nos devuelva el apellido, oficio, salario y lugar de trabajo dependiendo del salario.
--union
-- 1) Consulta gorda
-- 2) Consulta dentro de vista
-- 3) Paquete con procedimientos
---- 3A) Procedimiento para devolver todos los datos en un cursor
---- 3B) Procedimiento para devolver todos los datos en un cursor por salario
--1)
select apellido, oficio, salario, dept.dnombre as LUGAR_TRABAJO from emp inner join dept on emp.dept_no=dept.dept_no
UNION
select apellido, especialidad, salario, hospital.nombre as LUGAR_TRABAJO from doctor inner join hospital on doctor.DOCTOR_NO=hospital.HOSPITAL_COD
UNION
select apellido, funcion, salario, hospital.nombre as LUGAR_TRABAJO from plantilla inner join hospital on plantilla.HOSPITAL_COD=hospital.HOSPITAL_COD;
--2)
create or replace view vista_trabajadores
AS
    select apellido, oficio, salario, dept.dnombre as LUGAR_TRABAJO from emp inner join dept on emp.dept_no=dept.dept_no
    UNION
    select apellido, especialidad, salario, hospital.nombre as LUGAR_TRABAJO from doctor inner join hospital on doctor.DOCTOR_NO=hospital.HOSPITAL_COD
    UNION
    select apellido, funcion, salario, hospital.nombre as LUGAR_TRABAJO from plantilla inner join hospital on plantilla.HOSPITAL_COD=hospital.HOSPITAL_COD;

select * from vista_trabajadores where salario > 250000;
--3)
create or replace package pk_trabajadores
AS
    procedure trabajadores;
    procedure trabajadores_por_salario(p_salario emp.salario%type);
end pk_trabajadores;
create or replace package body pk_trabajadores
AS
    procedure trabajadores
    as    
        cursor cursor_trabajadores is
        select * from VISTA_TRABAJADORES;
    begin
        for v_trabajador in cursor_trabajadores 
        LOOP
            dbms_output.put_line('Apellido: ' || v_trabajador.apellido || ', Oficio: ' || v_trabajador.oficio || ', Salario: ' || v_trabajador.salario || ', Lugar de trabajo: ' || v_trabajador.LUGAR_TRABAJO);
        end loop;
    end;
    procedure trabajadores_por_salario(p_salario emp.salario%type)
    AS
        cursor cursor_salario_trabajadores is
        select * from vista_trabajadores where salario >= p_salario;
    begin
            for v_trabajador in cursor_salario_trabajadores
            loop
            dbms_output.put_line('Apellido: ' || v_trabajador.apellido || ', Oficio: ' || v_trabajador.oficio || ', Salario: ' || v_trabajador.salario || ', Lugar de trabajo: ' || v_trabajador.LUGAR_TRABAJO);
            end loop;    
    end;
end pk_trabajadores;
-- Llamada
begin
    PK_TRABAJADORES.TRABAJADORES;
    PK_TRABAJADORES.TRABAJADORES_POR_SALARIO(350000);
end;

-- Un paquete que tendrá un procedimiento y una función
-- Cada doctor tendrá un valor aleatorio 
--------------------------------
/* Necesitamos un paquete con procedimiento para modificar el salario de cada doctor de forma individual. La modificación de los datos de cada doctor será de forma aleatoria.
Debemos comprobar el salario de cada doctor para ajustar el número aleatorio del incremento.
  1) Doctor con menos de 200.000: incremento aleatorio de 500
  2) Doctor entre 200.000 y 300.000: incremento aleatorio de 300 
  3) Doctor mayor a 300.000: incremento aleatorio de 50
El incremento Random lo haremos con una función dentro del paquete  
*/
-- HEADER
create or replace package pk_doctores
AS
    procedure incremento_random_doctores;
    function random_doctores(p_iddoctor doctor.doctor_no%type)
    return number;
end pk_doctores;    
-- BODY
create or replace package body pk_doctores
AS
    procedure incremento_random_doctores
    as
        cursor c_doctores is
        select doctor_no, apellido, salario from doctor;
        v_random number;
    begin
        for v_doc in c_doctores
        loop
            v_random := random_doctores(v_doc.doctor_no);
            update doctor set salario = salario + v_random where doctor_no = v_doc.doctor_no;
            DBMS_OUTPUT.PUT_LINE('Doctor ' || v_doc.apellido || ' tiene un incremento de ' || v_random);
        end loop;
    end;
    function random_doctores(p_iddoctor doctor.doctor_no%type)
    return number
    as
        v_salario doctor.salario%type;
        v_random number;
    BEGIN
        select salario into v_salario from doctor where doctor_no = p_iddoctor;
        if (v_salario < 200000) then
            v_random := trunc(dbms_random.value(1,500));
        elsif (v_salario > 300000) then
            v_random := trunc(dbms_random.value(1,50));
        else
            v_random := trunc(dbms_random.value(1,300));
        end if;
        return v_random; 
    end;
end pk_doctores; 
-- Llamada
select random_doctor(386) as incremento from dual;
