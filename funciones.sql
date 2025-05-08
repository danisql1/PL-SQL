-- Realizar una función para sumar dos números
create or replace function f_sumar_numeros
(p_numero1 number, p_numero2 number)
return number
as
    v_suma number;
begin
    v_suma := nvl(p_numero1, 0)+ nvl(p_numero2, 0); -- NVL hace que si hay un nulo en la suma, devuelva 0 en este caso
    -- SIEMPRE UN RETURN
    return v_suma;
end;
-- Llamada con código PL/SQL
DECLARE
    v_resultado number;
BEGIN
    v_resultado := F_SUMAR_NUMEROS(22,55);
    dbms_output.put_line('La suma es ' || v_resultado);
end;    
-- Llamada con SELECT
select F_SUMAR_NUMEROS(22,99) as SUMA from dual;
select F_SUMAR_NUMEROS(salario,comision) as TOTAL from emp;

-- Función para saber el número de personas de un oficio
create or replace function num_personas_oficio
(p_oficio emp.oficio%type)
return NUMBER
AS
    v_personas int;
BEGIN
    select count(emp_no) into v_personas from emp where lower(oficio) = lower(p_oficio);
    return v_personas;
end;
-- Llamada a la función
select NUM_PERSONAS_OFICIO('analista') as PERSONAS from dual;

-- Función para devolver el mayor de dos números
create or replace FUNCTION num_mayor
(p_numero1 number, p_numero2 number)
return NUMBER
AS
    v_mayor number;
BEGIN
    if p_numero1 > p_numero2 THEN
        v_mayor := p_numero1;
    ELSE
        v_mayor := p_numero2;
    end if;
    return v_mayor;
end;
-- Llamada a la función
select num_mayor(10,55) as MAYOR from dual;

-- Función para devolver el mayor de tres números sin IF.
-- Buscar una función de Oracle que nos devuelva el mayor
create or replace FUNCTION mayor_tres_numeros
(p_numero1 number, p_numero2 number, p_numero3 number)
return NUMBER
AS  
    v_mayor number;
BEGIN
    v_mayor := greatest(p_numero1, p_numero2, p_numero3);
    return v_mayor;
end;
-- Llamada a la función
select mayor_tres_numeros(5,9,12) as MAYOR from dual;

-- Tenemos los parámetros por defecto dentro de las funciones
select 100 * 1.21 as iva from dual;
select 100 * 1.18 as iva from dual;
select importe, iva(importe) as iva from productos;
select importe, iva(importe, 21) as iva from productos;

create or replace function calcular_iva
(p_precio number, p_iva number := 1.18)
return NUMBER
AS
BEGIN
    return p_precio * p_iva;
end;
-- Llamada a la función
select calcular_iva(100) as iva from dual;
select calcular_iva(100,1.21) as iva from dual;


