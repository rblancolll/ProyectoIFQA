*** Settings ***
Library    SeleniumLibrary
Library    ../biblioteca/control_de_variables/ControldeVariablesLibrary.py    archivoVariables=${archivoVariables}    pais=${pais}    hoja=${hoja}
Resource    ../resources/keywords.robot    

*** Variables ***
${archivoVariables}    %{archivoVariables=regresivo_v1.xlsx}
${pais}
${hoja}                 regresivo

*** Test Cases ***

TC001 - Login exitoso
    [Tags]    TC001    login    positivo
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Validar acceso exitoso al inventario

TC002 - Agregar producto al carrito
    [Tags]    TC002    carrito    positivo
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Agregar producto al carrito
    Validar producto agregado al carrito

TC003 - Intentar proceder al checkout con el carrito vacío
    [Tags]    TC003    carrito    negativo
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Ir al carrito sin agregar productos
    Intentar proceder al checkout con carrito vacío

TC004 - Eliminar producto del carrito
    [Tags]    TC004    carrito    positivo
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Agregar producto al carrito
    Validar producto agregado al carrito
    Eliminar producto del carrito
    Validar producto eliminado del carrito

TC005 - Checkout compra exitosa
    [Tags]    TC005    checkout    positivo
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Agregar producto al carrito
    Validar producto agregado al carrito
    Proceder al checkout con producto en el carrito
    Completar información de envío
    Finalizar compra
    Validar compra exitosa

TC006 - Checkout código postal vacío
    [Tags]    TC006    checkout    negativo
    [Teardown]    Close Browser
    Abrir navegador y ingresar a la web
    Iniciar sesión con credenciales válidas
    Agregar producto al carrito
    Validar producto agregado al carrito
    Proceder al checkout con producto en el carrito
    Completar información de envío sin código postal
    Validar error por código postal vacío