------------------ TIPOS DE DATO

-- Bloque anónimo para recuperar el apellido, oficio y salario de empleados
DECLARE
    -- Primero declaramos el tipo
    type type_empleado is record(
        v_apellido varchar2(50),
        v_oficio varchar2(50),
        v_salario number
    );
    -- Uso del tipo en una variable
    v_tipo_empleado type_empleado;
begin
    select apellido, oficio, salario into v_tipo_empleado from emp where emp_no =7839;
    dbms_output.put_line('Apellido: ' || v_tipo_empleado.v_apellido || ', Oficio: ' || 
    v_tipo_empleado.v_oficio || ', Salario: ' || v_tipo_empleado.v_salario);
end;
-- sólamente en la cabecera de las funciones y procedimientos, no es necesario indicar el tamaño del varchar2, aquí SÍ es necesario

--------------- ARRAYS

-- Por un lado tenemos la declaración del tipo. Por otro lado, tenemos la variable de dicho tipo
DECLARE
    -- Un tipo ARRAY para números. Se llama table_numeros
    type table_numeros is table of number index by BINARY_INTEGER;
    -- Objeto para almacenar varios números. Se llama lista_numeros del mismo tipo del ARRAY
    lista_numeros table_numeros;
begin
    -- Almacenamos datos en su interior
    lista_numeros(1) := 88;
    lista_numeros(2) := 99;
    lista_numeros(3) := 222;
    DBMS_OUTPUT.PUT_LINE('Número de elementos: ' || lista_numeros.count);
    -- Podemos recorrer todos los registros (numeros) que tengamos
    for i in 1..lista_numeros.count
    loop
        DBMS_OUTPUT.PUT_LINE('Número: ' || lista_numeros(i));
    end loop;
end;

-- Podemos almacenar a la vez
-- Guardamos un tipo fila de departamento
DECLARE
    type table_dept is table of dept%rowtype index by BINARY_INTEGER;
    -- Declaramos el objeto para almacenar filas
    lista_dept table_dept;
begin
    select * into lista_dept(1) from dept where dept_no=10;
    select * into lista_dept(2) from dept where dept_no=30;
    for i in 1..lista_dept.count
    loop
        DBMS_OUTPUT.PUT_LINE(lista_dept(i).dnombre || ', ' || lista_dept(i).loc);
    end loop;
end;

--------------- VARRAYS
-- Hay que decirle explícitamente qué tamaño va a tener, es la diferencia con el TABLE OF del ARRAY

DECLARE
    cursor cursorEmpleados IS
    select apellido from emp;
    type c_lista is varray (20) of emp.apellido%type;
    lista_empleados c_lista := c_lista();
    contador integer := 0;
begin
    for n in cursorEmpleados LOOP
    contador := contador +1;
    lista_empleados.extend; --Hay que ponerlo siempre que vayas a añadir un nuevo elemento al VARRAY
    lista_empleados(contador) := n.apellido;
    DBMS_OUTPUT.PUT_LINE('Empleado (' || contador || '):' || lista_empleados(contador));
    end loop;
end;


