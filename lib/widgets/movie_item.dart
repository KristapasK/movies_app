import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movies_app/widgets/description_overlay.dart';
import 'package:provider/provider.dart';

import '../providers/movie.dart';

class MovieItem extends StatelessWidget {
  late OverlayEntry entry;

  MovieItem() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => showOverlay);
  }

  void showOverlay(BuildContext context, String description) {
    final overlay = Overlay.of(context);
    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: hideOverlay,
        child: DescriptionOverlay(description),
      ),
    );
    overlay!.insert(entry);
  }

  void hideOverlay() {
    entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    final movie = Provider.of<Movie>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            showOverlay(context, movie.description);
          },
          child: Image.network(
            movie.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        header: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  movie.voteAverage.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            ),
            title: const Text(''),
            trailing: Consumer<Movie>(
              builder: (ctx, movie, _) => IconButton(
                icon: Icon(
                  movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                alignment: Alignment.centerRight,
                onPressed: () {
                  movie.toggleFavoriteStatus();
                },
              ),
            )),
        footer: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(8),
          child: GridTileBar(
            title: Text(
              movie.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
