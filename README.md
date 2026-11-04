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
| **RF-01** | Usuarios y Acceso | El sistema debe permitir iniciar y cerrar sesión con usuario y contraseña. |
| **RF-02** | Usuarios y Acceso | El sistema debe manejar tres roles (Administrador, Recepcionista y Veterinario) con permisos distintos. |
| **RF-03** | Usuarios y Acceso | El Administrador debe poder crear, editar, desactivar y consultar usuarios. |
| **RF-04** | Pacientes y Clientes | El sistema debe permitir registrar un propietario (documento, nombre, teléfono y email), validando que el documento no esté duplicado. |
| **RF-05** | Pacientes y Clientes | El sistema debe permitir registrar una o varias mascotas asociadas a un propietario (nombre, especie, raza, edad). |
| **RF-06** | Pacientes y Clientes | El sistema debe permitir buscar pacientes por documento del propietario o por nombre de la mascota. |
| **RF-07** | Pacientes y Clientes | El sistema debe mostrar los datos completos de un paciente y de su propietario. |
| **RF-08** | Consulta e Historia Clínica | El veterinario debe poder registrar una consulta médica (fecha, motivo y mascota), quedando asociada automáticamente a él. |
| **RF-09** | Consulta e Historia Clínica | El veterinario debe poder registrar el diagnóstico y el tratamiento de la consulta. |
| **RF-10** | Consulta e Historia Clínica | El veterinario debe poder asignar medicamentos e insumos a la consulta, indicando la cantidad utilizada. |
| **RF-11** | Consulta e Historia Clínica | El sistema debe mostrar el historial clínico de la mascota en orden cronológico. |
| **RF-12** | Inventario | El Administrador debe poder crear, editar y desactivar productos (nombre, stock actual, precio unitario). |
| **RF-13** | Inventario | El sistema debe mostrar el listado de productos con su stock y resaltar visualmente los de stock bajo. |
| **RF-14** | Inventario | El sistema debe descontar automáticamente del stock las cantidades utilizadas al registrar una atención. |
| **RF-15** | Inventario | El sistema no debe permitir asignar una cantidad mayor al stock disponible y debe mostrar un mensaje de error claro. |
| **RF-16** | Reportes | El Administrador debe poder consultar el consumo de insumos por día y por mes. |

**REQUERIMIENTOS NO FUNCIONALES**
| ID | Categoría | Requerimiento |
| :--- | :--- | :--- |
| **RNF-01** | Seguridad | Las contraseñas deben almacenarse cifradas (hash con BCrypt o similar), nunca en texto plano. |
| **RNF-02** | Seguridad | El acceso a cada funcionalidad debe restringirse según el rol del usuario. |
| **RNF-03** | Seguridad | La comunicación entre cliente y servidor debe usar HTTPS. |
| **RNF-04** | Seguridad | La sesión debe expirar tras un periodo de inactividad (por ejemplo, 30 minutos). |
| **RNF-05** | Seguridad | El sistema debe proteger los datos personales de los propietarios conforme a la Ley 1581 de 2012 (Colombia). |
| **RNF-06** | Rendimiento | Las búsquedas de pacientes deben responder en menos de 2 segundos. |
| **RNF-07** | Rendimiento | El sistema debe soportar al menos 20 usuarios concurrentes sin degradación notable. |
| **RNF-08** | Integridad de datos | El registro de una atención y el descuento de stock deben ejecutarse en una sola transacción (si falla uno, se revierte todo). |
| **RNF-09** | Integridad de datos | El sistema debe manejar la concurrencia al descontar stock para evitar inconsistencias. |
| **RNF-10** | Integridad de datos | El sistema debe validar los datos de entrada tanto en el cliente como en el servidor. |
| **RNF-11** | Usabilidad | La interfaz debe ser clara e intuitiva, requiriendo capacitación mínima. |
| **RNF-12** | Usabilidad | Los mensajes de error y confirmación deben estar en español y ser comprensibles. |
| **RNF-13** | Usabilidad | La interfaz debe ser responsiva (computador, tableta y celular). |
| **RNF-14** | Compatibilidad | El sistema debe funcionar en las versiones recientes de Chrome, Firefox, Edge y Safari. |
| **RNF-15** | Disponibilidad | Debe realizarse un respaldo (backup) automático de la base de datos al menos una vez al día. |
| **RNF-16** | Mantenibilidad | El sistema debe usar arquitectura en capas (controlador, servicio, repositorio), JPA y una base de datos relacional, con la lógica de negocio en el backend. |


**DIAGRAMAS DE CASO DE USO**
<img width="1031" height="1600" alt="image" src="https://github.com/user-attachments/assets/e272a831-4002-41b3-b2fb-c0a21de0bbfd" />

**DIAGRAMA DE CLASES**
<img width="1261" height="1375" alt="image" src="https://github.com/user-attachments/assets/c22a6e5f-152d-4888-9b03-e2b6817f36b5" />

**DIAGRAMA ENTIDAD-RELACION**
<img width="1016" height="1021" alt="image" src="https://github.com/user-attachments/assets/f9eb7bfa-5dc3-4c0e-9697-9bcbfbcfef24" />



