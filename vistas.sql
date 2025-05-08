-- Vamos a crear una vista para tener todos los datos de los empleados sin el salario ni comisión, ni dir.
create or replace view v_empleados
AS
    select emp_no, apellido, oficio, fecha_alt, dept_no from emp;
-- Una vista es sólo una consulta que se ejecuta de nuevo. 
-- Una vista simplifica las consultas 

-- Mostrar el apellido, oficio, salario, nombre de departamento y localidad de todos los empleados
create or replace view v_emp_dept 
as
    select emp.apellido, emp.oficio, emp.salario, dept.dnombre as DEPARTAMENTO, dept.loc as LOCALIDAD
    from emp inner join dept 
    on emp.dept_no = dept.dept_no;

select * from v_emp_dept where loc='MADRID'; -- Si el loc no tiene alias, esto funciona
select * from v_emp_dept where LOCALIDAD='MADRID';

select * from user_views where view_name='v_emp_dept';

-- Podemos tener campos virtuales
create or replace view v_empleados_virtual
AS
    select emp_no, apellido, oficio, salario+comision as TOTAL, dept_no from emp;

select * from V_EMPLEADOS_VIRTUAL;

------------------------
-- Vamos a modificar el salario de los empleados ANALISTA
-- Primero sobre la tabla
update emp set salario = salario +1 where oficio = 'ANALISTA';

create or replace view v_empleados
AS
    select emp_no, apellido, oficio, salario, fecha_alt, dept_no from emp;

select * from V_EMPLEADOS where oficio = 'ANALISTA';
-- Modificamos la vista
update v_empleados set salario = salario +1 where oficio = 'ANALISTA';
-- Al modificar la vista, también se modifican los datos de la tabla puesto que los datos de la vista son los de la tabla
------------------------
-- Vamos a eliminar al empleado con ID 7917
delete from v_empleados where emp_no = 7917;
-- Lo permite
select * from v_empleados;
------------------------
-- Vamos a insertar en la vista
insert into v_empleados values (1111, 'lunes', 'LUNES', 0, sysdate, 20);
-- También lo permite
select * from v_empleados;
select * from emp;
------------------------
-- ¿Qué sucede si las columnas no admiten null? No deja insertar pero por la configuración de la tabla
-- Eliminar a los empleados de Barcelona
delete from v_emp_dept where LOCALIDAD = 'BARCELONA';
-- Insertar un nuevo empleado en la vista con varias tablas, no deja insertarlo al ser datos de varias tablas

------------ Vistas que pueden llegar a ser inútiles
create or replace view v_vendedores
AS
    select emp_no, apellido, oficio, salario, dept_no from emp where oficio='VENDEDOR';
-- Modificamos el salario de los vendedores
update V_VENDEDORES set salario = salario +1;
update V_VENDEDORES set oficio = 'VENDIDOS';
-- Al modificar el campo que afecta al WHERE cuando creamos la vista, nos queda una vista inútil
-- Hay que añadir WITH CHECK OPTION; a la sintaxis de la vista
create or replace view v_vendedores
AS
    select emp_no, apellido, oficio, salario, dept_no from emp where oficio='VENDEDOR'
    with CHECK option;










