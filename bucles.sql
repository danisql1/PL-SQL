-- Mostrar la suma de los primeros 100 números
-- LOOP..END LOOP
DECLARE
    i int; -- Las variables contador selen denominarse con una sola letra
    suma int;
BEGIN
    -- Debemos iniciar i, si no será null
    i := 1;
    -- Inicializamos suma para que tampoco sea null
    suma := 0;
    LOOP
        -- Instrucciones
        suma := suma+i;
        -- Incrementamos la variable i
        i := i+1;
        -- Debemos indicar cuándo queremos que el bucle finalice
        exit when i > 100;
    end loop;    
    dbms_output.put_line('La suma de los primeros 100 números es: ' || suma);
end;
 
-------------------------------------------
-- Mismo programa pero con WHILE .. LOOP
-- En este caso la condición se evalúa antes de entrar al bucle
DECLARE
    i int;
    suma int;
BEGIN
    i := 1;
    suma := 0;
    while i <= 100 LOOP
        suma := suma+i;
        i := i+1;
    end loop;
    dbms_output.put_line('La suma de los primeros 100 números es: ' || suma);
end;

-------------------------------------------
-- Mismo programa pero con bucle FOR..LOOP (contador)
-- Cuando sabemos el inicio y el final

DECLARE
    suma int;
BEGIN
    suma := 0;
    for i in 1..100 loop
        suma := suma+i;
    end loop;
dbms_output.put_line('La suma de los primeros 100 números es: ' || suma);
end;

-------------------------------------------
-- Etiqueta GOTO

DECLARE
    suma int;
BEGIN
    suma := 0;
    dbms_output.put_line('Inicio');
    goto codigo;
    dbms_output.put_line('Antes del bucle');
    for i in 1..100 loop
        suma := suma+i;
    end loop;
    <<codigo>>
dbms_output.put_line('Después del bucle');
dbms_output.put_line('La suma de los primeros 100 números es: ' || suma);
end;

-- No puede haber otra etiqueta con el mismo nombre
-- Debe tener un bloque o conjunto de órdenes ejecutables
-- No puede saltar al interior de un bucle ni al interior de un IF

-------------------------------------------
-- EJEMPLOS
-- Un bucle para mostrar los números entre 1 y 10
-- 1) Bucle WHILE
-- 2) Bucle FOR

-- 1)

DECLARE
    i int;
BEGIN
    i := 1;
    while i <= 10 LOOP
        dbms_output.put_line (i);
        i := i+1;
    end loop;
end;    

-- 2)

DECLARE
BEGIN
    for i in 1..10 loop
        dbms_output.put_line (i);
    end loop;
end;

-- Pedir al usuario un número inicial &inicio y un número final &final
-- Mostrar los números comprendidos entre dicho rango
-- Si el número inicial es mayor, lo indicamos y no hacemos el bucle
DECLARE
    inicio int;
    final int;
BEGIN
    inicio := &inicio;
    final := &final;
    if inicio >= final THEN
        dbms_output.put_line(inicio || ' es mayor que ' || final);
    else
        for i in inicio..final loop
        dbms_output.put_line(i);
        end loop;
    end if;
end;

undefine inicio;
undefine final;

-------------------------------------------
-- Queremos un bucle pidiendo un inicio y un fin
-- Mostrar los números pares comprendidos entre dicho inicio y fin

DECLARE
    inicio int;
    fin int;
BEGIN
    inicio := &inicio;
    fin := &fin;
    for i in inicio..fin loop
        if mod(i,2) = 0 then
    dbms_output.put_line(i);
        end if;
    end loop;
end;

undefine inicio;
undefine fin;

-------------------------------------------
-- CONJETURA DE COLLATZ
-- La teoría indica que cualquier número siempre llegará a ser 1 siguiendo una serie de instrucciones:
-- Si el número es par, se divide entre 2, si es impar se multiplica por 3 y sumamos 1
DECLARE
    numero int;
BEGIN
    numero := &numero;
    while numero <> 1 LOOP
        if mod(numero,2) = 0 THEN
            numero := numero/2;
        ELSE
            numero := (numero*3)+1;
        end if;    
        dbms_output.put_line(numero);
    end loop;
end;

undefine numero;

-------------------------------------------
-- Mostrar la tabla de multiplicar de un número que el usuario introduzca

DECLARE
    numero int;
BEGIN
    numero := &numero;
    for i in 1..10 loop
        dbms_output.put_line(numero || ' * ' || i || ' = ' || numero*i);
    end loop;
    dbms_output.put_line('Fin del programa');
end;

undefine numero;

-------------------------------------------
-- Quiero un programa que nos pedirá un texto, debemos recorrer dicho texto letra a letra,es decir,
-- Mostramos cada letra del texto de forma individual

DECLARE
    v_texto varchar2(50);
    v_longitud int;
    v_letra char(1);
BEGIN
    v_texto := '&texto';
    -- Un elemento en Oracle empieza en la posición 1
    v_longitud := length(v_texto);
    for i in 1..v_longitud loop
        v_letra := substr(v_texto,i,1);
        dbms_output.put_line(v_letra);
    end loop;
    dbms_output.put_line('Fin del programa');
end;

undefine texto;

-------------------------------------------
-- Un programa donde el usuario introducirá un texto numérico: 1234
-- Necesito mostrar la suma de todos los caracteres numéricos en un mensaje
-- Ejemplo: la suma de 1234 es 10 (1+2+3+4)

DECLARE
    v_texto varchar2(50);
    v_longitud int;
    v_numero char(1);
    conv_numero int;
    v_suma int;
begin
    v_texto := '&texto';
    v_suma := 0;
    v_longitud := length(v_texto);
    for i in 1..v_longitud loop
        v_numero := substr(v_texto,i,1);
        conv_numero := to_number(v_numero);
        v_suma := v_suma+conv_numero;
    end loop;
    dbms_output.put_line(v_suma);
    dbms_output.put_line('Fin del programa');
end;

-------------------------------------------








