FIDEL GARCIA MARTINEZ - YOSER ADRIAN SARABIA ORTEGA - JEFFERSON DAVID AYALA TORRES

**OBJETIVO PRINCIPAL**
Desarrollar un sistema de información para la gestión médica veterinaria e inventario de insumos , centralizando el registro de propietarios, pacientes (mascotas), atenciones clínicas y control automático de stock mediante una arquitectura robusta y segura en Spring Boot

**OBJETICOS ESPECIFICOS**
1. Gestión de Acceso y Usuarios: Implementar un esquema de autenticación y autorización basado en roles (ADMINISTRADOR, RECEPCIONISTA, VETERINARIO) con cifrado seguro de credenciales.
2. Gestión de Pacientes y Clientes: Facilitar el registro de propietarios y mascotas, permitiendo consultas ágiles por documento de identidad o nombre del paciente
3. Control de Historia Clínica: Registrar las atenciones médicas (motivo, diagnóstico, tratamiento) y guardar la trazabilidad cronológica por cada paciente

**JUSTIFICACION**
En las clínicas veterinarias operativas, el registro fragmentado o manual de las atenciones médicas y el inventario genera dos problemas críticos: la pérdida de trazabilidad clínica de los pacientes y el desabastecimiento inesperado de medicamentos e insumos indispensables para el tratamiento médico.
El desarrollo de este sistema justifica su implementación bajo los siguientes aspectos:
Integridad Transaccional: La integración directa entre las atenciones médicas y la deducción automática de stock evita inconsistencias en los inventarios. Al fallar cualquier paso, la transacción completa se revierte impidiendo discrepancias contables o desabastecimientos no registrados.   
Seguridad y Confidencialidad: Garantiza el control estricto de acceso basado en el rol de cada funcionario, asegurando la protección de datos personales de los clientes  y el cifrado de las claves de acceso.  
Eficiencia Operativa: Reduce significativamente el tiempo empleado por los veterinarios y recepcionistas en la búsqueda de historiales clínicos y permite a los administradores anticiparse al agotamiento de productos a través de alertas visuales y reportes. 

**REQUERIMIENTOS FUNCIONALES**
| ID | Módulo | Requerimiento |
| :--- | :--- | :--- |
| **RF-01** | Usuarios y Acceso | El sistema debe permitir iniciar sesión, cerrar sesión y recuperar la contraseña. |
| **RF-02** | Usuarios y Acceso | El sistema debe manejar cuatro perfiles (Administrador, Recepcionista, Veterinario y Cliente/Propietario) con permisos distintos. |
| **RF-03** | Usuarios y Acceso | El Administrador debe poder crear, editar, desactivar y consultar usuarios, y asignarles roles. |
| **RF-04** | Usuarios y Acceso | El cliente debe poder crear su propia cuenta en el sistema. |
| **RF-05** | Pacientes y Clientes | El sistema debe permitir registrar un propietario (documento, nombre, teléfono y email), validando que el documento no esté duplicado. |
| **RF-06** | Pacientes y Clientes | El sistema debe permitir registrar y actualizar una o varias mascotas por propietario; el cliente solo podrá gestionar las suyas. |
| **RF-07** | Pacientes y Clientes | El personal debe poder buscar pacientes por cédula del dueño o nombre de la mascota. |
| **RF-08** | Citas | El cliente debe poder solicitar una cita seleccionando mascota, motivo, fecha y hora disponible. |
| **RF-09** | Citas | La recepcionista debe poder aprobar, rechazar o reprogramar las solicitudes de cita y consultar la agenda de atención. |
| **RF-10** | Citas | El cliente debe poder cancelar sus citas y consultar su estado e historial. |
| **RF-11** | Consulta e Historia Clínica | El veterinario debe poder registrar una consulta médica con su diagnóstico y tratamiento, quedando asociada automáticamente a él. |
| **RF-12** | Consulta e Historia Clínica | El veterinario debe poder asignar medicamentos e insumos a la consulta, indicando la cantidad utilizada. |
| **RF-13** | Consulta e Historia Clínica | El sistema debe mostrar el historial clínico de cada mascota en orden cronológico; el cliente podrá consultarlo sin modificarlo. |
| **RF-14** | Inventario | El Administrador debe poder crear, editar y eliminar productos, y ver el listado con su stock resaltando visualmente los de stock bajo. |
| **RF-15** | Inventario | El sistema debe validar las existencias y descontar automáticamente del stock las cantidades utilizadas en cada atención, mostrando un error claro si no hay suficiente. |
| **RF-16** | Reportes y Notificaciones | El Administrador debe poder consultar el consumo de insumos por día y por mes. |
| **RF-17** | Reportes y Notificaciones | El sistema debe generar alertas cuando los productos tengan existencias bajas. |
| **RF-18** | Reportes y Notificaciones | El sistema debe notificar al cliente la aprobación, rechazo o modificación de sus citas y enviarle recordatorios de las próximas. |

**REQUERIMIENTOS NO FUNCIONALES**
| ID | Categoría | Requerimiento |
| :--- | :--- | :--- |
| **RNF-01** | Seguridad | Las contraseñas deben almacenarse cifradas (hash con BCrypt o similar), nunca en texto plano. |
| **RNF-02** | Seguridad | El acceso a cada funcionalidad debe restringirse según el rol; un cliente solo podrá acceder a sus propias mascotas, citas e historial. |
| **RNF-03** | Seguridad | La comunicación entre cliente y servidor debe usar HTTPS. |
| **RNF-04** | Seguridad | La sesión debe expirar tras un periodo de inactividad (por ejemplo, 30 minutos). |
| **RNF-05** | Seguridad | El sistema debe proteger los datos personales conforme a la Ley 1581 de 2012 (Colombia). |
| **RNF-06** | Rendimiento | Las búsquedas de pacientes deben responder en menos de 2 segundos. |
| **RNF-07** | Rendimiento | El sistema debe soportar al menos 50 usuarios concurrentes sin degradación notable. |
| **RNF-08** | Integridad de datos | El registro de una atención y el descuento de stock deben ejecutarse en una sola transacción (si falla uno, se revierte todo). |
| **RNF-09** | Integridad de datos | El sistema debe manejar la concurrencia al descontar stock y reservar citas, evitando inconsistencias y reservas duplicadas. |
| **RNF-10** | Integridad de datos | El sistema debe validar los datos de entrada tanto en el cliente como en el servidor. |
| **RNF-11** | Usabilidad | La interfaz debe ser clara e intuitiva, de modo que un cliente pueda solicitar una cita sin capacitación previa. |
| **RNF-12** | Usabilidad | Los mensajes de error y confirmación deben estar en español y ser comprensibles. |
| **RNF-13** | Usabilidad | La interfaz debe ser responsiva (computador, tableta y celular). |
| **RNF-14** | Compatibilidad | El sistema debe funcionar en las versiones recientes de Chrome, Firefox, Edge y Safari. |
| **RNF-15** | Disponibilidad | Debe realizarse un respaldo (backup) automático de la base de datos al menos una vez al día. |
| **RNF-16** | Mantenibilidad | El sistema debe usar arquitectura en capas (controlador, servicio, repositorio), JPA y una base de datos relacional, con la lógica de negocio en el backend. |


**DIAGRAMAS DE CASO DE USO**
<img width="1600" height="2220" alt="Diagrama en blanco - Página 1" src="https://github.com/user-attachments/assets/b0aed84e-7384-4bc3-a6e9-51d590e24a41" />

**DIAGRAMA DE CLASES**
<img width="1570" height="2090" alt="Diagrama en blanco - Página 4" src="https://github.com/user-attachments/assets/eb4c08c1-fd35-4382-8642-ad005e24385b" />

**DIAGRAMA ENTIDAD-RELACION**
<img width="1016" height="1021" alt="image" src="https://github.com/user-attachments/assets/f9eb7bfa-5dc3-4c0e-9697-9bcbfbcfef24" />



