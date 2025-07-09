# 🏆 InvoiceVault Pro API

<div align="center">
  <img src="images/banner.png" alt="Banner InvoiceVault Pro">
  <br>
  <h3>Sistema de Gestión Inteligente de Facturas</h3>
  <p>Potenciando la gestión financiera con tecnología de vanguardia</p>
  
  [![Ruby on Rails](https://img.shields.io/badge/Rails-7.2.2-red.svg)](https://rubyonrails.org/)
  [![Ruby](https://img.shields.io/badge/Ruby-3.2+-blue.svg)](https://www.ruby-lang.org/)
  [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Latest-blue.svg)](https://www.postgresql.org/)
  [![Redis](https://img.shields.io/badge/Redis-Latest-red.svg)](https://redis.io/)
  [![Sidekiq](https://img.shields.io/badge/Sidekiq-8.0-darkgreen.svg)](https://github.com/mperham/sidekiq)
</div>

## 📊 Características Principales

**InvoiceVault Pro** es una potente API RESTful desarrollada en Ruby on Rails diseñada para gestionar facturas de manera eficiente y segura. Con una arquitectura moderna y escalable, proporciona una solución completa para la gestión financiera.

- ✅ **Almacenamiento seguro** de facturas con detalles completos
- ✅ **Búsqueda avanzada** por múltiples parámetros
- ✅ **Reportes automáticos** de ventas diarias
- ✅ **Notificaciones por correo** de facturas importantes
- ✅ **Sistema de cache** optimizado para alta disponibilidad
- ✅ **Procesamiento en segundo plano** para tareas intensivas

## 🔐 Autenticación Segura

InvoiceVault Pro implementa un sistema de autenticación robusto basado en **Devise** y **JSON Web Tokens (JWT)** que proporciona:

- 🔒 Registro seguro de usuarios
- 🔑 Inicio de sesión con generación de tokens JWT
- 🛡️ Protección de endpoints mediante autorización por tokens
- ⏱️ Sistema de expiración de tokens configurable

### Uso de la autenticación:

1. Registre un usuario o inicie sesión para obtener un token JWT
2. Incluya el token en el encabezado `Authorization` de cada solicitud:
   ```
   Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
   ```

## � Requisitos Técnicos

### � Entorno Docker (Recomendado)
- [Docker](https://www.docker.com/get-started) (v20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2.0+)

### ⚙️ Entorno Local
- [Ruby](https://www.ruby-lang.org/es/documentation/installation/) (v3.2+)
- [Rails](https://guides.rubyonrails.org/getting_started.html) (v7.2+)
- [PostgreSQL](https://www.postgresql.org/download/) (v14+)
- [Redis](https://redis.io/download) (v6.0+)
- [Bundler](https://bundler.io/) (`gem install bundler`)

## 🚀 Guía de Instalación

### 📥 Primeros pasos
```bash
# Clonar el repositorio
git clone https://github.com/sergiohdezchi/invoice-api.git

# Ingresar al directorio del proyecto
cd invoice-api
```

### 🐳 Opción A: Despliegue con Docker

1. **Configuración del entorno**



   Edite el archivo `.env.example` con sus credenciales:
   ```bash

   # Configuración de Email
   TOP_SALES_EMAIL=reportes@suempresa.com

   # Configuración CORS
   ALLOWED_ORIGINS=https://app.suempresa.com,http://localhost:4200
   ```

2. **Construcción y despliegue de contenedores**

   ```bash
   docker-compose up --build
   ```

   Este comando inicializará y conectará automáticamente todos los servicios necesarios:

   | Servicio | Descripción | Puerto |
   | --- | --- | --- |
   | 🖥️ **API** | Servidor Rails API | 3000 |
   | 🗄️ **PostgreSQL** | Base de datos | 5432 |
   | 📋 **Redis** | Caché y colas | 6380 |
   | 🔄 **Sidekiq** | Procesamiento en background | - |

3. **Inicialización de la base de datos**
   
   Una vez que los contenedores estén funcionando:
   
   ```bash
   docker compose exec app rails db:setup
   ```

4. **Acceso a los servicios**
   
   - **API REST**: [http://localhost:3000](http://localhost:3000)
   - **Panel de Sidekiq**: [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)


### ⚙️ Opción B: Instalación Local

1. **Configuración del entorno**

   ```bash
   # Copiar archivo de configuración
   cp .env.example .env
   ```

   Edite el archivo `.env` con la configuración para entorno local:
   ```bash

   # Redis
   REDIS_URL=redis://localhost:6379/1
   
   # Email
   TOP_SALES_EMAIL=reportes@suempresa.com
   ```

2. **Instalación de dependencias**

   ```bash
   # Instalar gemas requeridas
   bundle install
   
   # Configurar base de datos
   rails db:setup
   ```

3. **Iniciar los servicios**

   ```bash
   # En terminal 1: Iniciar servidor de Redis
   sudo systemctl start redis-server
   
   # En terminal 2: Iniciar servidor de Rails
   rails s
   
   # En terminal 3: Iniciar worker de Sidekiq
   bundle exec sidekiq -C config/sidekiq.yml
   ```

4. **Acceso a los servicios**
   
   - **API REST**: [http://localhost:3000](http://localhost:3000)
   - **Panel de Sidekiq**: [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)


## 📊 Reportes y Funcionalidades

### 📧 Generación de Reportes por Email

InvoiceVault Pro incluye un sistema de reportes automáticos de ventas diarias que pueden enviarse por email.

#### Opciones de ejecución:

1. **En entorno local**
   ```bash
   bundle exec rake reports:queue_daily_top_sells
   ```

2. **En entorno Docker**
   ```bash
   docker compose exec app bundle exec rake reports:queue_daily_top_sells
   ```

### � Endpoints Principales

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/v1/auth/register` | Registro de usuario |
| POST | `/api/v1/auth/login` | Inicio de sesión |
| GET | `/api/v1/profile` | Perfil del usuario |
| GET | `/api/v1/invoices` | Listado de facturas |

## ⚙️ Administración del Sistema

### 🐳 Gestión de Contenedores

```bash
# Iniciar servicios
docker compose up

# Iniciar en segundo plano
docker compose up -d

# Reiniciar servicios
docker compose restart

# Detener servicios (conservando datos)
docker compose down

# Detener servicios y eliminar volúmenes
docker compose down -v
```

### 🔄 Tareas de Mantenimiento

```bash
# Ejecutar migraciones
docker compose exec app rails db:migrate

# Cargar datos iniciales
docker compose exec app rails db:seed

# Limpiar caché
docker compose exec app rails r "Rails.cache.clear"

# Ver logs de la aplicación
docker compose logs -f app
```

## 🛡️ Seguridad y Buenas Prácticas

- Todos los endpoints de la API están protegidos con autenticación JWT
- Las contraseñas se almacenan encriptadas usando BCrypt
- Implementación de CORS para proteger contra solicitudes no autorizadas

## 📄 Licencia

Este proyecto está licenciado bajo los términos de la [Licencia MIT](LICENSE).
