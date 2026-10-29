*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    OperatingSystem
Library   XML
Library    String

Resource    ../resources/VGeneral.robot
Resource    ../resources/common.robot

*** Variables ***


*** Keywords ***

Abrir navegador y ingresar a la web
    Open Browser    ${urlnav}    chrome
    Maximize Browser Window
    #Sleep    5s

Iniciar sesión con credenciales válidas
    Wait Until Element Is Visible    //input[@id="user-name"]    30s
    Input Text        //input[@id="user-name"]    ${username}
    Input Text        //input[@id="password"]      ${password}
    CapturaImagenSinComentarios
    Click Element      //input[@id="login-button"]

Validar acceso exitoso al inventario
    Wait Until Location Contains    inventory.html    30s
    Wait Until Element Is Visible   //span[@class="title" and text()="Products"]    30s
    Element Should Be Visible       //span[@class="title" and text()="Products"]
    Element Should Be Visible       //div[@class="inventory_list"]
    Page Should Not Contain Element    //h3[@data-test="error"]
    CapturaImagenSinComentarios

Agregar producto al carrito
    Wait Until Element Is Visible    //div[@class="inventory_list"]    30s

    Wait Until Element Is Visible
    ...    //div[@data-test="inventory-item-name" and normalize-space(text())="${nombre_producto}"]    10s

    Click Element
    ...    //div[@data-test="inventory-item-name" and normalize-space(text())="${nombre_producto}"]/ancestor::div[@class="inventory_item"]//button[contains(@data-test,"add-to-cart")]
    CapturaImagenSinComentarios

Ir al carrito
    Go To    ${urlnav}cart.html
    Wait Until Location Contains    cart.html    10s
    Element Should Be Visible    //div[@data-test="inventory-item-name" and normalize-space(text())="${nombre_producto}"]
    Log    Producto confirmado en el carrito: ${nombre_producto}
    CapturaImagenSinComentarios

Ir al carrito sin agregar productos
    Wait Until Element Is Visible    //div[@class="inventory_list"]    30s
    Page Should Not Contain Element    //span[@data-test="shopping-cart-badge"]
    Click Element    //a[@data-test="shopping-cart-link"]
    Wait Until Location Contains    cart.html    10s
    CapturaImagenSinComentarios

Intentar proceder al checkout con carrito vacío
    Page Should Not Contain Element    //div[@data-test="inventory-item-name"]
    Log    Confirmado: el carrito no contiene productos antes de intentar el checkout.

    Element Should Be Visible    //button[@data-test="checkout"]
    Element Should Be Enabled    //button[@data-test="checkout"]
    Click Element    //button[@data-test="checkout"]
    CapturaImagenSinComentarios

    ${avanzo}=    Run Keyword And Return Status
    ...    Wait Until Location Contains    checkout-step-one.html    5s

    IF    ${avanzo}
        Log    Comportamiento detectado: el sistema PERMITE avanzar al checkout con el carrito vacío (no bloquea la acción). Se documenta como hallazgo/riesgo para el reporte.    WARN
    ELSE
        Log    Comportamiento detectado: el sistema NO permitió avanzar al checkout con el carrito vacío.
    END
    CapturaImagenSinComentarios

Eliminar producto del carrito
    Ir al carrito
    Wait Until Element Is Visible    id:remove-sauce-labs-backpack    10s
    ${eliminado}=    Set Variable    ${False}
    FOR    ${intento}    IN RANGE    3
        Run Keyword And Ignore Error    Click Element    id:remove-sauce-labs-backpack
        ${eliminado}=    Run Keyword And Return Status
        ...    Wait Until Page Does Not Contain Element    id:remove-sauce-labs-backpack    3s
        Exit For Loop If    ${eliminado}
        Run Keyword And Ignore Error    Execute Javascript    document.getElementById('remove-sauce-labs-backpack').click();
        ${eliminado}=    Run Keyword And Return Status
        ...    Wait Until Page Does Not Contain Element    id:remove-sauce-labs-backpack    3s
        Exit For Loop If    ${eliminado}
    END
    Run Keyword If    not ${eliminado}    Fail    No se pudo eliminar el producto tras varios intentos
    CapturaImagenSinComentarios

Validar producto eliminado del carrito
    Page Should Not Contain Element    id:remove-sauce-labs-backpack
    Log    Confirmado: el carrito quedó vacío tras eliminar "${nombre_producto}".
    CapturaImagenSinComentarios

Validar producto agregado al carrito
    Wait Until Element Is Visible    //span[@class="shopping_cart_badge"]    10s
    ${badge}=    Get Text    //span[@class="shopping_cart_badge"]
    Should Be Equal As Strings    ${badge}    1
    Log    Cantidad en el carrito: ${badge}
    CapturaImagenSinComentarios

Proceder al checkout con producto en el carrito
    Ir al carrito
    Wait Until Element Is Visible    id:checkout    10s
    ${avanzo}=    Set Variable    ${False}
    FOR    ${intento}    IN RANGE    3
        Run Keyword And Ignore Error    Click Element    id:checkout
        ${avanzo}=    Run Keyword And Return Status
        ...    Wait Until Location Contains    checkout-step-one.html    3s
        Exit For Loop If    ${avanzo}
        Run Keyword And Ignore Error    Execute Javascript    document.getElementById('checkout').click();
        ${avanzo}=    Run Keyword And Return Status
        ...    Wait Until Location Contains    checkout-step-one.html    3s
        Exit For Loop If    ${avanzo}
    END
    Run Keyword If    not ${avanzo}    Fail    No se pudo avanzar al checkout tras varios intentos
    CapturaImagenSinComentarios

Completar información de envío
    Wait Until Element Is Visible    //input[@data-test="firstName"]    10s
    Input Text    //input[@data-test="firstName"]    ${nombre}
    Input Text    //input[@data-test="lastName"]    ${apellido}
    Input Text    //input[@data-test="postalCode"]    ${codigo_postal}
    Log    Valores ingresados -> nombre: ${nombre} | apellido: ${apellido} | codigo_postal: ${codigo_postal}
    CapturaImagenSinComentarios

    ${avanzo}=    Set Variable    ${False}
    FOR    ${intento}    IN RANGE    3
        Run Keyword And Ignore Error    Click Element    //input[@data-test="continue"]
        ${avanzo}=    Run Keyword And Return Status
        ...    Wait Until Location Contains    checkout-step-two.html    3s
        Exit For Loop If    ${avanzo}
        ${hay_error}=    Run Keyword And Return Status
        ...    Element Should Be Visible    //h3[@data-test="error"]
        IF    ${hay_error}
            ${msg_error}=    Get Text    //h3[@data-test="error"]
            Log    ERROR EN PANTALLA: ${msg_error}    WARN
        END
        Run Keyword And Ignore Error    Execute Javascript    document.querySelector('[data-test="continue"]').click();
        ${avanzo}=    Run Keyword And Return Status
        ...    Wait Until Location Contains    checkout-step-two.html    3s
        Exit For Loop If    ${avanzo}
    END
    CapturaImagenSinComentarios
    Run Keyword If    not ${avanzo}    Fail    No se pudo avanzar a checkout-step-two tras varios intentos
    
Finalizar compra
    Wait Until Element Is Visible    //button[@data-test="finish"]    10s
    Element Should Be Visible    //div[@class="summary_total_label"]
    Click Element    //button[@data-test="finish"]
    Wait Until Location Contains    checkout-complete.html    10s
    CapturaImagenSinComentarios

Validar compra exitosa
    Wait Until Element Is Visible    //h2[@data-test="complete-header"]    10s
    Element Should Be Visible    //h2[@data-test="complete-header"]
    ${mensaje}=    Get Text    //h2[@data-test="complete-header"]
    Should Be Equal As Strings    ${mensaje}    Thank you for your order!
    Log    Compra confirmada: ${mensaje}
    CapturaImagenSinComentarios

Completar información de envío sin código postal
    Wait Until Element Is Visible    //input[@data-test="firstName"]    10s
    Input Text    //input[@data-test="firstName"]    ${nombre}
    Input Text    //input[@data-test="lastName"]    ${apellido}
    CapturaImagenSinComentarios
    Click Element    //input[@data-test="continue"]

Validar error por código postal vacío
    Wait Until Element Is Visible    //h3[@data-test="error"]    10s
    Element Should Be Visible    //h3[@data-test="error"]
    ${mensaje_error}=    Get Text    //h3[@data-test="error"]
    Log    Error mostrado: ${mensaje_error}
    Should Contain    ${mensaje_error}    Postal Code is required
    ${location}=    Get Location
    Should Not Contain    ${location}    checkout-step-two.html
    CapturaImagenSinComentarios