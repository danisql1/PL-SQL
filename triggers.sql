-- Ejemplo de TRIGGER capturando información
create or replace trigger tr_dept_before_insert
before INSERT
on dept
for each row
declare
begin
    DBMS_OUTPUT.PUT_LINE('Trigger DEPT before insert row');
    DBMS_OUTPUT.PUT_LINE(:new.dept_no || ', ' || :new.dnombre || ', ' || :new.loc);
end;

insert into dept values (111, 'NUEVO', 'TOLEDO');
-- DELETE
create or replace trigger tr_dept_before_delete
before delete
on dept
for each row
declare
begin
    DBMS_OUTPUT.PUT_LINE('Trigger DEPT before delete row');
    DBMS_OUTPUT.PUT_LINE(:old.dept_no || ', ' || :old.dnombre || ', ' || :old.loc);
end;

delete from dept where dept_no=47;
-- UPDATE
create or replace trigger tr_dept_before_update
before update
on dept
for each row
declare
begin
    DBMS_OUTPUT.PUT_LINE('Trigger DEPT before update row');
    DBMS_OUTPUT.PUT_LINE(:old.dept_no || ', ' || :old.dnombre || ', Antigua LOC:' || :old.loc || ', Nueva LOC: ' || :new.loc);
end;

update dept set loc='VITORIA' where dept_no=111;
-- TRIGGER del control doctor
create or replace trigger tr_doctor_control_salario_update
before update
on doctor
for each row
    when (new.salario > 250000)
declare
begin
    DBMS_OUTPUT.PUT_LINE('Trigger DOCTOR before update row');
    DBMS_OUTPUT.PUT_LINE('Dr/a ' || :old.apellido || ' cobra mucho dinero ' || :new.salario || 
    '. Antes: ' || :old.salario);
end;

update doctor set salario = 150000 where doctor_no = 386;

---- CONTROL DE ERRORES
-- No podemos tener dos TRIGGER del mismo tipo en una tabla
-- drop trigger tr_dept_before_insert;

create or replace trigger tr_dept_control_barcelona
before INSERT
on dept
for each row
    when (upper(new.loc)='BARCELONA')
declare
begin
    DBMS_OUTPUT.PUT_LINE('Trigger Control Barcelona');
    DBMS_OUTPUT.PUT_LINE('No se admiten departamentos en Barcelona');
    RAISE_APPLICATION_ERROR(-20001, 'En Munich solo ganadores');
end;

insert into dept values (66,'MILAN','BARCELONA');

-------- CONTROL LOCALIDADES

create or replace trigger tr_dept_control_localidades
before INSERT
on dept
for each row
declare
    v_num number;
begin
    DBMS_OUTPUT.PUT_LINE('Trigger Control Localidades');
    select count(dept_no) into v_num from dept where upper(loc)=upper(:new.loc);
    if (v_num >= 1) then
        RAISE_APPLICATION_ERROR(-20001, 'Solo un departamento por ciudad ' || :new.loc);
    end if;
end;

insert into dept values (6688,'MILAN','BARCELONA');

--------- INTEGRIDAD RELACIONAL
-- Si cambiamos un ID de departamento, que se modifiquen también los empleados asociados
create or replace trigger tr_update_dept_cascade
before UPDATE
on dept
for each row
    when (new.dept_no <> old.dept_no)
declare
begin
    DBMS_OUTPUT.PUT_LINE('DEPT_NO cambiado');
    -- Modificamos los datos asociados (EMP)
    update emp set dept_no = :new.dept_no where dept_no = :old.dept_no;
end;

update dept set dept_no = 31 where dept_no =30;
---------
-- Impedir insertar un nuevo PRESIDENTE si ya existe uno en la tabla EMP
create or replace trigger tr_presidente
before insert
on emp
for each ROW
    when (upper(new.oficio) = 'PRESIDENTE')
declare
    v_presidente int;
begin
    select count(emp_no) into v_presidente from emp where upper(oficio) = 'PRESIDENTE';
    if (v_presidente >= 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ya existe un presidente');
    end if;
end;

insert into emp values (10011, 'prueba','presidente', null, null,0,0,30);
----------
---- No quiero que exista más de un departamento por localidad si hacemos un UPDATE
-- PACKAGE para almacenar las variables entre TRIGGERS
create or replace package pk_triggers
AS
    v_nueva_localidad dept.LOC%TYPE;    
end pk_triggers;
-- Creamos el TRIGGER de before row
create or replace trigger tr_dept_control_localidades_row
before update
on dept
for each row
declare
begin
    -- Almacenamos el valor de la nueva localidad
    PK_TRIGGERS.v_nueva_localidad := :new.loc;
end;
-- Creamos el TRIGGER de after
create or replace trigger tr_dept_control_localidades_after
after UPDATE
on dept
declare
    v_numero number;
begin
    select count(dept_no) into v_numero from dept where upper(loc)=upper(PK_TRIGGERS.v_nueva_localidad);
    if (v_numero > 0) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Solo un departamento por localidad');
    end if;
    DBMS_OUTPUT.PUT_LINE('Localidad nueva: ' || PK_TRIGGERS.v_nueva_localidad);
end;

update dept set loc = 'CADIZ' where dept_no=10;

---------- TRIGGERS INSTEAD OF
-- Trabajan solamente con VISTAS

-- Creamos una vista con todos los datos de los departamentos
create or replace view vista_departamentos
as
    select * from dept;
-- A partir de ahora solo trabajamos con la vista
select * from VISTA_DEPARTAMENTOS;
-- Si insertamos sobre la vista nos va a dejar
insert into VISTA_DEPARTAMENTOS values (11,'VISTA','SIN TRIGGER');
-- Creamos un TRIGGER INSTEAD OF sobre la vista
create or replace trigger tr_vista_dept
instead of insert
on vista_departamentos
declare
begin
    dbms_output.put_line('Insertando en Vista DEPT');
end;
-- Probamos a insertar otro departamento
insert into VISTA_DEPARTAMENTOS values (12,'VISTA','CON TRIGGER');
-- No inserta nada porque el INSTEAD OF evita hacer esa instrucción (insert en este caso), hay que hacerlo uno mismo a mano

---- Vamos a crear una vista con los datos de los empleados pero sin sus datos sensibles 
-- (salario, comision, fecha_alt)
create or replace view vista_empleados
as
    select emp_no, apellido, oficio, dir, dept_no from emp;
select * from vista_empleados;

insert into vista_empleados values (555,'el nuevo','BECARIO',7566,31);
-- Si miramos en la tabla, los campos no rellenados se completan con NULL, creamos un TRIGGER rellenando los huecos
create or replace trigger tr_vista_empleados
instead of insert
on vista_empleados
declare
begin
    -- Con NEW (porque estoy en INSERT) capturamos los datos que vienen en la vista y rellenamos el resto
    insert into emp values (:new.emp_no, :new.apellido, :new.oficio, :new.dir, sysdate, 0, 0, :new.dept_no);
end;
-- Si volvemos a insertar a un empleado, los campos ya se actualizan quitando los NULL
insert into vista_empleados values (556,'el nuevo','BECARIO',7566,31);

---- Vamos a crear una vista para insertar doctores
create or replace view vista_doctores
as
    select doctor.doctor_no, doctor.apellido, doctor.especialidad, doctor.salario, hospital.nombre
    from doctor inner join hospital on doctor.hospital_cod=hospital.hospital_cod;
-- Probamos a insertar un doctor
insert into vista_doctores values (1111,'House','Especialidad',450000,'provincial');
-- Al tener que insertar en dos tablas distintas, da error, por eso hay que crear un TRIGGER que busque el código de hospital e insertar al doctor
create or replace trigger insertar_doctor
instead of insert
on vista_doctores
declare
    v_hospital hospital.hospital_cod%type;
begin
    select hospital_cod into v_hospital from hospital where lower(nombre)=lower(:new.nombre);
    insert into doctor values (v_hospital, :new.doctor_no,:new.apellido,:new.especialidad,:new.salario);
end;
-- Ahora ya sí podemos insertar el doctor
insert into vista_doctores values (1111,'House','Especialidad',450000,'provincial');
