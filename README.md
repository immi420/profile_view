# ProfileView

A Flutter package to open profile pictures in Instagram style with advanced customization options.

![Example animation](screenshots/example.gif)

## Features

- **Instagram-style profile viewing** - Tap to enlarge images with smooth animations
- **Flexible shape options** - Circular or rectangular with customizable border radius
- **Rich customization** - Borders, overlays, badges, and more
- **Advanced interactions** - Zoom, hero animations, fullscreen view
- **Loading states** - Customizable placeholders and error widgets
- **Performance optimized** - Image preloading and caching

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  profile_view: ^1.0.0
```

## Usage

### Basic Usage

**Circular Profile Image (Default)**

```dart
ProfileView(
image: NetworkImage(
"https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"
),
),
```

**Rectangular Image with Rounded Corners**

```dart
ProfileView(
height: 100,
width: 100,
isCircular: false, // Set to false for rectangular shape
borderRadius: 10,  // Corner radius for rectangle
image: NetworkImage(
"https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"
),
),
```

### Advanced Features

**With Custom Border**

```dart
ProfileView(
image: NetworkImage('https://example.com/profile.jpg'),
borderWidth: 2.0,
borderColor: Colors.blue,
),
```

**With Status Badge**

```dart
ProfileView(
image: NetworkImage('https://example.com/profile.jpg'),
showBadge: true,
badgeColor: Colors.green, // Online status
badgeAlignment: Alignment.bottomRight,
),
```

**With Text Overlay**

```dart
ProfileView(
image: NetworkImage('https://example.com/profile.jpg'),
overlayText: 'John Smith',
overlayTextStyle: TextStyle(fontWeight: FontWeight.bold),
overlayBackgroundColor: Colors.black54,
overlayAlignment: Alignment.bottomCenter,
),
```

**With Zoom Capability**

```dart
ProfileView(
image: NetworkImage('https://example.com/profile.jpg'),
enableZoom: true,
enableDoubleTapZoom: true,
),
```

**With Hero Animation**

```dart
ProfileView(
image: NetworkImage('https://example.com/profile.jpg'),
enableHeroAnimation: true,
heroTag: 'profile-hero-1',
),
```

**Fullscreen View on Enlarge**

```dart
ProfileView(
image: NetworkImage('https://example.com/profile.jpg'),
fullscreenOnEnlarge: true,
showCloseButton: true,
),
```

**Custom Loading and Error States**

```dart
ProfileView(
image: NetworkImage('https://example.com/profile.jpg'),
placeholder: CircularProgressIndicator(),
errorWidget: Icon(Icons.error),
loadingIndicatorColor: Colors.purple,
),
```

## Complete Parameter List

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `image` | `ImageProvider<Object>?` | `null` | The image to display |
| `height` | `double` | `50.0` | Height of the profile view |
| `width` | `double` | `50.0` | Width of the profile view |
| `isCircular` | `bool` | `true` | Whether the profile should be circular |
| `borderRadius` | `double` | `0.0` | Border radius for non-circular views |
| `dialogBackgroundColor` | `Color` | `Colors.transparent` | Background color for enlarged dialog |
| `blurIntensity` | `double` | `6.0` | Blur intensity for background when enlarged |
| `enlargedSizeFactor` | `double` | `0.8` | Size factor for enlarged image relative to screen |
| `borderWidth` | `double` | `0.0` | Border width for profile image |
| `borderColor` | `Color` | `Colors.transparent` | Border color for profile image |
| `placeholder` | `Widget?` | `null` | Widget to show while loading |
| `errorWidget` | `Widget?` | `null` | Widget to show on error |
| `overlayText` | `String?` | `null` | Text to display as overlay |
| `overlayTextStyle` | `TextStyle?` | `null` | Style for overlay text |
| `overlayBackgroundColor` | `Color` | `Colors.black54` | Background color for overlay |
| `overlayWidget` | `Widget?` | `null` | Custom widget to overlay |
| `overlayAlignment` | `Alignment` | `Alignment.bottomCenter` | Position of overlay |
| `enableZoom` | `bool` | `false` | Enable zoom in enlarged view |
| `enableDoubleTapZoom` | `bool` | `false` | Enable double-tap to zoom |
| `fullscreenOnEnlarge` | `bool` | `false` | Show enlarged view fullscreen |
| `fadeInDuration` | `Duration` | `300ms` | Duration for fade-in animation |
| `dialogAnimationDuration` | `Duration` | `300ms` | Duration for dialog animations |
| `onTap` | `VoidCallback?` | `null` | Callback when profile is tapped |
| `onLongPress` | `VoidCallback?` | `null` | Callback when profile is long-pressed |
| `cacheImage` | `bool` | `true` | Whether to cache the image |
| `enableHeroAnimation` | `bool` | `false` | Enable hero animations between views |
| `heroTag` | `String?` | `null` | Hero tag for animation (required if enableHeroAnimation is true) |
| `loadingIndicatorColor` | `Color` | `Colors.blue` | Color for loading indicator |
| `animationCurve` | `Curve` | `Curves.easeInOut` | Animation curve for transitions |
| `showBadge` | `bool` | `false` | Show badge indicator |
| `badgeColor` | `Color` | `Colors.green` | Badge color |
| `badgeSize` | `double` | `12.0` | Badge size |
| `badgeAlignment` | `Alignment` | `Alignment.bottomRight` | Badge position |
| `badgeBorderColor` | `Color` | `Colors.white` | Badge border color |
| `badgeBorderWidth` | `double` | `2.0` | Badge border width |
| `showCloseButton` | `bool` | `true` | Whether to show close button in fullscreen view |

## Example

See [Example App](example/lib/main.dart) for more detailed usage.

### Contributing
Every pull request is welcome.

## Contributors
Imtiaz Ahmad
- [![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/its_immi)
- [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/immi420)
- [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/imtiazahmadofficial/)


## License

This package is licensed under the MIT License.