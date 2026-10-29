# Proyecto QA - Automatización Web SauceDemo

## Descripción de la página seleccionada y alcance automatizado

Se seleccionó **SauceDemo** (https://www.saucedemo.com/), sitio público de demostración diseñado específicamente para práctica de automatización de pruebas. No requiere pagos reales, no afecta datos de terceros y no depende de información privada, cumpliendo con los criterios de la Sección 0 de la prueba.

El alcance automatizado cubre **3 funcionalidades principales** del sitio:

- **Login**: acceso al sistema con credenciales válidas.
- **Carrito de compras**: agregar y eliminar productos, validar comportamiento con carrito vacío.
- **Checkout**: flujo completo de compra exitosa y validación de campo obligatorio (código postal).

## Tecnologías utilizadas

- **Robot Framework** — framework de automatización principal.
- **SeleniumLibrary** — interacción con el navegador web (Chrome).
- **Python** — lenguaje base de Robot Framework y de la librería personalizada de variables.
- **Librería personalizada** (`ControldeVariablesLibrary.py`) — lectura de datos de prueba desde archivo Excel.
- **Excel (regresivo_v1.xlsx)** — fuente de datos de prueba (usuarios, productos, datos de checkout).

## Pasos de instalación y dependencias

1. Tener instalado **Python 3.x**.
2. Instalar todas las dependencias del proyecto desde `requirements.txt`:
   ```
   pip install -r requirements.txt
   ```
   Este archivo incluye, entre otras, las librerías principales del proyecto:
   - `robotframework==7.4.2`
   - `robotframework-seleniumlibrary==6.0.0`
   - `robotframework-pythonlibcore==4.6.0`
   - `selenium==4.7.2`
   - `openpyxl==3.0.10` (lectura del archivo Excel de variables)
3. Instalar el WebDriver de Chrome correspondiente a la versión del navegador instalado.
4. Verificar que el archivo de datos `variables/regresivo_v1.xlsx` esté ubicado en la ruta esperada por el proyecto.

## Comando o comandos de ejecución

Ejecutar la suite completa desde la raíz del proyecto, generando resultados (con timestamp) en la carpeta `result`:

```
robot -d result -T -v hoja:regresivo -v archivoVariables:variables/regresivo_v1.xlsx ./tests/regresivo.robot
```

Parámetros utilizados:
- `-d result` — carpeta de salida donde se generan `log.html`, `report.html` y `output.xml`.
- `-T` — genera también un timestamp en los nombres de los archivos de salida, útil para conservar el historial de corridas.
- `-v hoja:regresivo` — indica a la librería de variables qué hoja del Excel leer.
- `-v archivoVariables:variables/regresivo_v1.xlsx` — indica la ruta del archivo Excel con los datos de prueba.

## Listado breve de escenarios automatizados

| TC | Nombre | Funcionalidad | Tipo |
|----|--------|----------------|------|
| TC001 | Login exitoso | Login | Positivo |
| TC002 | Agregar producto al carrito | Carrito | Positivo |
| TC003 | Intentar proceder al checkout con el carrito vacío | Carrito | Negativo |
| TC004 | Eliminar producto del carrito | Carrito | Positivo |
| TC005 | Checkout - compra exitosa | Checkout | Positivo |
| TC006 | Checkout - código postal vacío | Checkout | Negativo |

**Cobertura:** 6 escenarios ejecutables, 4 positivos, 2 negativos, 3 funcionalidades distintas (Login, Carrito, Checkout).

## Explicación de la estructura del proyecto

```
ProyectoQA/
|-- tests/
|   `-- regresivo.robot        # Casos de prueba (TC001-TC006)
|-- resources/
|   |-- keywords.robot         # Keywords reutilizables (login, carrito, checkout)
|   |-- VGeneral.robot
|   `-- common.robot           # Keyword CapturaImagenSinComentarios
|-- biblioteca/
|   `-- control_de_variables/
|       `-- ControldeVariablesLibrary.py   # Librería Python de lectura de Excel
|-- variables/
|   `-- regresivo_v1.xlsx      # Datos de prueba (usuarios, productos, datos de checkout)
|-- result/                    # Reportes generados (log.html, report.html, output.xml)
|-- requirements.txt           # Dependencias del proyecto
`-- README.md
```

**Separación de responsabilidades:**
- Los **Test Cases** (`regresivo.robot`) contienen únicamente la secuencia de llamadas a keywords, sin lógica de interacción directa con el navegador.
- Los **Keywords** (`keywords.robot`) concentran toda la lógica reutilizable: navegación, clics, validaciones y esperas.
- Las **variables de datos** (usuario, contraseña, producto, datos de envío) se gestionan por fuera del código, en el archivo Excel, permitiendo reutilizar los mismos keywords con distintos datos sin modificar el código.

## Consideraciones, limitaciones o decisiones técnicas relevantes

- **Navegación al carrito mediante `Go To` en lugar de clic en el ícono**: se detectó que el clic sobre el ícono del carrito (`shopping-cart-link`) era intermitente — a veces no disparaba la navegación debido a timing de renderizado de la SPA. Se optó por navegar directamente vía `Go To ${urlnav}cart.html`, lo cual resultó mucho más estable y rápido que depender del clic.

- **Patrón de reintento con fallback JavaScript en botones críticos** (`checkout`, `remove`, `continue`): para los clics de navegación que seguían siendo intermitentes incluso con esperas explícitas, se implementó un patrón de hasta 3 reintentos, alternando entre `Click Element` (Selenium) y un clic forzado vía `Execute Javascript`. Esto documenta un hallazgo real de sincronización de la aplicación bajo prueba y demuestra manejo responsable de condiciones inestables sin recurrir a `Sleep` fijo.

- **TC003 - comportamiento documentado, no bloqueado**: en SauceDemo, el botón "Checkout" del carrito vacío **no se bloquea** (a diferencia de otros sitios similares que sí impiden avanzar). El test valida y documenta este comportamiento como un hallazgo/riesgo mediante un `WARN` en el log, en lugar de forzar una aserción de fallo, ya que es el comportamiento real observado del sistema.

- **Datos de checkout gestionados por variables, no hardcodeados en los keywords**: `${nombre}`, `${apellido}` y `${codigo_postal}` se leen desde el Excel por fila de test case, permitiendo que TC005 (compra exitosa) y TC006 (código postal vacío) reutilicen el mismo keyword `Completar información de envío` con distintos datos según el escenario.

- **Uso de esperas explícitas en lugar de `Sleep`**: se utilizaron `Wait Until Element Is Visible`, `Wait Until Element Is Enabled` y `Wait Until Location Contains` en todos los puntos de sincronización crítica, evitando esperas fijas que ralenticen la ejecución o generen falsos negativos.
