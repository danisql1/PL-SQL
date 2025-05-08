-- Debemos comprobar si un número es positivo o negativo
DECLARE
    v_numero int;
BEGIN
    v_numero := &numero;
    if (v_numero >= 0) THEN
        dbms_output.put_line(v_numero || ' es positivo');
    ELSE
        dbms_output.put_line(v_numero || ' es negativo');
    end if;
    dbms_output.put_line('Fin de programa');
end;
undefine numero;

-------------------------------------

DECLARE
    v_numero int;
BEGIN
    v_numero := &numero;
    if (v_numero > 0) THEN
        dbms_output.put_line(v_numero || ' es positivo');
    elsif (v_numero = 0) THEN
        dbms_output.put_line(v_numero || ' es cero');
    ELSE
        dbms_output.put_line(v_numero || ' es negativo');        
    end if;
    dbms_output.put_line('Fin de programa');
end;
undefine numero;

-------------------------------------

DECLARE
    v_numero int;
BEGIN
    v_numero := &numero;
    if (v_numero = 1) THEN
        dbms_output.put_line('Primavera');
    elsif (v_numero = 2) THEN
        dbms_output.put_line('Verano');
    elsif (v_numero = 3) THEN
        dbms_output.put_line('Otoño');
    elsif (v_numero = 4) THEN
        dbms_output.put_line('Invierno');            
    else
        dbms_output.put_line('Mal. Introduce un número del 1 al 4');
    end if;
    dbms_output.put_line('Fin del programa');
end;
undefine numero;

-------------------------------------

DECLARE
    v_num1 int;
    v_num2 int;
BEGIN
    v_num1 := &num1;
    v_num2 := &num2;
    if (v_num1 > v_num2) THEN
        dbms_output.put_line(v_num1 || ' es mayor que ' || v_num2);
    elsif (v_num1 < v_num2) THEN
        dbms_output.put_line(v_num1 || ' es menor que ' || v_num2);
    else 
        dbms_output.put_line(v_num1 || ' es igual que ' || v_num2);
    end if;
    dbms_output.put_line('Fin del programa');
end;
undefine num1;
undefine num2;

-------------------------------------
-- Pedir un número al usuario e indicar si es par o impar

DECLARE
    v_numero int;
BEGIN
    v_numero := &numero;
    if (mod(v_numero,2) = 0) THEN
        dbms_output.put_line(v_numero || ' es par');
    ELSE
        dbms_output.put_line(v_numero || ' es impar');
    end if;
    dbms_output.put_line('Fin del programa');        
END;
undefine numero;

-------------------------------------
-- Por supuesto, podemos utilizar cualquier operador, tanto de comparación como relacional en nuestros códigos

-- Pedimos una letra al usuario. Si la letra es una vocal, pintamos vocal, si no, consonante

DECLARE
    v_letra char(1);
BEGIN
    v_letra := lower('&letra'); 
    if (v_letra = 'a' or v_letra = 'e' or v_letra = 'i' or v_letra = 'o' or v_letra = 'u') THEN
        dbms_output.put_line('Es una vocal');
    ELSE
        dbms_output.put_line('Es una consonante');
    end if;
    dbms_output.put_line('Fin del programa');
end;
undefine letra;

-------------------------------------
-- Pedir 3 números al usuario. Debemos mostrar el mayor de ellos y el menor 

DECLARE
    v_num1 int;
    v_num2 int;
    v_num3 int;
    v_mayor int;
    v_menor int;
    v_intermedio int;
BEGIN
    v_num1 := &num1;
    v_num2 := &num2;
    v_num3 := &num3;
    if (v_num1 >= v_num2 and v_num1 >= v_num3) THEN
        v_mayor := v_num1;
    elsif (v_num2 >= v_num1 and v_num2 >= v_num3) THEN
        v_mayor := v_num2;
    else
        v_mayor := v_num3;           
    end if;
    if (v_num1 <= v_num2 and v_num1 <= v_num3) THEN
        v_menor := v_num1;
    elsif (v_num2 <= v_num1 and v_num2 <= v_num3) THEN
        v_menor := v_num2;
    else
        v_menor := v_num3;
    end if;
    dbms_output.put_line('Mayor: ' || v_mayor);
    dbms_output.put_line('Menor: ' || v_menor);            
    dbms_output.put_line('Fin del programa');
END;
undefine num1;
undefine num2;
undefine num3;

-------------------------------------
-- Pedir 3 números al usuario. Debemos mostrar el mayor de ellos y el menor y el intermedio

DECLARE
    v_num1 int;
    v_num2 int;
    v_num3 int;
    v_mayor int;
    v_menor int;
    v_intermedio int;
    v_suma int;
BEGIN
    v_num1 := &num1;
    v_num2 := &num2;
    v_num3 := &num3;
    if (v_num1 >= v_num2 and v_num1 >= v_num3) THEN
        v_mayor := v_num1;
    elsif (v_num2 >= v_num1 and v_num2 >= v_num3) THEN
        v_mayor := v_num2;
    else
        v_mayor := v_num3;           
    end if;
    if (v_num1 <= v_num2 and v_num1 <= v_num3) THEN
        v_menor := v_num1;
    elsif (v_num2 <= v_num1 and v_num2 <= v_num3) THEN
        v_menor := v_num2;
    else
        v_menor := v_num3;
    end if;
    v_suma := v_num1 + v_num2 + v_num3;
    v_intermedio := v_suma - v_mayor - v_menor;
    dbms_output.put_line('Mayor: ' || v_mayor);
    dbms_output.put_line('Menor: ' || v_menor);
    dbms_output.put_line('Intermedio: ' || v_intermedio);            
    dbms_output.put_line('Fin del programa');
END;
undefine num1;
undefine num2;
undefine num3;

















