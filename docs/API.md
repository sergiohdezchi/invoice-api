# API de Autenticación y Facturación

Este documento describe los endpoints disponibles en la API de Facturación, incluyendo el nuevo sistema de autenticación basado en Devise y JWT.

## Endpoints de Autenticación

### Registro de Usuario

**Endpoint:** `POST /api/v1/auth/register`

**Descripción:** Crea un nuevo usuario en el sistema.

**Parámetros:**
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123",
  "password_confirmation": "contraseña123",
  "name": "Nombre Usuario"
}
```

**Respuesta exitosa:**
```json
{
  "status": "success",
  "message": "Usuario registrado exitosamente",
  "data": {
    "user": {
      "id": 1,
      "email": "usuario@ejemplo.com",
      "name": "Nombre Usuario"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_at": 1688840799
  }
}
```

### Inicio de Sesión

**Endpoint:** `POST /api/v1/auth/login`

**Descripción:** Autentica a un usuario y devuelve un token JWT.

**Parámetros:**
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123"
}
```

**Respuesta exitosa:**
```json
{
  "status": "success",
  "message": "Login exitoso",
  "data": {
    "user": {
      "id": 1,
      "email": "usuario@ejemplo.com",
      "name": "Nombre Usuario"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_at": 1688840799
  }
}
```

### Cierre de Sesión

**Endpoint:** `DELETE /api/v1/auth/logout`

**Descripción:** Cierra la sesión del usuario actual.

**Headers requeridos:**
```
Authorization: Bearer {token}
```

**Respuesta exitosa:**
```json
{
  "status": "success",
  "message": "Sesión cerrada correctamente"
}
```

## Endpoints de Perfil

### Obtener Perfil

**Endpoint:** `GET /api/v1/profile`

**Descripción:** Obtiene la información del perfil del usuario autenticado.

**Headers requeridos:**
```
Authorization: Bearer {token}
```

**Respuesta exitosa:**
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "id": 1,
      "email": "usuario@ejemplo.com",
      "name": "Nombre Usuario",
      "active": true,
      "created_at": "2025-07-07T12:00:00.000Z"
    }
  }
}
```

### Actualizar Perfil

**Endpoint:** `PUT /api/v1/profile`

**Descripción:** Actualiza la información del perfil del usuario autenticado.

**Headers requeridos:**
```
Authorization: Bearer {token}
```

**Parámetros:**
```json
{
  "name": "Nuevo Nombre",
  "email": "nuevo_email@ejemplo.com"
}
```

**Respuesta exitosa:**
```json
{
  "status": "success",
  "message": "Perfil actualizado correctamente",
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "id": 1,
      "email": "nuevo_email@ejemplo.com",
      "name": "Nuevo Nombre",
      "active": true,
      "created_at": "2025-07-07T12:00:00.000Z"
    }
  }
}
```

### Actualizar Contraseña

**Endpoint:** `PUT /api/v1/profile/password`

**Descripción:** Actualiza la contraseña del usuario autenticado.

**Headers requeridos:**
```
Authorization: Bearer {token}
```

**Parámetros:**
```json
{
  "current_password": "contraseña_actual",
  "password": "nueva_contraseña",
  "password_confirmation": "nueva_contraseña"
}
```

**Respuesta exitosa:**
```json
{
  "status": "success",
  "message": "Contraseña actualizada correctamente",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_at": 1688840799
  }
}
```

## Endpoints de Facturas

### Listar Facturas

**Endpoint:** `GET /api/v1/invoices`

**Descripción:** Obtiene una lista paginada de facturas.

**Headers requeridos:**
```
Authorization: Bearer {token}
```

**Parámetros:**
- `start_date` (requerido): Fecha de inicio en formato YYYY-MM-DD
- `end_date` (opcional): Fecha fin en formato YYYY-MM-DD
- `page` (opcional): Número de página para paginación
- `per_page` (opcional): Cantidad de registros por página

**Respuesta exitosa:**
```json
{
  "data": [
    {
      "id": "1",
      "type": "invoice",
      "attributes": {
        "id": 1,
        "number": "F001-123456",
        "date": "2025-07-01",
        "customer_name": "Cliente Ejemplo",
        "total": 1500.25,
        "status": "paid"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_count": 50
  }
}
```
