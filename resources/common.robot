*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library   XML
Library    String

*** Variables ***


*** Keywords ***

CapturaImagenSinComentarios
    ${nombre}=    Set Variable    evidencia-${TEST NAME}-{index}.png

    ${filename}=    Capture Page Screenshot    ${nombre}

    Should Not Be Empty
    ...    ${filename}
    ...    SeleniumLibrary no devolvió la ruta de la captura.

    Logging Evidence In Report    ${filename}