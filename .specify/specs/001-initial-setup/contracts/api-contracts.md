# API Contracts: Health and Configuration Endpoints

**Feature**: Initial Project Setup (001-initial-setup)  
**Date**: 2025-11-17  
**API Version**: v1

## Overview

This document defines the initial API contracts for health checking and configuration endpoints. These are foundational endpoints that exist in every backend package.

---

## Base URL

```
https://api.example.com/api/v1
```

All endpoints are prefixed with `/api/v1` for versioning.

---

## Health Check Endpoints

### GET /health

Health check endpoint for monitoring and orchestration.

**Request**

```http
GET /api/v1/health HTTP/1.1
Host: api.example.com
```

**Response (200 OK)**

```json
{
  "status": "Healthy",
  "timestamp": "2025-11-17T06:22:00Z",
  "version": "1.0.0",
  "checks": {
    "database": "Healthy",
    "supabase": "Healthy",
    "cache": "Healthy"
  }
}
```

**Response (503 Service Unavailable)**

```json
{
  "status": "Unhealthy",
  "timestamp": "2025-11-17T06:22:00Z",
  "version": "1.0.0",
  "checks": {
    "database": "Unhealthy",
    "supabase": "Healthy",
    "cache": "Degraded"
  },
  "errors": [
    "Database connection timeout"
  ]
}
```

**Status Codes**
- `200 OK` - All systems healthy
- `503 Service Unavailable` - One or more systems unhealthy

---

### GET /health/ready

Readiness check for Kubernetes and load balancers.

**Request**

```http
GET /api/v1/health/ready HTTP/1.1
Host: api.example.com
```

**Response (200 OK)**

```json
{
  "ready": true,
  "timestamp": "2025-11-17T06:22:00Z"
}
```

**Response (503 Service Unavailable)**

```json
{
  "ready": false,
  "timestamp": "2025-11-17T06:22:00Z",
  "reason": "Database migrations pending"
}
```

**Status Codes**
- `200 OK` - Service ready to accept traffic
- `503 Service Unavailable` - Service not ready (startup in progress)

---

### GET /health/live

Liveness check for Kubernetes.

**Request**

```http
GET /api/v1/health/live HTTP/1.1
Host: api.example.com
```

**Response (200 OK)**

```json
{
  "alive": true
}
```

**Status Codes**
- `200 OK` - Service is alive (process running)
- No 503 response - if this fails, the process is dead

---

## Configuration Endpoints

### GET /config/features

Get enabled feature flags for the frontend.

**Request**

```http
GET /api/v1/config/features HTTP/1.1
Host: api.example.com
```

**Response (200 OK)**

```json
{
  "features": {
    "realtime_enabled": false,
    "advanced_search": true,
    "export_to_unity": true,
    "export_to_playcanvas": false
  },
  "version": "1.0.0"
}
```

**Status Codes**
- `200 OK` - Feature flags returned

---

### GET /config/version

Get API and service version information.

**Request**

```http
GET /api/v1/config/version HTTP/1.1
Host: api.example.com
```

**Response (200 OK)**

```json
{
  "api_version": "v1",
  "service_version": "1.0.0",
  "build": "20251117.1",
  "commit": "a1b2c3d",
  "environment": "production"
}
```

**Status Codes**
- `200 OK` - Version information returned

---

## Error Response Format

All API errors follow this standard format:

```json
{
  "success": false,
  "errorMessage": "Resource not found",
  "errorCode": "RESOURCE_NOT_FOUND",
  "metadata": {
    "requestId": "req-123456",
    "timestamp": "2025-11-17T06:22:00Z"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `UNAUTHORIZED` | 401 | Authentication required or failed |
| `FORBIDDEN` | 403 | User lacks permission for resource |
| `RESOURCE_NOT_FOUND` | 404 | Requested resource does not exist |
| `VALIDATION_ERROR` | 400 | Request data validation failed |
| `CONFLICT` | 409 | Resource conflict (e.g., duplicate) |
| `INTERNAL_ERROR` | 500 | Unexpected server error |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |

---

## Authentication

Most endpoints (except health and public config) require JWT authentication.

**Request Header**

```http
Authorization: Bearer <jwt_token>
```

**Example**

```http
GET /api/v1/clusters HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Authentication Errors**

```json
{
  "success": false,
  "errorMessage": "Invalid or expired token",
  "errorCode": "UNAUTHORIZED"
}
```

---

## Rate Limiting

All endpoints are rate-limited per user/IP.

**Rate Limit Headers**

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1700222400
```

**Rate Limit Exceeded (429)**

```json
{
  "success": false,
  "errorMessage": "Rate limit exceeded. Try again in 60 seconds.",
  "errorCode": "RATE_LIMIT_EXCEEDED",
  "metadata": {
    "retryAfter": 60
  }
}
```

---

## Pagination

List endpoints support pagination using query parameters.

**Query Parameters**
- `page` - Page number (1-based, default: 1)
- `pageSize` - Items per page (default: 20, max: 100)
- `sortBy` - Field to sort by (default: "createdAt")
- `sortOrder` - Sort direction: "asc" or "desc" (default: "desc")

**Example Request**

```http
GET /api/v1/clusters?page=2&pageSize=50&sortBy=name&sortOrder=asc HTTP/1.1
```

**Example Response**

```json
{
  "success": true,
  "data": {
    "items": [...],
    "page": 2,
    "pageSize": 50,
    "totalCount": 235,
    "totalPages": 5,
    "hasNextPage": true,
    "hasPreviousPage": true
  }
}
```

---

## Filtering

List endpoints support filtering using query parameters.

**Query Parameter Format**

```
filter[{field}]={operator}:{value}
```

**Supported Operators**
- `eq` - Equals
- `ne` - Not equals
- `gt` - Greater than
- `gte` - Greater than or equal
- `lt` - Less than
- `lte` - Less than or equal
- `contains` - String contains
- `startswith` - String starts with

**Example**

```http
GET /api/v1/clusters?filter[name]=contains:production&filter[status]=eq:active HTTP/1.1
```

---

## CORS

CORS headers are configured for cross-origin requests.

**Allowed Origins**
- Development: `http://localhost:*`
- Production: `https://*.universoplat formo.com`

**Preflight Response**

```http
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: https://app.universoplatformo.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 3600
```

---

## WebSocket / Realtime (Future)

Realtime subscriptions will be available for supported resources.

**Connection**

```javascript
const ws = new WebSocket('wss://api.example.com/api/v1/realtime');
ws.send(JSON.stringify({
  action: 'subscribe',
  channel: 'clusters',
  filter: { userId: 'user-123' }
}));
```

**Note**: Realtime is out of scope for initial setup but architecture accommodates future implementation.

---

## Contract Versioning

API versioning strategy:
- **URL Versioning**: `/api/v1`, `/api/v2`, etc.
- **Version in Response**: `api_version` field in version endpoint
- **Deprecation**: Old versions supported for 6 months after new version release
- **Breaking Changes**: Require new major version

---

## Next Steps

1. Implement health check endpoints in backend packages
2. Create ASP.NET Core middleware for error handling
3. Implement JWT authentication middleware
4. Set up rate limiting
5. Create OpenAPI/Swagger documentation

**Status**: API contracts defined. Ready for implementation.
