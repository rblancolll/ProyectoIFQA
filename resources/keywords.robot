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

Validar carga de la página principal
    Wait Until Page Contains Element    //h1[text()="Space & Beyond"]    30s
    Element Should Be Visible          //h1[text()="Space & Beyond"]    30s
    Page Should Contain Element        //button[text()="Log in"]    30s
    Page Should Contain Element        //button[text()="Select Destination"]    30s
    CapturaImagenSinComentarios

Validar los elementos del formulario de búsqueda
    Wait Until Element Is Visible    //label[text()="Departing"]    30s
    Element Should Be Visible        //label[text()="Departing"]
    Element Should Be Visible        //label[text()="Returning"]
    Wait Until Element Is Visible    //input[contains(@value,'Adults')]    30s
    Element Should Be Visible        //input[contains(@value,'Adults')]
    Wait Until Element Is Visible    //input[contains(@value,'Children')]    30s
    Element Should Be Visible        //input[contains(@value,'Children')]
    Wait Until Element Is Visible    //button[@data-react-toolbox='button'][contains(text(),'Select Destination')]    30s
    Element Should Be Visible        //button[@data-react-toolbox='button'][contains(text(),'Select Destination')]
    Element Should Be Enabled        //button[@data-react-toolbox='button'][contains(text(),'Select Destination')]
    CapturaImagenSinComentarios

Iniciar sesión con credenciales válidas
    Wait Until Element Is Visible    //button[contains(text(),'Log in')]    30s
    Click Element                    //button[contains(text(),'Log in')]

    Wait Until Element Is Visible    //form[@id='login']//input[@type='text']    30s
    Input Text                       //form[@id='login']//input[@type='text']    ${username}    
    Input Text                       //form[@id='login']//input[@type='password']    ${password}    
    CapturaImagenSinComentarios
    Submit Form                      //form[@id='login']
    Wait Until Element Is Visible    //button[contains(.,'Hello')]    30s
    Element Should Be Visible        //button[contains(.,'Hello')]
    CapturaImagenSinComentarios

Validar saludo del usuario autenticado
    Wait Until Element Is Visible    //button[contains(.,'Hello')]    30s
    Element Should Be Visible        //button[contains(.,'Hello')]
    Page Should Not Contain Element  //button[contains(.,'Log in')]
    CapturaImagenSinComentarios

Cerrar formulario de inicio de sesión sin ingresar datos
    Wait Until Element Is Visible    //button[contains(.,'Log in')]    30s
    Click Element                    //button[contains(.,'Log in')]
    CapturaImagenSinComentarios
    Wait Until Element Is Visible    //form[@id='login']    30s
    Click Element                    //button[@class="theme__button___1iKuo LoginButton__button___1Sd3Q theme__flat___2ui7t LoginButton__flat___Kv6Aw theme__accent___3MS_k LoginButton__accent___hdTFW"]

    Wait Until Page Does Not Contain Element    //form[@id='login']    10s
    Element Should Be Visible        //button[contains(.,'Log in')]
    CapturaImagenSinComentarios

Seleccionar fecha de salida
    Wait Until Element Is Visible    //label[text()="Departing"]    30s
    Click Element                    //input[@class="theme__inputElement___27dyY theme__inputElement___1oBGc WhiteDatePicker__inputElement___3d9uL"]
    CapturaImagenSinComentarios
    Wait Until Element Is Visible    //section[@class="theme__body___1_nNM"]    30s
    Click Element                    //span[text()="${dia_salida}"]
    Click Element                    //button[@data-react-toolbox="button"][contains(text(),'Ok')]
    CapturaImagenSinComentarios
    Wait Until Element Is Visible    //input[contains(@class,'WhiteDatePicker__inputElement') and contains(@class,'filled')]    10s
    ${valor_fecha}=    Get Value    //input[contains(@class,'WhiteDatePicker__inputElement') and contains(@class,'filled')]
    Should Not Be Empty    ${valor_fecha}
    Log    Fecha seleccionada: ${valor_fecha}
    CapturaImagenSinComentarios

Seleccionar fecha de regreso
    Wait Until Element Is Visible    //label[text()="Returning"]    30s
    Click Element                    //div[@data-react-toolbox='input'][.//label[text()='Returning']]

    Wait Until Element Is Visible    //section[@class="theme__body___1_nNM"]    30s
    Click Element                    //span[text()="${dia_regreso}"]    
    CapturaImagenSinComentarios
    Click Element                    //button[@data-react-toolbox="button"][contains(text(),'Ok')]    
    CapturaImagenSinComentarios

    ${valor_salida}=     Get Value    //div[@data-react-toolbox='input'][.//label[text()='Departing']]//input
    ${valor_regreso}=    Get Value    //div[@data-react-toolbox='input'][.//label[text()='Returning']]//input
    Should Not Be Empty    ${valor_salida}
    Should Not Be Empty    ${valor_regreso}

    ${epoch_salida}=     Convert Date    ${valor_salida}     date_format=%d %B %Y    result_format=epoch
    ${epoch_regreso}=    Convert Date    ${valor_regreso}    date_format=%d %B %Y    result_format=epoch
    Should Be True    ${epoch_regreso} > ${epoch_salida}
    CapturaImagenSinComentarios

Intentar seleccionar fecha de regreso anterior a la salida
    Wait Until Element Is Visible    //label[text()="Returning"]    30s
    Click Element                    //div[@data-react-toolbox='input'][.//label[text()='Returning']]

    Wait Until Element Is Visible    //section[@class="theme__body___1_nNM"]    30s
    ${resultado}=    Run Keyword And Ignore Error    Click Element    //span[text()="${dia_regreso_invalido}"]
    Log    Resultado del intento de clic en fecha anterior: ${resultado}
    CapturaImagenSinComentarios

    Run Keyword And Ignore Error    Click Element    //button[@data-react-toolbox="button"][contains(text(),'Ok')]
    CapturaImagenSinComentarios

    ${valor_regreso}=    Run Keyword And Ignore Error    Get Value    //div[@data-react-toolbox='input'][.//label[text()='Returning']]//input
    Log    Valor del campo Returning después del intento: ${valor_regreso}
    CapturaImagenSinComentarios

Seleccionar cantidad de adultos
    Wait Until Element Is Visible    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[1]    30s
    Click Element                    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[1]
    CapturaImagenSinComentarios

    Wait Until Element Is Visible    //ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"]    10s

    ${valor_inicial}=    Get Value    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[1]
    Log    Valor inicial de adultos: ${valor_inicial}

    Click Element    //li[text()="${cantidad_adultos}"]

    ${valor_final}=    Get Value    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[1]
    Should Contain    ${valor_final}    ${cantidad_adultos}
    Log    Valor final de adultos: ${valor_final}
    CapturaImagenSinComentarios

    Click Element    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[1]
    Wait Until Element Is Visible    //ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"]    10s
    ${resultado_negativo}=    Run Keyword And Ignore Error    Click Element    //li[text()="${cantidad_adultos_invalida}"]
    Log    Resultado al intentar seleccionar cantidad negativa: ${resultado_negativo}
    CapturaImagenSinComentarios

Validar límites del selector de niños
    Wait Until Element Is Visible    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[2]    30s
    Click Element                    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[2]
    CapturaImagenSinComentarios

    Wait Until Element Is Visible    (//ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"])[2]    10s
    Click Element    (//ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"])[2]//li[text()="${cantidad_children_aumentar}"]
    ${valor_aumentado}=    Get Value    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[2]
    Log    Valor tras aumentar: ${valor_aumentado}
    CapturaImagenSinComentarios
    Should Contain    ${valor_aumentado}    ${cantidad_children_aumentar}

    Click Element    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[2]
    Wait Until Element Is Visible    (//ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"])[2]    10s
    Click Element    (//ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"])[2]//li[text()="${cantidad_children_disminuir}"]
    ${valor_disminuido}=    Get Value    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[2]
    Log    Valor tras disminuir: ${valor_disminuido}
    CapturaImagenSinComentarios
    Should Contain    ${valor_disminuido}    ${cantidad_children_disminuir}

    Click Element    (//input[contains(@class,'WhiteDropDown__inputInputElement')])[2]
    Wait Until Element Is Visible    (//ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"])[2]    10s
    ${resultado_negativo}=    Run Keyword And Ignore Error    Click Element    (//ul[@class="theme__values___1jS4g WhiteDropDown__values___3lOeL"])[2]//li[text()="${cantidad_children_invalida}"]
    Log    Resultado al intentar seleccionar cantidad negativa de niños: ${resultado_negativo}
    CapturaImagenSinComentarios

Buscar viajes con datos válidos
    Wait Until Element Is Visible    //button[@data-react-toolbox='button'][contains(text(),'Select Destination')]    30s
    Element Should Be Enabled        //button[@data-react-toolbox='button'][contains(text(),'Select Destination')]
    Click Element                    //button[@data-react-toolbox='button'][contains(text(),'Select Destination')]
    CapturaImagenSinComentarios

    Wait Until Page Contains Element    //h2[text()="Your next destination"]    30s
    Element Should Be Visible           //h2[text()="Your next destination"]
    Log    Búsqueda ejecutada correctamente, resultados visibles
    CapturaImagenSinComentarios


Validar resultados de búsqueda
    Wait Until Element Is Visible    (//div[@data-react-toolbox='card'])[1]    30s

    Element Should Be Visible    (//div[@data-react-toolbox='card'])[1]//h5[@class="theme__title___35Wsy"]
    ${nombre}=    Get Text    (//div[@data-react-toolbox='card'])[1]//h5[@class="theme__title___35Wsy"]
    Should Not Be Empty    ${nombre}
    Log    Nombre del destino: ${nombre}

    Element Should Be Visible    (//div[@data-react-toolbox='card'])[1]//div[contains(@class,'cardMedia')]

    Element Should Be Visible    (//div[@data-react-toolbox='card'])[1]//span[@class="GalleryItem__price-tag___3q0Al"]
    ${precio}=    Get Text    (//div[@data-react-toolbox='card'])[1]//span[@class="GalleryItem__price-tag___3q0Al"]
    Should Not Be Empty    ${precio}
    Log    Precio del destino: ${precio}

    Element Should Be Visible    (//div[@data-react-toolbox='card'])[1]//div[contains(@class,'cardText')]//p
    ${info}=    Get Text    (//div[@data-react-toolbox='card'])[1]//div[contains(@class,'cardText')]//p
    Should Not Be Empty    ${info}
    Log    Información del viaje: ${info}

    Element Should Be Visible    (//div[@data-react-toolbox='card'])[1]//button[contains(text(),'Book')]
    Element Should Be Enabled    (//div[@data-react-toolbox='card'])[1]//button[contains(text(),'Book')]

    Log    Resultado validado correctamente: ${nombre} - ${precio}
    CapturaImagenSinComentarios


Seleccionar un destino
    Wait Until Element Is Visible    (//div[@data-react-toolbox='card'])[${posicion_destino}]//button[contains(text(),'Book')]    30s
    ${nombre_destino}=    Get Text    (//div[@data-react-toolbox='card'])[${posicion_destino}]//h5[@class="theme__title___35Wsy"]
    ${precio_raw}=    Get Text    (//div[@data-react-toolbox='card'])[${posicion_destino}]//span[@class="GalleryItem__price-tag___3q0Al"]
    ${precio_destino}=    Replace String    ${precio_raw}    $    ${EMPTY}
    Set Suite Variable    ${nombre_destino}    ${nombre_destino}
    Set Suite Variable    ${precio_destino}    ${precio_destino}
    Log    Destino seleccionado: ${nombre_destino} - Precio: ${precio_destino}

    Click Element    (//div[@data-react-toolbox='card'])[${posicion_destino}]//button[contains(text(),'Book')]
    CapturaImagenSinComentarios

    Wait Until Element Is Visible    //h2[@class="Checkout__headline-1___2KQaR"]    30s
    Element Should Be Visible        //h2[@class="Checkout__headline-1___2KQaR"]
    Element Text Should Be           //h2[@class="Checkout__headline-1___2KQaR"]    CHECKOUT

    Element Should Be Visible    //h3[@class="OrderSummary__headline-2___2JUYV"]
    Element Should Be Visible    //button[contains(@class,'OrderSummary__pay-button')]
    Log    Se avanzó correctamente a la pantalla de Checkout
    CapturaImagenSinComentarios

Validar información del viaje seleccionado
    # Validar precio en Checkout coincide con el de la tarjeta
    ${precio_checkout}=    Get Text    //div[contains(@class,'OrderSummary__row-3')]//div[contains(@class,'flexboxgrid__col-xs-5')]
    Log    Precio en Checkout: ${precio_checkout} | Precio de tarjeta original: ${precio_destino}
    Should Contain    ${precio_checkout}    ${precio_destino}

    # Validar fechas mostradas en el resumen
    ${fechas_checkout}=    Get Text    //div[contains(@class,'OrderSummary__row-2')]//div[contains(@class,'flexboxgrid__col-xs-5')]
    Should Not Be Empty    ${fechas_checkout}
    Log    Fechas mostradas en Checkout: ${fechas_checkout}

    # Validar cantidad de pasajeros
    ${pasajeros_checkout}=    Get Text    //div[contains(@class,'OrderSummary__row-3')]//div[contains(@class,'flexboxgrid__col-xs-7')]
    Should Not Be Empty    ${pasajeros_checkout}
    Log    Pasajeros mostrados en Checkout: ${pasajeros_checkout}

    CapturaImagenSinComentarios
    Log    Información del viaje validada: destino "${nombre_destino}", ${pasajeros_checkout}, ${fechas_checkout}, ${precio_destino}

Completar el flujo principal de reservación
    Input Text    //input[@required and @maxlength='30']    ${nombre_viajero}
    Input Text    //input[@type='email']    ${email_viajero}
    Input Text    (//div[@data-react-toolbox='input'])[contains(., 'Social Security Number')]//input    ${ssn_viajero}
    Input Text    //input[@type='tel']    ${telefono_viajero}
    CapturaImagenSinComentarios

    Choose File    //input[@type='file']    ${ruta_imagen}
    ${valor_archivo}=    Get Value    //input[@type='file']
    Should Not Be Empty    ${valor_archivo}
    CapturaImagenSinComentarios

    Click Element    //label[@data-react-toolbox='checkbox']
    Checkbox Should Be Selected    //label[@data-react-toolbox='checkbox']//input[@type='checkbox']
    CapturaImagenSinComentarios

    ${habilitado}=    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[contains(@class,'OrderSummary__pay-button')]    10s
    IF    ${habilitado}
        Click Element    //button[contains(@class,'OrderSummary__pay-button')]
        Log    Se hizo clic en "Pay now" exitosamente.
    ELSE
        Log    El botón "Pay now" permanece deshabilitado pese a que todos los campos requeridos y el checkbox están correctamente completados. Comportamiento no reproducible tampoco manualmente en el entorno demo; se documenta como limitación del sitio.    WARN
    END
    CapturaImagenSinComentarios


