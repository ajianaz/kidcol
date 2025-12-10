# Image Server Auto Backup System

## Overview
Sistem automatic failover untuk image server dengan backup server. Jika primary server down, aplikasi akan otomatis menggunakan backup server.

## Configuration

### Server URLs
- **Primary Server**: `https://s3.azfirazka.com`
- **Backup Server**: `https://cdn.ajianaz.dev`
- **Health Check**: `https://s31.ajianaz.dev`

## How It Works

### 1. Startup Health Check
Saat aplikasi dimulai, sistem akan:
1. Melakukan health check ke `https://s31.ajianaz.dev`
2. Jika sukses (status 200), gunakan primary server
3. Jika gagal, otomatis switch ke backup server

### 2. Automatic URL Replacement
Semua image URL akan otomatis disesuaikan:
- Jika primary server healthy: gunakan URL asli
- Jika primary server down: replace `https://s3.azfirazka.com` dengan `https://cdn.ajianaz.dev`

### 3. Usage in Code

#### Get Image URL with Failover
```dart
// In your widget
final asset = Asset(...);
final imageUrl = asset.getImageUrl(); // Automatically uses correct server

// Example:
Image.network(asset.getImageUrl())
```

#### Manual Server Control
```dart
final imageServerService = Get.find<ImageServerService>();

// Check current server
print(imageServerService.currentImageServer);
print(imageServerService.isPrimaryServerHealthy);

// Manual switch to backup
imageServerService.switchToBackupServer();

// Manual switch to primary
imageServerService.switchToPrimaryServer();

// Retry health check
await imageServerService.retryHealthCheck();
```

## Logs

### Startup Logs
```
[ImageServerService] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ImageServerService] 🏥 Checking primary image server health...
[ImageServerService] Health check URL: https://s31.ajianaz.dev
[ImageServerService] ✅ Primary server is healthy
[ImageServerService] Using: https://s3.azfirazka.com
[ImageServerService] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Failover Logs
```
[ImageServerService] ⚠️  Health check failed: ...
[ImageServerService] ❌ Primary server is down
[ImageServerService] 🔄 Switching to backup server: https://cdn.ajianaz.dev
```

### URL Replacement Logs
```
[ImageServerService] 🔄 URL replaced: https://s3.azfirazka.com → https://cdn.ajianaz.dev
```

## Implementation Details

### Files Modified/Created
1. **Created**: `lib/app/data/services/image_server_service.dart`
   - Main service for server management

2. **Modified**: `lib/main.dart`
   - Added ImageServerService initialization
   - Added health check on startup

3. **Modified**: `lib/app/data/models/asset.dart`
   - Added `getImageUrl()` method for automatic failover

### Service Features
- ✅ Automatic health check on startup
- ✅ Automatic URL replacement
- ✅ Manual server switching
- ✅ Health check retry
- ✅ Comprehensive logging
- ✅ Reactive state management (Rx)

## Testing

### Test Primary Server Down
```dart
// Simulate primary server down
final imageServerService = Get.find<ImageServerService>();
imageServerService.switchToBackupServer();

// All subsequent image loads will use backup server
```

### Test Health Check
```dart
// Retry health check
await imageServerService.retryHealthCheck();
```

## Benefits
1. **Zero Downtime**: Automatic failover ensures images always load
2. **Transparent**: No code changes needed in UI layer
3. **Flexible**: Can manually control server selection
4. **Observable**: Comprehensive logging for debugging
5. **Reactive**: UI can observe server status changes

## Future Enhancements
- [ ] Periodic health checks in background
- [ ] Retry mechanism for failed images
- [ ] Server response time monitoring
- [ ] Multiple backup servers support
- [ ] Cache server preference
