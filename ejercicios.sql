/* 
Debemos crear un programa para calcular el salario de una persona
El salario se cobra por número de horas y distancia
El usuario nos dará el número de horas trabajadas en una semana.
Nos indicará también el precio hora que cobra.
También pediremos la distancia en km que ha realizado.

Cada hora por encima de 36 horas semanales, le aumentaremos 2€ por cada hora.
Si la distancia es menor de 100 km, no cobrara dietas.
Si la distancia es entre 100 km y 250 km, cobrara dietas regionales de 200€.
Si la distancia es entre 250 y 500 km, cobrara dietas provinciales de 400€.
Por encima de estos datos, son dietas internacionales y cobrara 600€.
*/

DECLARE

salario int;
horas_semanales int;
distancia int;
precio_hora int;
dietas int;
salarioextra int;
horasextra int;
salariototal int;

BEGIN

horas_semanales := &horassemanales;
precio_hora := &preciohora;
distancia := &distancia;

    if horas_semanales <= 36 THEN
        salario := horas_semanales * precio_hora;
        DBMS_OUTPUT.PUT_LINE('No tiene horas extras');
    else
        salario := precio_hora * 36;
        salarioextra := (horas_semanales - 36) * (precio_hora +2);
        horasextra := horas_semanales - 36;
        DBMS_OUTPUT.PUT_LINE('Tiene horas extras');
        DBMS_OUTPUT.PUT_LINE('Horas extra: ' || horasextra);
    end if;

    if distancia < 100 THEN
        dietas := 0;
        DBMS_OUTPUT.PUT_LINE('Sin dietas');
    elsif distancia between 100 and 250 THEN
        dietas := 200;
        DBMS_OUTPUT.PUT_LINE('Dietas regionales, ' || dietas || '€');
    elsif distancia between 251 and 500 THEN
        dietas := 400;
        DBMS_OUTPUT.PUT_LINE('Dietas provinciales, ' || dietas || '€');
    ELSE
        dietas := 600;
        DBMS_OUTPUT.PUT_LINE('Dietas internacionales, ' || dietas || '€');
    end if;

salariototal := salario + salarioextra + dietas;
DBMS_OUTPUT.PUT_LINE('Cobro en dietas: ' || dietas);
DBMS_OUTPUT.PUT_LINE('Horas computadas: ' || horas_semanales);
DBMS_OUTPUT.PUT_LINE('Precio hora: ' || precio_hora);
DBMS_OUTPUT.PUT_LINE('Salario final: ' || salariototal || '€');

END;

-------------------------------------------------------------------
DECLARE

numero int;
letra char(1);
resultado int;

BEGIN

numero := &numero;
resultado := (numero - (TRUNC(numero/23) * 23));
DBMS_OUTPUT.PUT_LINE('El número introducido es: ' || numero);
    if resultado = 0 THEN
        dbms_output.put_line('T');
    elsif resultado = 1 THEN
        dbms_output.put_line('R');    
    elsif resultado = 2 THEN
        dbms_output.put_line('W');
    elsif resultado = 3 THEN
        dbms_output.put_line('A');
    elsif resultado = 4 THEN
        dbms_output.put_line('G');
    elsif resultado = 5 THEN
        dbms_output.put_line('M');
    elsif resultado = 6 THEN
        dbms_output.put_line('Y');
    elsif resultado = 7 THEN
        dbms_output.put_line('F');
    elsif resultado = 8 THEN
        dbms_output.put_line('P');
    elsif resultado = 9 THEN
        dbms_output.put_line('D');
    elsif resultado = 10 THEN
        dbms_output.put_line('X');
    elsif resultado = 11 THEN
        dbms_output.put_line('B');
    elsif resultado = 12 THEN
        dbms_output.put_line('N');                                            
    elsif resultado = 13 THEN
        dbms_output.put_line('J');
    elsif resultado = 14 THEN
        dbms_output.put_line('Z');
    elsif resultado = 15 THEN
        dbms_output.put_line('S');
    elsif resultado = 16 THEN
        dbms_output.put_line('Q');
    elsif resultado = 17 THEN
        dbms_output.put_line('V');
    elsif resultado = 18 THEN
        dbms_output.put_line('H');
    elsif resultado = 19 THEN
        dbms_output.put_line('L');
    elsif resultado = 20 THEN
        dbms_output.put_line('C');
    elsif resultado = 21 THEN
        dbms_output.put_line('K'); 
    elsif resultado = 22 THEN
        dbms_output.put_line('E');                                  
    end if;
   
end;








