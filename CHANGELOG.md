# Changelog

## [1.0.0] - 2025-03-11

### Added
- Zoom capability with `enableZoom` and `enableDoubleTapZoom` options
- Fullscreen view mode with `fullscreenOnEnlarge` parameter
- Hero animations between thumbnail and enlarged view
- Status badge indicator with customizable color, size, position and border
- Text and widget overlay options with configurable alignment and styling
- Custom placeholder and error widgets
- Loading state with customizable indicator color
- Animation customizations including duration and curve options
- Callbacks for tap and long-press events
- Optional close button in fullscreen view

### Changed
- Renamed `circle` parameter to `isCircular` for better semantics
- Improved dialog presentation with backdrop blur effect
- Enhanced image preloading and error handling
- Optimized animations for smoother transitions
- Better handling of image aspect ratios in different view modes

### Fixed
- Image flickering when transitioning between states
- Memory leaks related to animation controllers
- Incorrect scaling in some display configurations
- Layout issues with varying screen sizes

## [0.0.2]

### Initial Release
- Basic profile image viewing capability
- Support for circular and rectangular shapes
- Simple tap to enlarge functionality
- Basic customization options (size, border radius)