library;

import 'dart:ui';

import 'package:flutter/material.dart';

/// A widget that displays a profile image with advanced features.
///
/// This widget provides a customizable profile image display with features like
/// tap-to-enlarge, overlays, border customization, placeholder handling,
/// loading states, and animation effects.
class ProfileView extends StatefulWidget {
  /// The image to display in the profile view.
  final ImageProvider<Object>? image;

  /// The height of the profile view. Defaults to 50.0.
  final double height;

  /// The width of the profile view. Defaults to 50.0.
  final double width;

  /// The border radius for non-circular profile views. Only used when [isCircular] is false.
  final double borderRadius;

  /// Whether the profile view should be circular. Defaults to true.
  final bool isCircular;

  /// The background color of the enlarged dialog. Defaults to transparent.
  final Color dialogBackgroundColor;

  /// The blur intensity for the background when showing the enlarged image.
  final double blurIntensity;

  /// The size factor for the enlarged image relative to screen height.
  final double enlargedSizeFactor;

  /// Border width for the profile image. Defaults to 0.
  final double borderWidth;

  /// Border color for the profile image. Defaults to transparent.
  final Color borderColor;

  /// Placeholder widget to show when the image is loading or null.
  final Widget? placeholder;

  /// Widget to show when the image fails to load.
  final Widget? errorWidget;

  /// Text to display as an overlay on the profile image.
  final String? overlayText;

  /// Style for the overlay text.
  final TextStyle? overlayTextStyle;

  /// Background color for the overlay text.
  final Color overlayBackgroundColor;

  /// Custom widget to overlay on the profile image.
  final Widget? overlayWidget;

  /// Position of the overlay (text or widget).
  final Alignment overlayAlignment;

  /// Whether to enable zoom capabilities in the enlarged view.
  final bool enableZoom;

  /// Whether to enable double-tap to zoom.
  final bool enableDoubleTapZoom;

  /// Whether to show the enlarged image in a fullscreen view.
  final bool fullscreenOnEnlarge;

  /// Duration for the fade-in animation.
  final Duration fadeInDuration;

  /// Duration for dialog open/close animations
  final Duration dialogAnimationDuration;

  /// Callback when the profile is tapped.
  final VoidCallback? onTap;

  /// Callback when the profile is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether to cache the image.
  final bool cacheImage;

  /// Whether to enable hero animations between the thumbnail and enlarged view.
  final bool enableHeroAnimation;

  /// Hero tag for the animation. Required if enableHeroAnimation is true.
  final String? heroTag;

  /// Color for the loading indicator.
  final Color loadingIndicatorColor;

  /// Animation curve for open/close transitions
  final Curve animationCurve;

  /// Show badge indicator (like for online status)
  final bool showBadge;

  /// Badge color
  final Color badgeColor;

  /// Badge size
  final double badgeSize;

  /// Badge position
  final Alignment badgeAlignment;

  /// Badge border color
  final Color badgeBorderColor;

  /// Badge border width
  final double badgeBorderWidth;

  /// Whether to show close button in fullscreen view
  final bool showCloseButton;

  /// Creates a profile view widget with advanced features.
  ///
  /// The [image] parameter can be null, in which case the [placeholder] will be shown.
  const ProfileView({
    super.key,
    this.image,
    this.height = 50.0,
    this.width = 50.0,
    this.isCircular = true,
    this.borderRadius = 0.0,
    this.dialogBackgroundColor = Colors.transparent,
    this.blurIntensity = 6.0,
    this.enlargedSizeFactor = 0.8,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.placeholder,
    this.errorWidget,
    this.overlayText,
    this.overlayTextStyle,
    this.overlayBackgroundColor = Colors.black54,
    this.overlayWidget,
    this.overlayAlignment = Alignment.bottomCenter,
    this.enableZoom = false,
    this.enableDoubleTapZoom = false,
    this.fullscreenOnEnlarge = false,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.dialogAnimationDuration = const Duration(milliseconds: 300),
    this.onTap,
    this.onLongPress,
    this.cacheImage = true,
    this.enableHeroAnimation = false,
    this.heroTag,
    this.loadingIndicatorColor = Colors.blue,
    this.animationCurve = Curves.easeInOut,
    this.showBadge = false,
    this.badgeColor = Colors.green,
    this.badgeSize = 12.0,
    this.badgeAlignment = Alignment.bottomRight,
    this.badgeBorderColor = Colors.white,
    this.badgeBorderWidth = 2.0,
    this.showCloseButton = true,
  }) : assert(!enableHeroAnimation || heroTag != null,
            'heroTag must be provided when enableHeroAnimation is true');

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.fadeInDuration,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _loadImage();
  }

  @override
  void didUpdateWidget(ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _loadImage();
    }
  }

  void _loadImage() {
    if (widget.image != null) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      _preloadImage();
    } else {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _preloadImage() {
    if (widget.image == null) return;

    final ImageStream stream =
        widget.image!.resolve(const ImageConfiguration());
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool syncCall) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = false;
          });
          _animationController.forward();
        }
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      },
    );
    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? (() => _showEnlargedImage(context)),
      onLongPress: widget.onLongPress,
      child: _buildProfileContainer(),
    );
  }

  Widget _buildProfileContainer() {
    Widget profileWidget;

    if (_isLoading) {
      profileWidget = _buildLoadingWidget();
    } else if (_hasError || widget.image == null) {
      profileWidget = widget.errorWidget ?? _buildPlaceholderWidget();
    } else {
      profileWidget = _buildImageWidget();
    }

    final container = Container(
      key: _imageKey,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: widget.isCircular
            ? null
            : BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: widget.isCircular
            ? BorderRadius.circular(widget.width / 2)
            : BorderRadius.circular(widget.borderRadius),
        child: profileWidget,
      ),
    );

    if (widget.showBadge) {
      return Stack(
        children: [
          container,
          Positioned.fill(
            child: Align(
              alignment: widget.badgeAlignment,
              child: Container(
                width: widget.badgeSize,
                height: widget.badgeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.badgeColor,
                  border: Border.all(
                    color: widget.badgeBorderColor,
                    width: widget.badgeBorderWidth,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return container;
  }

  Widget _buildImageWidget() {
    Widget imageWidget = FadeTransition(
      opacity: _fadeAnimation,
      child: widget.enableHeroAnimation
          ? Hero(
              tag: widget.heroTag!,
              child: Image(
                image: widget.image!,
                fit: BoxFit.cover,
                height: widget.height,
                width: widget.width,
                errorBuilder: (context, error, stackTrace) {
                  return widget.errorWidget ?? _buildPlaceholderWidget();
                },
              ),
            )
          : Image(
              image: widget.image!,
              fit: BoxFit.cover,
              height: widget.height,
              width: widget.width,
              errorBuilder: (context, error, stackTrace) {
                return widget.errorWidget ?? _buildPlaceholderWidget();
              },
            ),
    );

    if (widget.overlayText != null || widget.overlayWidget != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          Positioned.fill(
            child: Align(
              alignment: widget.overlayAlignment,
              child: widget.overlayWidget ??
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: widget.overlayBackgroundColor,
                    child: Text(
                      widget.overlayText ?? '',
                      style: widget.overlayTextStyle ??
                          const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            ),
          ),
        ],
      );
    }

    return imageWidget;
  }

  Widget _buildLoadingWidget() {
    return widget.placeholder ??
        Center(
          child: SizedBox(
            height: widget.height / 2,
            width: widget.width / 2,
            child: CircularProgressIndicator(
              color: widget.loadingIndicatorColor,
              strokeWidth: 2,
            ),
          ),
        );
  }

  Widget _buildPlaceholderWidget() {
    return widget.placeholder ??
        Container(
          color: Colors.grey[200],
          child: Icon(
            Icons.person,
            size: widget.width * 0.6,
            color: Colors.grey[400],
          ),
        );
  }

  Future<void> _showEnlargedImage(BuildContext context) async {
    if (widget.image == null) return;

    // Get position in screen for animations
    final RenderBox? box =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    box?.localToGlobal(Offset.zero);

    if (widget.fullscreenOnEnlarge) {
      await Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: widget.dialogAnimationDuration,
          reverseTransitionDuration: widget.dialogAnimationDuration,
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return _EnlargedImageView(
              image: widget.image!,
              isCircular: widget.isCircular,
              enableZoom: widget.enableZoom,
              enableDoubleTapZoom: widget.enableDoubleTapZoom,
              heroTag: widget.enableHeroAnimation ? widget.heroTag : null,
              animationDuration: widget.dialogAnimationDuration,
              animationCurve: widget.animationCurve,
              showCloseButton: widget.showCloseButton,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (widget.enableHeroAnimation) {
              return child; // Hero animation will handle the transition
            }

            animation = CurvedAnimation(
                parent: animation, curve: widget.animationCurve);

            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      await showGeneralDialog(
        context: context,
        barrierColor: Colors.black54,
        barrierDismissible: true,
        barrierLabel: "Profile Image",
        transitionDuration: widget.dialogAnimationDuration,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          if (widget.enableHeroAnimation) {
            return child; // Hero animation will handle the transition
          }

          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: widget.animationCurve,
          );

          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        pageBuilder: (BuildContext context, _, __) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blurIntensity,
                sigmaY: widget.blurIntensity,
              ),
              child: Dialog(
                insetPadding: const EdgeInsets.all(16),
                backgroundColor: widget.dialogBackgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isCircular ? 1000 : 16),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        widget.enlargedSizeFactor,
                    maxWidth: MediaQuery.of(context).size.width *
                        widget.enlargedSizeFactor,
                  ),
                  child: widget.enableZoom
                      ? _ZoomableImage(
                          image: widget.image!,
                          isCircular: widget.isCircular,
                          enableDoubleTapZoom: widget.enableDoubleTapZoom,
                          heroTag: widget.enableHeroAnimation
                              ? widget.heroTag
                              : null,
                        )
                      : widget.enableHeroAnimation
                          ? Hero(
                              tag: widget.heroTag!,
                              child: widget.isCircular
                                  ? CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      backgroundImage: widget.image!)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image(
                                          image: widget.image!,
                                          fit: BoxFit.contain),
                                    ),
                            )
                          : widget.isCircular
                              ? CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.3,
                                  backgroundImage: widget.image!)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image(
                                      image: widget.image!,
                                      fit: BoxFit.contain),
                                ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

class _EnlargedImageView extends StatefulWidget {
  final ImageProvider<Object> image;
  final bool isCircular;
  final bool enableZoom;
  final bool enableDoubleTapZoom;
  final String? heroTag;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showCloseButton;

  const _EnlargedImageView({
    required this.image,
    this.isCircular = true,
    this.enableZoom = false,
    this.enableDoubleTapZoom = false,
    this.heroTag,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.showCloseButton = true,
  });

  @override
  State<_EnlargedImageView> createState() => _EnlargedImageViewState();
}

class _EnlargedImageViewState extends State<_EnlargedImageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeWithAnimation() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use WillPopScope to handle back button press with animation
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _closeWithAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Scaffold(
              backgroundColor:
                  Colors.black.withValues(alpha: 0.9 * _animation.value),
              extendBodyBehindAppBar: true,
              appBar: widget.showCloseButton
                  ? AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _closeWithAnimation,
                      ),
                    )
                  : null,
              body: Center(
                child: widget.enableZoom
                    ? _ZoomableImage(
                        image: widget.image,
                        isCircular: widget.isCircular,
                        enableDoubleTapZoom: widget.enableDoubleTapZoom,
                        heroTag: widget.heroTag,
                      )
                    : widget.heroTag != null
                        ? Hero(
                            tag: widget.heroTag!,
                            child: widget.isCircular
                                ? CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * 0.6,
                                    backgroundImage: widget.image,
                                  )
                                : Image(
                                    image: widget.image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  ),
                          )
                        : widget.isCircular
                            ? CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.6,
                                backgroundImage: widget.image,
                              )
                            : Image(
                                image: widget.image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ZoomableImage extends StatefulWidget {
  final ImageProvider<Object> image;
  final bool isCircular;
  final bool enableDoubleTapZoom;
  final String? heroTag;

  const _ZoomableImage({
    required this.image,
    this.isCircular = true,
    this.enableDoubleTapZoom = false,
    this.heroTag,
  });

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  final double _minScale = 0.8;
  final double _maxScale = 4.0;
  TapDownDetails? _doubleTapDetails;
  final ValueNotifier<bool> _isZoomed = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;

          // Update the zoomed state for UI feedback
          final double scale =
              _transformationController.value.getMaxScaleOnAxis();
          _isZoomed.value = scale > 1.1;
        }
      });

    // Listen for transformation changes to update zoom state
    _transformationController.addListener(() {
      final double scale = _transformationController.value.getMaxScaleOnAxis();
      _isZoomed.value = scale > 1.1;
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    _isZoomed.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (!widget.enableDoubleTapZoom) return;

    final position = _doubleTapDetails!.localPosition;
    final Matrix4 matrix = _transformationController.value;
    final double currentScale = matrix.getMaxScaleOnAxis();

    Matrix4 endMatrix;
    if (currentScale <= 1.0) {
      // Zoom in to twice the size
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 1.0, -position.dy * 1.0)
        ..scale(2.0, 2.0)
        ..translate(position.dx, position.dy);
    } else {
      // Zoom out to normal size
      endMatrix = Matrix4.identity();
    }

    _animateMatrix(endMatrix);
  }

  void _animateMatrix(Matrix4 endMatrix) {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeInOut).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    final double currentScale =
        _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < _minScale) {
      final Matrix4 resetMatrix = Matrix4.identity();
      _animateMatrix(resetMatrix);
    } else if (currentScale > _maxScale) {
      final Matrix4 scaledMatrix = Matrix4.copy(_transformationController.value)
        ..scale(_maxScale / currentScale);
      _animateMatrix(scaledMatrix);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = InteractiveViewer(
      transformationController: _transformationController,
      minScale: _minScale,
      maxScale: _maxScale,
      onInteractionEnd: _onInteractionEnd,
      clipBehavior: Clip.none,
      child: widget.isCircular
          ? CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.4,
              backgroundImage: widget.image,
            )
          : Image(
              image: widget.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                );
              },
            ),
    );

    if (widget.enableDoubleTapZoom) {
      imageWidget = GestureDetector(
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        child: imageWidget,
      );
    }

    // Add zoom indicator
    imageWidget = Stack(
      children: [
        imageWidget,
        ValueListenableBuilder<bool>(
          valueListenable: _isZoomed,
          builder: (context, isZoomed, child) {
            return Positioned(
              bottom: 16,
              right: 16,
              child: AnimatedOpacity(
                opacity: isZoomed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "Zoomed",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
