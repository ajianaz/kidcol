# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Image Server Auto Backup System** - Automatic failover between primary and backup image servers
  - Primary server: `https://s3.azfirazka.com`
  - Backup server: `https://cdn.ajianaz.dev`
  - Health check on app startup to determine server availability
  - Automatic URL replacement when primary server is down
  - Zero downtime for image loading
  - Comprehensive logging for debugging

- **Filter System for Coloring Images**
  - Filter by category (Animal, Food, Vehicle, etc.)
  - Filter by difficulty level (1-5)
  - Visual indicator for active filters
  - Reset filters functionality
  - Persistent filter state during session
  - Clean and intuitive filter dialog UI

- **Enhanced API Request Logging**
  - Detailed logging for filter requests
  - Request timing and duration tracking
  - Response status and data validation
  - Error tracking with context
  - Filter state logging for debugging

### Changed
- **Improved Logging System**
  - Simplified and cleaned up verbose logs
  - More concise request/response logging
  - Better error messages with context
  - Reduced log noise while maintaining essential information

- **Filter Dialog UX**
  - Fixed reset button to properly clear filters and refresh data
  - Improved visual feedback for filter selection
  - Better animation and transitions

### Fixed
- **FilterService Registration** - Fixed "FilterService not found" error by properly registering service in `main.dart`
- **Filter Reset Button** - Fixed reset button in filter dialog to actually reset filters in controller
- **Image URL Handling** - All image URLs now use automatic server failover across the app:
  - Home view (3 locations)
  - Collection view (4 locations)
  - PDF printing (2 locations)

### Technical Details

#### New Services
- `ImageServerService` - Manages image server health and automatic failover
- `FilterService` - Handles filter options fetching and caching

#### Modified Models
- `Asset` - Added `getImageUrl()` method for automatic server failover
- `Gambar` - Added `getImageUrl()` method for automatic server failover

#### Modified Controllers
- `HomeController` - Enhanced with filter management and comprehensive logging
- `PrintingPdfController` - Updated to use automatic server failover

#### Modified Views
- `HomeView` - Updated to use `asset.getImageUrl()` for all image loading
- `KoleksiGambarView` - Updated to use `gambar.getImageUrl()` for all image loading
- `FilterDialog` - Fixed reset button functionality

### Performance Improvements
- Reduced logging overhead with more concise messages
- Efficient filter state management
- Optimized image URL processing

### Developer Experience
- Better debugging with structured logs
- Clear separation of concerns (server management, filtering, logging)
- Comprehensive documentation in `docs/IMAGE_SERVER_BACKUP.md`

---

## [Previous Versions]

### [1.0.0] - Initial Release
- Basic coloring app functionality
- Image browsing and selection
- Collection management
- Drawing room with coloring tools
- PDF export functionality
- Local database with Isar
- Multi-language support (English/Indonesian)
- Dark/Light theme support

---

## Notes

### Breaking Changes
None in this release.

### Migration Guide
No migration needed. All changes are backward compatible.

### Known Issues
None at this time.

### Deprecations
None in this release.

---

## Contributors
- Development Team
- QA Team
- Design Team

## Links
- [Documentation](./docs/)
- [Image Server Backup Guide](./docs/IMAGE_SERVER_BACKUP.md)
- [Issue Tracker](https://github.com/yourusername/kidcol/issues)
