DECLARE
    -- MI COMENTARIO
    -- DECLARAMOS UNA VARIABLE
    numero int;
    texto varchar2(50);
BEGIN
    texto:= 'Mi primer PL/SQL';
    dbms_output.put_line('Mensaje: ' || texto);
    numero:=6;
    dbms_output.put_line('Mi primer bloque anónimo');
    dbms_output.put_line('Valor número: ' || numero);
    numero := 33;
    dbms_output.put_line('Valor número nuevo: ' || numero);
END;

--------------------------------------------------

DECLARE
    nombre varchar2(20);
BEGIN
    nombre:= '&dato';
    dbms_output.put_line('Su nombre es ' || nombre);
END;    

--------------------------------------------------

DECLARE
    fecha date;
    texto varchar2(50);
    longitud int;
BEGIN
    fecha := sysdate;
    texto := '&data';
    -- Quiero almacenar la longitud del texto
    longitud := length(texto);
    -- La longitud de su texto es:
    dbms_output.put_line('La longitud del texto es ' || longitud);
    -- Hoy es... Miércoles
    dbms_output.put_line('Hoy es ' || to_char(fecha, 'day', 'nls_date_language = Spanish'));
    dbms_output.put_line(texto);
end;        

--------------------------------------------------

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
-- Quitar la definición de las variables
undefine num1;
undefine num2;
--------------------------------------------------

DECLARE
    -- Declaramos la variable para almacenar el número de departamento
    v_departamento int;
BEGIN
    -- Pedimos un número de departamento al usuario
    v_departamento := &dept;
    update emp set salario = salario + 1 where dept_no = v_departamento;
END;
undefine dept;
select * from emp;
--------------------------------------------------




