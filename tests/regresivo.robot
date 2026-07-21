*** Settings ***
Library    SeleniumLibrary
Library    ../biblioteca/control_de_variables/ControldeVariablesLibrary.py    archivoVariables=${archivoVariables}    pais=${pais}    hoja=${hoja}
Resource    ../resources/keywords.robot    

*** Variables ***
${archivoVariables}    %{archivoVariables=regresivo_v1.xlsx}
${pais}
${hoja}                 regresivo

*** Test Cases ***

TC001 - Validar carga de la página principal
    [Tags]    TC001
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Validar carga de la página principal 

TC002 - Validar los elementos del formulario de búsqueda
    [Tags]    TC002
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Validar los elementos del formulario de búsqueda

TC003 - Iniciar sesión con credenciales
    [Tags]    TC003
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas

TC004 - Validar el saludo después del inicio de sesión
    [Tags]    TC004
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Validar saludo del usuario autenticado

TC005 - Cerrar el formulario de inicio de sesión
    [Tags]    TC005
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Cerrar formulario de inicio de sesión sin ingresar datos

TC006 - Seleccionar una fecha de salida
    [Tags]    TC006
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Seleccionar fecha de salida

TC007 - Seleccionar una fecha de regreso
    [Tags]    TC007
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Seleccionar fecha de salida
    Seleccionar fecha de regreso

TC008 - Validar un rango de fechas incorrecto
    [Tags]    TC008
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Seleccionar fecha de salida
    Intentar seleccionar fecha de regreso anterior a la salida

TC009 - Cambiar la cantidad de pasajeros adultos
    [Tags]    TC009
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Seleccionar cantidad de adultos

TC010 - Validar los límites del selector de pasajeros
    [Tags]    TC010
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Validar límites del selector de niños

TC011 - Buscar viajes con datos válidos
    [Tags]    TC011
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Seleccionar fecha de salida
    Seleccionar fecha de regreso
    Seleccionar cantidad de adultos
    Buscar viajes con datos válidos

TC012 - Validar los resultados de búsqueda
    [Tags]    TC012
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Buscar viajes con datos válidos
    Validar resultados de búsqueda

TC013 - Seleccionar un destino
    [Tags]    TC013
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Buscar viajes con datos válidos
    Seleccionar un destino

TC014 - Validar la información del viaje seleccionado
    [Tags]    TC014
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Buscar viajes con datos válidos
    Seleccionar un destino
    Validar información del viaje seleccionado

TC015 - Completar el flujo principal de reservación
    [Tags]    TC015
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Seleccionar fecha de salida
    Seleccionar fecha de regreso
    Seleccionar cantidad de adultos
    Buscar viajes con datos válidos
    Seleccionar un destino
    Validar información del viaje seleccionado
    Completar el flujo principal de reservación

