-- 1. Crear un bloque anónimo que sume dos números introducidos por teclado y muestre el resultado 
-- por pantalla.

DECLARE
    numero1 int;
    numero2 int;
    suma int;
BEGIN   
    numero1 := &num1;
    numero2 := &num2;
    suma := numero1+numero2;
    dbms_output.put_line('La suma de ' || numero1 || ' + ' || numero2 || ' es ' || suma);
END;    
undefine num1;
undefine num2;

-- 2. Insertar en la tabla EMP un empleado con código 9999 asignado directamente en la variable 
-- con %TYPE, apellido ‘PEREZ’, oficio ‘ANALISTA’ y código del departamento al que pertenece 10.

DECLARE
    v_codigo emp.emp_no%type;
    v_apellido emp.apellido%type;
    v_oficio emp.oficio%type;
    v_departamento emp.dept_no%type;
BEGIN
    v_codigo := &codigo;
    v_apellido := '&apellido';
    v_oficio := '&oficio';
    v_departamento := &departamento;
    insert into emp (emp_no, apellido, oficio, dept_no) values (v_codigo, v_apellido, v_oficio, v_departamento);
end;
undefine codigo;
undefine apellido;
undefine oficio;
undefine departamento;

 -- 3. Incrementar el salario en la tabla EMP en 200 EUROS a todos los trabajadores que sean 
-- ‘ANALISTA’, mediante un bloque anónimo PL, asignando dicho valor a una variable declarada con %TYPE

DECLARE
    v_oficio emp.oficio%type;
BEGIN
    v_oficio := '&oficio';
    update emp set salario = salario + 200 where oficio = v_oficio;
END;
undefine oficio;

-- 4. Realizar un programa que devuelva el número de cifras de un número entero, 
--introducido por teclado, mediante una variable de sustitución.

DECLARE
    numero int;
    longitud int;
BEGIN
    numero := &numero;
    longitud := length(numero);
    dbms_output.put_line('El número ' || numero || ' tiene ' || longitud || ' cifras.');
end;
undefine numero;
undefine longitud;

-- 5. Crear un bloque PL para insertar una fila en la tabla DEPT. 
-- Todos los datos necesarios serán pedidos desde teclado.

DECLARE
    v_numero dept.dept_no%type;
    v_nombre dept.dnombre%type;
    v_localidad dept.loc%type;
BEGIN
    v_numero := &numero;
    v_nombre := '&nombre';
    v_localidad := '&localidad';
    insert into dept values (v_numero, v_nombre, v_localidad);
END;    
undefine numero;
undefine nombre;
undefine localidad;

-- 6. Crear un bloque PL que actualice el salario de los empleados que no cobran comisión en un 5%.

DECLARE
    v_comision emp.comision%type;
BEGIN
    v_comision := 0;
    update emp set salario = salario+ (salario *5/100) where comision = v_comision;
end;

-- 7. Crear un bloque PL que almacene la fecha del sistema en una variable. Solicitar un número de 
-- meses por teclado y mostrar la fecha del sistema incrementado en ese número de meses.

DECLARE
    fecha date;
    meses int;
BEGIN
    fecha := sysdate;
    meses := &meses;
    dbms_output.put_line(fecha+meses);
END;
undefine meses;

-- 8. Introducir dos números por teclado y devolver el resto de la división de los dos números

DECLARE
    num1 int;
    num2 int;
BEGIN
    num1 := &num1;
    num2 := &num2;
    dbms_output.put_line(mod(num1,num2));
END;
undefine num1;
undefine num2;

-- 9. Solicitar un nombre por teclado y devolver ese nombre con la primera inicial en mayúscula

DECLARE
    nombre varchar2(20);
BEGIN
    nombre := '&nombre';
    dbms_output.put_line(initcap(nombre));
END;

undefine nombre;

-- 10. Crear un bloque anónimo que permita borrar un registro de la tabla EMP introduciendo por 
-- parámetro un número de empleado

DECLARE
    v_emp emp.emp_no%type;
BEGIN
    v_emp := &numero;
    delete from emp where emp_no = v_emp;
END;
undefine numero;

