# Estructura del template de cotización en PDF
El template de cotización en PDF debe estar estructurado de manera clara y profesional, siguiendo el orden lógico de la información. A continuación se detalla la estructura recomendada:

### ## 1. Encabezado y Datos de la Empresa 🏢
Esta sección contiene la información de tu empresa. Debería ser configurable o fija en el template.

* [cite_start]**Logo de la empresa:** Imagen del logo "EXPE".
* [cite_start]**Nombre de la empresa:** "EXPERTOS EN PROYECTOS ELECTRICOS".
* [cite_start]**Slogan:** "INGENIERIA APLICADA EN OBRA ELECTRICA".
* [cite_start]**Nombre del responsable:** JAVIER PEÑA BETANCOURT.
* [cite_start]**RFC de la empresa:** `PEBJ950509FZ1`.
* [cite_start]**Dirección de la empresa:** `IGNACIO ALLENDE #43B, BADEBA, NAYARIT`.
* [cite_start]**Correo de contacto:** `constructora.expe@gmail.com`.
* [cite_start]**Teléfonos de contacto:** `(322) 370-8429, (311) 270-9666`.

***

### ## 2. Datos del Cliente y Proyecto 👤
Información específica de la cotización, extraída principalmente de los modelos `Client` y `Project`.

* [cite_start]**Cliente:** `client.razon_social` (Ej: GALLARDO MEZA LUCIA).
* **Teléfono del Cliente:** `client.contacto_telefono`.
* [cite_start]**Número de Servicio:** `project.folio` o un campo nuevo (Ej: 475180700488).
* [cite_start]**Nombre del Proyecto:** `project.nombre` (Ej: FOTOVOLTAICO).
* [cite_start]**Capacidad del Proyecto:** Un campo nuevo en `Project` (Ej: 540 KwH/M).
* [cite_start]**Fecha de Emisión:** `quotation.fecha_emision` (formato DD/MM/AAAA).

***

### ## 3. Párrafo de Introducción 📄
Texto que describe el propósito de la cotización. El tipo de sistema debe ser dinámico.

* [cite_start]**Texto fijo:** "POR MEDIO DE ESTE CONDUCTO LE ENVIÓ UN AFECTUOSO SALUDO Y A CONTINUACIÓN LE DESCRIBO EL COSTO POR EL SUMINISTRO Y CONEXIÓN DE MATERIAL ELÉCTRICO NECESARIO PARA LA INSTALACION DE UN SISTEMA DE GENERACION TIPO".
* [cite_start]**Campo dinámico:** `project.tipo_proyecto` (Ej: SOLAR).

***

### ## 4. Tabla de Conceptos 📋
Esta es la sección principal y se debe generar iterando sobre los `quotation_items` asociados a la `quotation`.

* [cite_start]**Columnas requeridas:** Partida (índice del ítem + 1), Concepto (`item.descripcion`), Cantidad (`item.cantidad`), Unidad (`item.unidad`), P/U (`item.precio_unitario`), Importe (`item.importe`).
* [cite_start]**Lógica:** Se debe crear un ciclo que recorra cada `quotation_item` y pinte una fila en la tabla.

***

### ## 5. Totales de la Cotización 💰
Sección al final de la tabla de conceptos con los cálculos finales.

* [cite_start]**Subtotal:** `quotation.subtotal`.
* [cite_start]**IVA (16%):** `quotation.impuestos`.
* [cite_start]**Total:** `quotation.total`.

***

### ## 6. Consideraciones (Términos y Condiciones) ✅
Lista de las condiciones del servicio. Se puede almacenar en `quotation.terminos_condiciones`.

* [cite_start]**Forma de pago:** 50% anticipo y 50% financiamiento.
* [cite_start]**Tiempo de instalación:** 3 a 5 días a partir del anticipo.
* [cite_start]**Vigencia de la cotización:** 2 días, precios sujetos al tipo de cambio del dólar.
* [cite_start]**Garantía de módulos:** 10 años al 80% de su potencia.
* [cite_start]**Mantenimiento gratuito:** 2 meses de monitoreo y mantenimiento.
* [cite_start]**Cálculo de pérdidas:** Elaborado con 20% de pérdidas normales y 10% específicas.
* [cite_start]**Revisión de instalaciones:** Se revisan las instalaciones del cliente antes de iniciar.
* [cite_start]**Gestión de trámites:** La empresa se encarga de los trámites necesarios.

***

### ## 7. Exclusiones (Lo que no incluye) ❌
Lista de elementos que no cubre la cotización.

* [cite_start]Cualquier material no listado se cotizará por separado.
* [cite_start]No incluye obra eléctrica en interiores.

***

### ## 8. Resumen de Proyecto y Financiamiento 💳
Esta es una sección clave en la segunda página, que resume el pago y presenta los planes.

#### **Tabla Resumen**
* **Número de Paneles:** Campo nuevo en `Project` o `Quotation`. (Ej: 5)[cite_start].
* **Estructura Adicional:** Campo nuevo en `Project` o `Quotation`. (Ej: NO APLICA)[cite_start].
* [cite_start]**Total del Proyecto:** `quotation.total`.
* [cite_start]**Pago Inicial (50%):** `quotation.total / 2`.
* [cite_start]**Monto a Financiar (50%):** `quotation.total / 2`.

#### **Planes de Financiamiento**
* [cite_start]**Lógica:** Tu aplicación deberá tener la capacidad de calcular y generar los planes de pago (3, 6, y 8 meses) basados en el monto a financiar.
* [cite_start]**Datos por plan:** Para cada plan, el template necesita recibir una lista de mensualidades con los siguientes datos: Mes, Saldo Inicial, Pago a capital, Interés, IVA de interés y Cuota Mensual.

***

### ## 9. Código QR 📱
* **Generación:** Usar la gema `rqrcode` para generar un código QR.
* [cite_start]**Contenido:** El QR puede apuntar a la URL de la cotización en la aplicación, al sitio web de la empresa (`https://constructoraexpe.com/`), o contener un resumen de los datos del cliente y el total.

***

### ## 10. Pie de Página 👣
Información final de contacto.

* [cite_start]**Nombre de la empresa:** "EXPERTOS EN PROYECTOS ELECTRICOS".
* [cite_start]**Teléfono:** `(322) 370-8429`.
* [cite_start]**Sitio Web:** `https://constructoraexpe.com/`.
* [cite_start]**Redes Sociales:** Logo e información de Facebook (`Constructora EXPE`).