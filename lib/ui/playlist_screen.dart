import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/playlist_provider.dart';
import 'package:myapp/ui/profile_screen.dart';
import '../providers/reproductor_provider.dart';
import 'widgets/favorite_icon.dart';
import 'widgets/song_title.dart';
import 'package:myapp/providers/favorite_playlist_provider.dart';
import 'auth/home/home_screen.dart';
import 'favorite_list_screen.dart';

class PlaylistScreen extends ConsumerWidget {
  final Map<String, String?> searchQuery;
  const PlaylistScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistState = ref.watch(
      playlistProvider(searchQuery.values.join(" ")),
    );
    final reproductorController = ref.watch(reproductorProvider);
    final favoriteController = ref.read(favoritePlaylistProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: playlistState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          debugPrint("${error.toString()} and \n\n\n\n $stack \n\n\n\n");
          return Center(
            child: Text(error.toString()),
          );
        },
        data:
            (playlist) => Column(
              children: [
                Text(
                  playlist.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/runner.png',
                          height: 310,
                          width: 380,
                          fit: BoxFit.cover,
                        ),
                      ),
                      FavoriteIcon(
                        isFavorite: reproductorController.isFavorite,
                        onPressed: () {
                          favoriteController.toggleFavoritePlaylist(playlist);
                    
                    final isFav = ref.read(favoritePlaylistProvider.notifier).isFavorite(playlist.id);
                    final message = isFav ? 'Añadido a favoritos' : 'Eliminado de favoritos';
                    final snackBar = SnackBar(
                      backgroundColor: const Color(0xFF9B5DE5),
                      content: Text(
                        message,
                        style: TextStyle(
                          color: isFav ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'calSans',
                        ),
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: reproductorController.songs.length,
                    itemBuilder: (context, index) {
                      final song = reproductorController.songs[index];
                      return SongTitle(song: song);
                    },
                  ),
                ),
              ],
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(title: 'FitBeats'),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteListScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
