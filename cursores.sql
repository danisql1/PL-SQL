-- Almacenan consultas en variables
-- Insertar un departamento en un bloque pl/sql dinámico

DECLARE
    v_nombre dept.dnombre%type;
    v_loc dept.loc%type;
BEGIN
    -- Vamos a realizar un bucle para insertar 5 departamentos
    for i in 1..5 loop
        v_nombre := 'Departamento ' || i;
        v_loc := 'Localidad ' || i;
        insert into dept values ((select max(dept_no)+1 from dept),v_nombre,v_loc);
    end loop;
    dbms_output.put_line('Fin del programa');
end;

select * from dept;

rollback;

--Realizar un bloque pl/sql que pedirá un número al usuario y mostrará el departamento con dicho nº

DECLARE
    v_id int;
BEGIN
    v_id := &numero;
    select * from dept where dept_no=v_id; -- Da error ya que el SELECT sólo se puede usar en consultas de acción (INSERT, UPDATE y DELETE)
end;

undefine numero;

-- Cursor implícito: guarda un sólo valor en una variable
-- Cursor explícito: guardan más de un valor en la variable

--------------- CURSOR IMPLÍCITO. Sólo pueden devolver una fila
-- Recuperar el oficio del empleado REY
DECLARE
    v_oficio emp.oficio%type;
BEGIN
    select oficio into v_oficio from emp where upper(apellido) = 'REY';
    dbms_output.put_line('El oficio de REY es ' || v_oficio);
end;

--------------- CURSOR EXPLÍCITO. Pueden devolver más de una fila y es necesario declararlos
-- Mostrar el apellido y salario de todos los empleados

DECLARE
    v_ape emp.APELLIDO%TYPE;
    v_sal emp.SALARIO%TYPE;
    -- Declaramos nuestro cursor con una consulta. La consulta debe tener los mismos datos para luego hacer el FETCH
    cursor cursoremp IS
    select apellido, salario from emp;
BEGIN
    -- Abrir el cursor
    open cursoremp;
    -- Bucle infinito
    LOOP
        -- Extraemos los datos del cursor fila a fila con la instrucción FETCH en el mismo orden del SELECT
        fetch cursoremp into v_ape, v_sal;
        exit when cursoremp%notfound; -- El exit aquí para que no duplique el último campo
        -- Dibujamos los datos
        dbms_output.put_line('Apellido: ' || v_ape || ', Salario: ' || v_sal);
    end loop;    
    -- Cerramos cursor
    close cursoremp;
end;

--------------- ATRIBUTOS
-- %ROWCOUNT para las consultas de acción. Devuelve el número de filas recuperadas con FETCH
-- Incrementar en 1 el salario de los empleados del departamento 10. Mostrar el número de empleados modificados

BEGIN
    update emp set salario = salario+1 where dept_no = 10;
    dbms_output.put_line('Empleados modificados: ' || SQL%ROWCOUNT);
end;

-- Incrementar en 10.000 al empleado que menos cobre en la empresa

DECLARE
    v_salario emp.SALARIO%TYPE;
    v_apellido emp.APELLIDO%TYPE;
BEGIN
    select min(salario) into v_salario from emp;
    -- Almacenamos la persona que cobra dicho salario
    select apellido into v_apellido from emp where salario=v_salario;
    update emp set SALARIO = salario+10000 where v_salario=salario;
    dbms_output.put_line('Salario incrementado a ' || v_apellido);
end;

---------------
-- Realizar un código PL/SQL donde pediremos el número, nombre y localidad de un departamento.
-- Si el departamento existe, modificamos su nombre y localidad. Si el departamento no existe, lo insertamos

DECLARE
    v_id dept.DEPT_NO%TYPE;
    v_nombre dept.DNOMBRE%TYPE;
    v_loc dept.LOC%TYPE;
    v_existe dept.DEPT_NO%TYPE;

    cursor cursordept IS
    select dept_no from dept where dept_no=v_id; 
BEGIN
    v_id := &numero;
    v_nombre := '&nombre';
    v_loc := '&loc';
    open cursordept;
    fetch cursordept into v_existe;
    if (cursordept%found) THEN
        dbms_output.put_line('UPDATE');
        update dept set dnombre=v_nombre, loc=v_loc where dept_no=v_id;
    else
        dbms_output.put_line('INSERT');
        insert into dept values (v_id, v_nombre, v_loc);
    end if;
    close cursordept;
end;

undefine numero;
undefine nombre;
undefine loc;

--------------- Versión sin cursor

DECLARE
    v_id dept.DEPT_NO%TYPE;
    v_nombre dept.DNOMBRE%TYPE;
    v_loc dept.LOC%TYPE;
    v_existe dept.DEPT_NO%TYPE;

BEGIN
    v_id := &numero;
    v_nombre := '&nombre';
    v_loc := '&loc';
    select count(dept_no) into v_existe from dept where dept_no=v_id;
    if (v_existe = 0) THEN
        dbms_output.put_line('INSERT');
        insert into dept values (v_id, v_nombre, v_loc);
    else
        dbms_output.put_line('INSERT');
        update dept set dnombre=v_nombre, loc=v_loc where dept_no=v_id;
    end if;
end;

undefine numero;
undefine nombre;
undefine loc;

---------------
-- Realizar un código pl/sql para modificar el salario del empleado ARROYO
-- Si el empleado cobra más de 250.000€, le bajamos el sueldo en 10.000€
-- Si no, le subimos el sueldo en 10.000€
DECLARE
    v_salario emp.SALARIO%TYPE;
BEGIN
     select salario into v_salario from emp where apellido = 'arroyo';
    if (v_salario>250000) THEN
        update emp set salario = salario-10000 where apellido = 'arroyo';
        dbms_output.put_line('Salario reducido');
    ELSE
        update emp set salario = salario+10000 where apellido = 'arroyo';
        dbms_output.put_line('Salario aumentado');
    end if;
end;

---------------
-- Necesitamos modificar el salario de los doctores de La Paz. Si la suma salarial supera 1.000.000,
-- bajamos salarios en 10.000 a todos
-- Si la suma salarial no supera 1.000.000, subimos salarios en 10.000
-- Mostrar el número de filas que hemos modificado
-- Solución 1
DECLARE
    v_suma number;  
BEGIN
    select sum(doctor.salario) into v_suma from doctor inner join hospital 
    on doctor.hospital_cod = hospital.hospital_cod where lower(hospital.nombre) = 'la paz';
        if v_suma > 1000000 THEN
            dbms_output.put_line('Bajando salarios a ' || SQL%ROWCOUNT || ' empleados');
            update doctor set salario = salario - 10000 where hospital_cod =
            (select hospital_cod from hospital where lower(nombre) = 'la paz'); 
        else 
            dbms_output.put_line('Subiendo salarios a ' || SQL%ROWCOUNT || ' empleados');
            update doctor set salario = salario + 10000 where hospital_cod =
            (select hospital_cod from hospital where lower(nombre) = 'la paz'); 
        end if;     
end;

-- Solución 2

DECLARE
    v_suma number; 
    v_codigo hospital.HOSPITAL_COD%TYPE; 
BEGIN
    select hospital_cod into v_codigo from hospital where lower(nombre)= 'la paz';
    select sum(doctor.salario) into v_suma from doctor where hospital_cod = v_codigo;
        if v_suma > 1000000 THEN
            dbms_output.put_line('Bajando salarios a ' || SQL%ROWCOUNT || ' empleados');
            update doctor set salario = salario - 10000 where hospital_cod = v_codigo; 
        else 
            dbms_output.put_line('Subiendo salarios a ' || SQL%ROWCOUNT || ' empleados');
            update doctor set salario = salario + 10000 where hospital_cod = v_codigo; 
        end if;     
end;

---------------------------
-- Realizamos la declaración con departamentos

describe dept;
declare
    v_fila dept.DEPT_NO%ROWTYPE;
begin
    v_fila.DEPT_NO := null;
    dbms_output.put_line('El valor de v_id es ' || v_fila.DEPT_NO);
end;

-- Podemos almacenar todos los departamentos (uno a uno) en un ROWTYPE

declare
    v_fila DEPT%ROWTYPE;
    cursor cursor_dept IS
    select * from dept;
begin   
    open cursor_dept;
    loop
        fetch cursor_dept into v_fila;
        exit when cursor_dept%notfound;
        dbms_output.put_line('ID: ' || v_fila.dept_no || ', Nombre: ' || v_fila.dnombre || ', Localidad: ' || v_fila.loc);
    end loop;
    close cursor_dept;
end;

---------------------------
-- Realizar un cursor para mostrar el apellido, salario y oficio de empleados
declare
    cursor cursor_emp IS
    select apellido, salario, oficio, salario + comision as total from emp;
begin
    for v_registro in cursor_emp 
    LOOP
        dbms_output.put_line('Apellido: ' || v_registro.apellido || ', Salario: ' || v_registro.salario
        || ', Oficio: ' || v_registro.oficio || ', Total: ' || v_registro.total);
    end loop;    
end;












