# 🧾 Invoice API

**Invoice API** es un backend construido en Ruby on Rails para gestionar facturas. Incluye integración con **PostgreSQL**, **Redis** y **Sidekiq** para el manejo de tareas en segundo plano.

## 🔐 Autenticación

La API utiliza un sistema de autenticación basado en **Devise** y **JWT** (JSON Web Tokens). Para utilizar los endpoints protegidos, los clientes deben:

1. Registrarse o iniciar sesión para obtener un token JWT
2. Incluir el token en el header `Authorization` en cada solicitud en el formato: `Bearer {token}`

---

## 📦 Requisitos

### 🔁 Para correr con Docker
- Docker
- Docker Compose

### 💻 Para correr sin Docker
- Ruby 3.2+
- Rails 7+
- Redis
- Bundler (`gem install bundler`)

---

## 🚀 Instalación

### Clonar el repositorio
```bash
git clone https://github.com/sergiohdezchi/invoice-api.git
cd invoice-api
```
### 🐳 Opción A: Usar Docker
1. Edita .env.example actualiza los datos necesarios:
```bash
# Database Configuration
DB_HOST=test # Dirección del servidor de base de datos
DB_USERNAME=test # Usuario de la base de datos
DB_PASSWORD=test # Contraseña de la base de datos
DB_NAME_PROD=test # Nombre de la base de datos

# Email Configuration
TOP_SALES_EMAIL=sergiohdez.chi@gmail.com # Dirección de correo donde se enviarán los reportes de ventas

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:4200 # Lista de orígenes permitidos para acceder a la API (CORS), separados por comas si hay más de uno

```

2. Construir y Levantar los Contenedores
Ejecuta el siguiente comando para construir y ejecutar la aplicación con Docker:

```bash
docker-compose up --build
```

Esto iniciará los siguientes servicios:

- Redis en el puerto 6380
- Rails API en el puerto 3000
- Sidekiq

3. Acceder a la Aplicación
Una vez que los contenedores estén en funcionamiento, puedes acceder a:
- http://0.0.0.0:3000/sidekiq


### 🐳 Opción B: Correr en local

1. crea un archivo .env y actualiza los datos necesarios
```bash
docker-compose up --build
# Database credentials
DB_HOST=test # Dirección del servidor de base de datos
DB_USERNAME=test # Usuario de la base de datos
DB_PASSWORD=test # Contraseña de la base de datos
DB_NAME_DEV=testinvoices # Nombre de la base de datos
DB_NAME_TEST=test
DB_NAME_PROD=test

REDIS_URL=redis://localhost:6379/1 # Redis URL

```
2. Instalacion de dependencias
```bash
bundle install
```

2. Iniciar rails

```bash
rails s
```

3. Iniciar redis
```bash
sudo systemctl start redis-server
```

4. iniciar sidekiq
```bash
bundle exec sidekiq -C config/sidekiq.yml
```

5. Acceder a la Aplicación

Una vez que se iniciaron los servicios
- http://0.0.0.0:3000/sidekiq


### Envio de Correo con rake task

1. Ejecucion sin docker
```bash
bundle exec rake reports:queue_daily_top_sells
```
2. Ejecucion con docker
```bash
docker compose exec app bundle exec rake reports:queue_daily_top_sells
```


## 📌 Comandos Útiles

1. Reiniciar la Aplicación**
Si necesitas reiniciar los contenedores, usa:
```sh
docker-compose restart
```

2. Detener la Aplicación**
Para detener los contenedores sin eliminar los volúmenes:
```sh
docker-compose down
```

Si deseas eliminar los volúmenes (base de datos y caché de Redis):
```sh
docker-compose down -v
```
3. Iniciar la Aplicación**
Para iniciar los contenedores:
```sh
docker-compose up
```
