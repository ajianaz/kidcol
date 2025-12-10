## Relevant Files

- `lib/app/modules/home/controllers/home_controller.dart` - Add filter state management and API integration
- `lib/app/modules/home/views/home_view.dart` - Add filter button and dialog integration
- `lib/app/modules/home/widgets/filter_dialog.dart` - Create new filter dialog widget
- `lib/app/data/services/filter_service.dart` - Create service for filter data management
- `lib/app/data/models/filter_options.dart` - Create model for filter options
- `lib/app/widgets/widgets.dart` - Add filter dialog widget exports
- `test/unit/home_controller_test.dart` - Unit tests for filter functionality
- `test/unit/filter_service_test.dart` - Unit tests for filter service
- `test/widget/filter_dialog_test.dart` - Widget tests for filter dialog

### Notes

- Unit tests should be placed alongside code files they test
- Use `flutter test` to run all tests
- Feature should be implemented incrementally with testing at each step

## Instructions for Completing Tasks

**IMPORTANT:** As you complete each task, check it off by changing `- [ ]` to `- [x]`. Update after completing each sub-task.

## Tasks

- [x] 0.0 Create feature branch
  - [x] 0.1 Create and checkout new branch (`git checkout -b feature/minimal-filter`)
- [x] 1.0 Setup filter data models and service
  - [x] 1.1 Create FilterOptions model class for level and category data
  - [x] 1.2 Create FilterService for fetching filter data from webhook
  - [x] 1.3 Add caching mechanism for filter options
  - [x] 1.4 Write unit tests for FilterService
- [x] 2.0 Update HomeController with filter functionality
  - [x] 2.1 Add reactive filter state variables (selectedLevel, selectedCategory)
  - [x] 2.2 Implement applyFilters() method to update API request
  - [x] 2.3 Implement resetFilters() method to clear all filters
  - [x] 2.4 Update requestData() method to include filter parameters
  - [x] 2.5 Add method to load filter options from service
  - [x] 2.6 Write unit tests for new controller methods
- [x] 3.0 Create FilterDialog widget
  - [x] 3.1 Create FilterDialog widget with category dropdown and level chips
  - [x] 3.2 Implement dialog UI consistent with existing design patterns
  - [x] 3.3 Add responsive design using ResponsiveHelper
  - [x] 3.4 Implement filter state management in dialog
  - [x] 3.5 Add Reset and Apply buttons with proper styling
  - [x] 3.6 Write widget tests for FilterDialog
- [x] 4.0 Integrate filter into HomeView
  - [x] 4.1 Add filter icon button to AppBar
  - [x] 4.2 Implement visual badge indicator for active filters
  - [x] 4.3 Add showFilterDialog() method to HomeView
  - [x] 4.4 Update home view UI to show filter state
  - [x] 4.5 Ensure proper error handling and loading states
  - [x] 4.6 Test integration with existing refresh functionality
- [x] 5.0 API integration and testing
  - [x] 5.1 Test API endpoint with filter parameters using curl
  - [x] 5.2 Update API configuration if needed for filter support
  - [x] 5.3 Test complete filter flow end-to-end
  - [x] 5.4 Test edge cases (empty results, API errors)
  - [x] 5.5 Verify performance impact is minimal (<5% loading time)
- [x] 6.0 Code review and final testing
  - [x] 6.1 Run all unit and widget tests
  - [x] 6.2 Perform manual testing on different screen sizes
  - [x] 6.3 Test filter state persistence during navigation
  - [x] 6.4 Verify no breaking changes to existing functionality
  - [x] 6.5 Final code cleanup and documentation
