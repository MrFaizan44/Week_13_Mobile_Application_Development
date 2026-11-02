import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Gallery',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    GalleryPage(),
    AlbumPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            activeIcon: Icon(Icons.photo_album),
            label: 'Album',
          ),
        ],
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  final List<String> images = const [
    'assets/images/my image1.png',
    'assets/images/image2.png',
    'assets/images/photo3.png',
    'assets/images/photo4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Photo Gallery'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final isNetwork = images[index].startsWith('http');
          final heroTag = 'gallery-$index';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleImageDetailPage(
                    imagePath: images[index],
                    heroTag: heroTag,
                  ),
                ),
              );
            },
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isNetwork
                    ? Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SingleImageDetailPage extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const SingleImageDetailPage({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = imagePath.startsWith('http');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: heroTag,
            child: InteractiveViewer(
              child: isNetwork
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlbumModel {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> images;

  const AlbumModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.images,
  });
}

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  final List<AlbumModel> albums = const [
    AlbumModel(
      name: 'My Photos',
      icon: Icons.person,
      color: Colors.blue,
      images: [
        'assets/images/my image1.png',
        'assets/images/image2.png',
        'assets/images/photo3.png',
        'assets/images/photo4.png',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white54,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final album = albums[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumDetailScreen(album: album),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: album.color.withValues(alpha: 0.15),
                      child: Icon(
                        album.icon,
                        size: 26,
                        color: album.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      album.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${album.images.length} images',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AlbumDetailScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumDetailScreen({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: album.images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final imagePath = album.images[index];
          final isNetwork = imagePath.startsWith('http');
          final heroTag = 'album-${album.name}-$index';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleImageDetailPage(
                    imagePath: imagePath,
                    heroTag: heroTag,
                  ),
                ),
              );
            },
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isNetwork
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
