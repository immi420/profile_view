import 'package:flutter/material.dart';
import 'package:profile_view/profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced ProfileView Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProfileDemoPage(),
    );
  }
}

class ProfileDemoPage extends StatefulWidget {
  const ProfileDemoPage({Key? key}) : super(key: key);

  @override
  State<ProfileDemoPage> createState() => _ProfileDemoPageState();
}

class _ProfileDemoPageState extends State<ProfileDemoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _userImages = [
    "https://picsum.photos/id/1012/300/300", // Person 1
    "https://picsum.photos/id/65/300/300", // Person 2
    "https://picsum.photos/id/1025/300/300", // Person 3
    "https://picsum.photos/id/338/300/300", // Architecture
    "https://picsum.photos/id/237/300/300", // Dog
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 5,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Elena Rodriguez",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Photographer & Digital Artist",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow(),
                  const SizedBox(height: 24),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "Basic"),
                      Tab(text: "Advanced"),
                      Tab(text: "Special Effects"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildBasicExamplesTab(),
                        _buildAdvancedExamplesTab(),
                        _buildSpecialEffectsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicExamplesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Basic Example Variants",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                // Standard circular profile
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[0]),
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 8),
                    const Text("Default Circular"),
                  ],
                ),

                // Square profile with border radius
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[0]),
                      height: 80,
                      width: 80,
                      isCircular: false,
                      borderRadius: 8,
                    ),
                    const SizedBox(height: 8),
                    const Text("Rectangular"),
                  ],
                ),

                // With custom border
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[0]),
                      height: 80,
                      width: 80,
                      borderWidth: 3,
                      borderColor: Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                    const Text("With Border"),
                  ],
                ),

                // With error case
                Column(
                  children: [
                    ProfileView(
                      image:
                          const NetworkImage("https://invalid-url.com/img.jpg"),
                      height: 80,
                      width: 80,
                      errorWidget: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Error State"),
                  ],
                ),

                // With placeholder
                Column(
                  children: [
                    ProfileView(
                      image: null,
                      height: 80,
                      width: 80,
                      placeholder: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("With Placeholder"),
                  ],
                ),

                // Disabled tap-to-enlarge
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[1]),
                      height: 80,
                      width: 80,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Custom tap action")));
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text("Custom Tap Action"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedExamplesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Advanced Features",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                // With text overlay
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[2]),
                      height: 80,
                      width: 80,
                      overlayText: "PRO",
                      overlayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overlayBackgroundColor: Colors.blue.withOpacity(0.7),
                    ),
                    const SizedBox(height: 8),
                    const Text("Text Overlay"),
                  ],
                ),

                // With widget overlay
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[2]),
                      height: 80,
                      width: 80,
                      overlayWidget: Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Widget Overlay"),
                  ],
                ),

                // With zoom enabled
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[3]),
                      height: 80,
                      width: 80,
                      enableZoom: true,
                      enableDoubleTapZoom: true,
                    ),
                    const SizedBox(height: 8),
                    const Text("Zoom Enabled"),
                  ],
                ),

                // With hero animation
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[3]),
                      height: 80,
                      width: 80,
                      enableHeroAnimation: true,
                      heroTag: "profile-hero-1",
                    ),
                    const SizedBox(height: 8),
                    const Text("Hero Animation"),
                  ],
                ),

                // Fullscreen on enlarge
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[4]),
                      height: 80,
                      width: 80,
                      fullscreenOnEnlarge: true,
                    ),
                    const SizedBox(height: 8),
                    const Text("Fullscreen View"),
                  ],
                ),

                // Custom animation duration
                Column(
                  children: [
                    ProfileView(
                      image: NetworkImage(_userImages[4]),
                      height: 80,
                      width: 80,
                      fadeInDuration: const Duration(milliseconds: 1500),
                    ),
                    const SizedBox(height: 8),
                    const Text("Custom Animation"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialEffectsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Special Effects & Combinations",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                // Team members row
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Team Members",
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(5, (index) {
                              final bool isOnline = index % 2 == 0;
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ProfileView(
                                          image: NetworkImage(_userImages[
                                              index % _userImages.length]),
                                          height: 70,
                                          width: 70,
                                          borderWidth: 2,
                                          borderColor: isOnline
                                              ? Colors.green
                                              : Colors.grey,
                                          fullscreenOnEnlarge: true,
                                          enableZoom: true,
                                        ),
                                        if (isOnline)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text("User ${index + 1}"),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Gallery grid
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Photo Gallery",
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: List.generate(6, (index) {
                            return ProfileView(
                              image: NetworkImage(
                                  _userImages[index % _userImages.length]),
                              isCircular: false,
                              borderRadius: 8,
                              enableZoom: true,
                              enableDoubleTapZoom: true,
                              fullscreenOnEnlarge: true,
                              overlayText: index == 0 ? "Featured" : null,
                              overlayTextStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overlayBackgroundColor: Colors.black54,
                              enableHeroAnimation: true,
                              heroTag: "gallery-$index",
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Advanced combination
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("User Profile Card",
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            ProfileView(
                              image: NetworkImage(_userImages[1]),
                              height: 100,
                              width: 100,
                              borderWidth: 3,
                              borderColor: Colors.deepPurple,
                              overlayWidget: Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.deepPurple,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.deepPurple,
                                    size: 20,
                                  ),
                                ),
                              ),
                              enableHeroAnimation: true,
                              heroTag: "profile-advanced",
                              enableZoom: true,
                              enableDoubleTapZoom: true,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Alex Johnson",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Product Designer",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        "San Francisco, CA",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("View Profile"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Posts", 342),
    ProfileInfoItem("Followers", 8420),
    ProfileInfoItem("Following", 512),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 35.0),
              child: Text(
                "Enhanced ProfileView Demo",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ProfileView(
                  image: NetworkImage(
                    "https://picsum.photos/id/1027/300/300",
                  ),
                  height: 150,
                  width: 150,
                  borderWidth: 4,
                  borderColor: Colors.white,
                  enableHeroAnimation: true,
                  heroTag: "main-profile",
                  enableZoom: true,
                  enableDoubleTapZoom: true,
                  fullscreenOnEnlarge: true,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
