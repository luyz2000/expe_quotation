# Expe Ingeniería Aplicada en Obra Eléctrica.

## Objetivo del proyecto
Necesitamos crear una aplicación web para el manejo completo de cotizaciones de una empresa de construcción e ingeniería aplicada en obra eléctrica.

## La infraestructura del sistema debe estar en:

* Lenguaje de programación: ruby 3.3.9
* Framework: Rails 8.0.3
* Css Framework: ultima version estable de bootstrap
* iconos: Bootstrap Icons
* apexcharts para graficas y estadisticas
* Sistema de plantillas: haml
* Motor de base de datos: Postgresql
* Javascript: utilizacion de stimulus y turbo
* Control de versiones: Git y GitHub

## Gemas sugeridas
* Devise para autenticacion de usuarios
* cancancan para autorizacion y manejo de roles
* rqrcode para generacion de codigos QR
* Prawn para generacion de reportes en PDF
* Pagy  para paginacion
* Ransack para busqueda y filtrado avanzado
* CarrierWave para manejo de archivos
* Sidekiq para manejo de tareas en segundo plano
* RSpec, FactoryBot y Faker para pruebas unitarias y de integracion
* Rubocop para estandarizacion de codigo
* puma como servidor de aplicaciones
* redis para manejo de cache y sesiones
* rails credentials para manejo seguro de credenciales
* Annotate para documentacion de modelos
* paper_trail para auditoria de cambios en modelos
* hamlit para soporte de HAML

## Requerimientos funcionales
1. Autenticacion de usuarios con roles (administrador, vendedor, ingeniero)
2. CRUD completo para gestionar usuarios, proyectos, clientes, cotizaciones, conceptos de cotizacion, materiales (para autocompletado), servicios (para autocompletado).
3. Generacion de reportes en PDF de las cotizaciones
4. Busqueda y filtrado avanzado de proyectos, clientes y cotizaciones
5. Paginacion de listas largas limite por pagina de 10 resultados
6. Sistema de auditoria para registrar cambios en clientes, proyectos, cotizaciones y conceptos de cotizacion
7. Interfaz de usuario responsiva y amigable utilizando Bootstrap
8. Validaciones y manejo de errores adecuado en formularios
9. Modo oscuro para la interfaz de usuario
10. Sistema de notificaciones por correo electronico para eventos importantes (nueva cotizacion, cotizacion aprobada, proyecto completado)
11. Dashboard con estadisticas clave (total de cotizaciones, proyectos en progreso, ingresos mensuales)
12. Subida y gestion de archivos relacionados con proyectos y cotizaciones (planos, contratos, etc.)

# Estructura de datos

### 1. Usuarios (`users`)
- nombre
- last_name
- email
- contraseña
- rol (admin, salesperson, engineer) # como enumerador de rails
- estado (activo/inactivo)

### 2. Clientes (`clients`)
- razon_social
- rfc
- contacto_nombre
- contacto_email
- contacto_telefono
- direccion
- ciudad
- estado
- tipo_cliente (residencial, industrial, gubernamental) # como enumerador de rails

### 3. Proyectos (`projects`)
- folio
- nombre
- descripcion
- cliente_id → (FK: clients.id)
- responsible_id → (FK: users.id)
- ubicacion
- tipo_proyecto (construccion, instalacion, modificacion, etc.) # como enumerador de rails
- estatus (planificado, aceptado, en_progreso, completado, cancelado) # como enumerador de rails
- fecha_inicio
- fecha_fin_estimada
- fecha_fin_real

### 4. Cotizaciones (`quotations`)
- numero_cotizacion
- proyecto_id → (FK: projects.id)
- cliente_id → (FK: clients.id)
- salesperson_id → (FK: users.id)
- tipo_proyecto (media_tension, baja_tension, automatizacion, etc.) # como enumerador de rails
- fecha_emision
- fecha_vencimiento
- subtotal
- total
- estado (borrador, enviada, aprobada, rechazada, cancelada) # como enumerador de rails
- terminos_condiciones
- notas
- numero_de_revision

### 5. Conceptos de cotización (`quotation_items`)
- cotizacion_id → (FK: quotations.id)
- tipo (material, servicio)
- descripcion
- cantidad
- unidad (ej. pieza, metro, hora) # como enumerador de rails
- precio_unitario
- importe
- tipo de moneda (MXN, USD) # como enumerador de rails

### 6. Materiales (materials)
- codigo
- titulo
- descripcion
- unidad (pieza, metro, kg, etc.) # como enumerador de rails
- precio_costo
- precio_publico
- categoria (electrico, mecanico, herramientas, etc.) # como enumerador de rails

### 7. Servicios (services)
- codigo
- titulo
- descripcion
- unidad (hora, servicio, jornada, etc.) # como enumerador de rails
- precio_sugerido
- precio_publico
- categoria (instalacion, mantenimiento, consultoria, etc.) # como enumerador de rails

### 8. Logs de Auditoría (`audit_logs`)
- user_id → (FK: users.id)
- auditable_type (nombre del modelo auditado)
- auditable_id (id del registro auditado)
- action (create, update, delete)
- changes_before (JSON con estado anterior)
- changes_after (JSON con estado posterior)

Perfecto. A continuación tienes el documento revisado, corregido y ajustado **sin agregar nuevos roles**, cuidando coherencia, jerarquía y formato uniforme en Markdown:

---

# 🧩 Roles, Responsabilidades y Permisos

### Aplicación de cotizaciones para empresa de ingeniería eléctrica


## 👥 Roles principales

| Rol               | Descripción                                                                                              | Nivel de acceso |
| ----------------- | -------------------------------------------------------------------------------------------------------- | --------------- |
| **Administrador** | Control total del sistema: gestiona usuarios, proyectos, materiales, proveedores y reportes financieros. | Alto            |
| **Salesperson**      | Gestiona clientes, cotizaciones y seguimiento de proyectos asignados.                                    | Medio           |
| **Engineer**     | Supervisa la ejecución técnica de los proyectos y participa en la elaboración de cotizaciones.           | Medio           |

---

## ⚙️ Relaciones y jerarquía de acceso

| Entidad                     | Acceso **Administrador**                  | Acceso **Salesperson**                                    | Acceso **Engineer**                                |
| --------------------------- | ----------------------------------------- | ------------------------------------------------------ | --------------------------------------------------- |
| **Usuarios**                | Crear, editar, activar/inactivar usuarios | Ver y editar su propio perfil                          | Ver y editar su propio perfil                       |
| **Clientes**                | CRUD completo                             | Crear, ver y editar solo sus clientes                  | Ver clientes asignados                              |
| **Proyectos**               | CRUD completo y asignar responsables      | Crear (si es responsable) y ver proyectos asignados    | Crear (si es responsable) y ver proyectos asignados |
| **Cotizaciones**            | CRUD completo, aprobar o rechazar         | Crear, editar, enviar al cliente y enviar a aprobación | Crear, editar y enviar a aprobación                 |
| **Conceptos de cotización** | CRUD completo                             | Crear, editar y eliminar dentro de sus cotizaciones    | Crear, editar y eliminar dentro de sus cotizaciones |
| **Materiales / Servicios**  | CRUD completo                             | Ver, crear y editar (solo para uso en cotizaciones)    | Ver, crear y editar (solo para uso en cotizaciones) |
| **Reportes / Dashboard**    | Ver reportes globales                     | Ver reportes propios (ventas, cotizaciones)            | Ver reportes propios (proyectos, cotizaciones)      |

---

## 🔒 Acciones por rol

### 🧱 Administrador

**Responsabilidades:**

* Mantener la integridad y seguridad del sistema.
* Aprobar o rechazar cotizaciones antes del envío al cliente.
* Administrar precios, catálogos, márgenes y proveedores.
* Supervisar desempeño de vendedores e ingenieros.

| Entidad                              | Acciones                                              |
| ------------------------------------ | ----------------------------------------------------- |
| Usuarios                             | `manage` (crear, editar, eliminar, activar/inactivar) |
| Clientes                             | `manage`                                              |
| Proyectos                            | `manage`                                              |
| Cotizaciones                         | `manage`, `approve`, `reject`                         |
| Conceptos de cotización              | `manage`                                              |
| Materiales / Servicios / Proveedores | `manage`                                              |
| Archivos / Planos                    | `manage`                                              |
| Actividades                          | `manage`                                              |
| Configuración / Sistema              | `manage`                                              |
| Reportes / Dashboard                 | `view_all`                                            |

---

### 💼 Vendedor

**Responsabilidades:**

* Capturar y mantener actualizada la información de sus clientes.
* Generar cotizaciones técnicas y económicas.
* Dar seguimiento a cotizaciones y proyectos asignados.

| Entidad                 | Acciones                                                |
| ----------------------- | ------------------------------------------------------- |
| Usuarios                | `read_self`, `update_self`                              |
| Clientes                | `create`, `read_own`, `update_own`                      |
| Proyectos               | `create`, `read_own`, `update_own`                      |
| Cotizaciones            | `create`, `read_own`, `update_own`, `send_for_approval` |
| Conceptos de cotización | `create`, `update_own`, `delete_own`                    |
| Archivos / Planos       | `upload`, `view_own`                                    |
| Actividades             | `create`, `read_own`                                    |
| Materiales / Servicios  | `read`, `create`, `update`                              |
| Reportes                | `view_own`                                              |

---

### 🛠 Ingeniero

**Responsabilidades:**

* Desarrollar y ejecutar proyectos técnicos.
* Colaborar en la elaboración de cotizaciones técnicas.
* Mantener comunicación técnica con el equipo de ventas y clientes.

| Entidad                 | Acciones                                                |
| ----------------------- | ------------------------------------------------------- |
| Usuarios                | `read_self`, `update_self`                              |
| Clientes                | `read_own`                                              |
| Proyectos               | `create`, `read_own`, `update_own`                      |
| Cotizaciones            | `create`, `read_own`, `update_own`, `send_for_approval` |
| Conceptos de cotización | `create`, `update_own`, `delete_own`                    |
| Archivos / Planos       | `upload`, `view_own`                                    |
| Actividades             | `create`, `read_own`                                    |
| Materiales / Servicios  | `read`, `create`, `update`                              |
| Reportes                | `view_own`                                              |

---

## 🔁 Relaciones **has-many / many-to-many**

| Relación                | Tipo | Descripción                                                                                |
| ----------------------- | ---- | ------------------------------------------------------------------------------------------ |
| Usuario → Cotizaciones  | 1:N  | Un usuario (vendedor o ingeniero) puede crear múltiples cotizaciones                       |
| Usuario → Proyectos     | 1:N  | Un usuario puede ser responsable de varios proyectos                                       |
| Cliente → Proyectos     | 1:N  | Un cliente puede tener múltiples proyectos                                                 |
| Proyecto → Cotizaciones | 1:N  | Un proyecto puede tener múltiples cotizaciones                                             |
| Cotización → Conceptos  | 1:N  | Una cotización tiene múltiples conceptos (materiales y servicios)                          |
| Cotización → Usuario    | N:1  | Muchas cotizaciones son creadas por un solo usuario                                        |
| Cotización → Cliente    | N:1  | Muchas cotizaciones pertenecen a un solo cliente                                           |
| Materiales / Servicios  | N:N  | Pueden ser referenciados en múltiples cotizaciones a través de los conceptos de cotización |

---

## 🔍 Características del sistema de auditoría

### Modelos auditados:
- Clientes
- Proyectos
- Cotizaciones
- Conceptos de cotización
- Materiales
- Servicios

### Acciones registradas:
- Creación de registros
- Modificación de registros
- Eliminación de registros

### Información almacenada por cada cambio:
- Usuario que realizó el cambio
- Fecha y hora del cambio
- Estado anterior del registro (para actualizaciones y eliminaciones)
- Estado nuevo del registro (para creaciones y actualizaciones)
- Tipo de acción realizada

### Acceso a la auditoría:
- Solo visible para usuarios con rol de administrador
- Almacenamiento permanente sin opción de modificación