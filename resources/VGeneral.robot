*** Settings ***
#Library     ControldeVariablesLibrary
Library     SeleniumLibrary
Library     OperatingSystem
Library     BuiltIn
Library     XML


*** Variables ***
# ============================================================
# CONFIGURACIÓN GENERAL DE LA AUTOMATIZACIÓN
# ============================================================

${browser}                     Chrome
${openBrowser}                 ${True}
${timeoutDefecto}              30s
${contadorMaximo}              24
${maxCaracteres}               103
${maxToSearch}                 10
${la}                          10x
${lt}                          3sP
${IniciarValidacionClienteNuevo}    True
${contadorPestaniaCasos}       ${1}


# ============================================================
# CONFIGURACIÓN PARA LA GENERACIÓN DE EVIDENCIAS
# ============================================================

${savebyTest}                  False
${savePDF}                     True
${borrarHTML}                  True
${removeScreenImages}          False

${release}                     1
${lenguajeSistema}             ${EMPTY}
${nombreDocEvidencia}          ${EMPTY}

${proyecto}                    Proyecto de aprendizaje
${titulo}                      Evidencias qa
${subTitulo}                   Activacion: DEMO DE PRUEBA IF 2026

${rutaLog}                     ${LOG FILE}
${rutaReporte}                 ${REPORT FILE}
${rutaArchivoBase}             Encabezado${/}encabezado.html
${formatoFecha}                _%y%m%d-%H%M%S

${textoEncabezado}             Evidencia de Pruebas
${pathLogo}                    Resource${/}Logo${/}Logo.png
${autor}                       Estudiante
${colorFooter}                 gray

${ImagenID_TC}                 ${EMPTY}
${EjecucionID_TC}              ${EMPTY}

${longitudFecha}               14
${extensionContrato}           .pdf
${eliminarContrato}            False


# ============================================================
# ENCABEZADO DEL PDF
# ============================================================

${tituloPDF}                   <center><h1><b><font color\="black">${titulo}</font></b></h1></center>

${subtituloPDF}                <center><h2><b><font color\="black">${subTitulo}</font></b></h2></center>

${descripcionPDF}              <section>
...                            <p>
...                            País: {pa}
...                            &nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;
...                            Hoja (Excel): {ho}
...                            &nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;
...                            Fecha: {fe}
...                            </p>
...                            </section>

${textoEncabezadoPDF}          ${tituloPDF}
...                            ${subtituloPDF}
...                            <p>&nbsp;</p>
...                            ${descripcionPDF}
...                            <p>&nbsp;</p>


# ============================================================
# RESUMEN DEL PDF
# ============================================================

${resumenPDF}                  <center><h3><b><font color\="black">Resumen</font></b></h3></center>
...                            ${bodyResumenPDF}

${tablaResumenPDF}             <center>
...                            <table width\="70%">
...                            <thead>
...                            <tr>
...                            <th width\="10%">#</th>
...                            <th width\="30%">Test</th>
...                            <th width\="30%">Tiempo</th>
...                            <th width\="30%">Estado</th>
...                            </tr>
...                            </thead>
...                            <tbody>

${tdTablaResumenPDF}           <tr>
...                            <td align\="center">{no}</td>
...                            <td align\="center">{id}</td>
...                            <td align\="center">{ti}</td>
...                            <td align\="center">
...                            <font color\="{col}">{st}</font>
...                            </td>
...                            </tr>

${tablaResumenBodyPDF}         ${EMPTY}

${tablaResumenEndPDF}          </tbody>
...                            </table>
...                            </center>

${bodyResumenPDF}              ${tablaResumenPDF}
...                            {br}
...                            ${tablaResumenEndPDF}


# ============================================================
# PRIMERA PÁGINA DEL PDF
# ============================================================

${presentacionEvidPDF}         ${textoEncabezadoPDF}
...                            ${resumenPDF}


# ============================================================
# CONTENIDO DE LAS EVIDENCIAS
# ============================================================

@{bodyHTML2}

${resultBody}                  <h4 align\="left">
...                            <font color\="black">
...                            <u>Resultado</u>
...                            </font>
...                            </h4>
...                            <section>
...                            <font color\="black">
...                            <p>Documentación: {doc}</p>
...                            <p>Hora: {tim}</p>
...                            <p>
...                            <b>
...                            Estado:
...                            <font color\="{col}">{res}</font>
...                            </b>
...                            </p>
...                            <p>Mensaje final: {mes}</p>
...                            <p>&nbsp;</p>
...                            </font>
...                            </section>

${colorFail}                   red
${colorPass}                   \#00A000
${tmpFunct}                    0
