import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';
import '../widgets/movie_item.dart';

enum FilterOptions {
  favorites,
  all,
}

class MoviesOverviewScreen extends StatefulWidget {
  @override
  _MoviesOverviewScreenState createState() => _MoviesOverviewScreenState();
}

class _MoviesOverviewScreenState extends State<MoviesOverviewScreen> {
  var _showFavorites = false;
  var _isFabVisable = false;
  var _isLoading = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
    Provider.of<Movies>(context, listen: false).refreshMovies().then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    final scrollDirection = _scrollController.position.userScrollDirection;
    if (scrollDirection == ScrollDirection.forward) {
      if (_isFabVisable != true) {
        setState(() {
          _isFabVisable = true;
        });
      }
    } else if (scrollDirection == ScrollDirection.reverse) {
      if (_isFabVisable != false) {
        setState(() {
          _isFabVisable = false;
        });
      }
    }
  }

  Future<void> _refresh() async {
    if (!_showFavorites) {
      await Provider.of<Movies>(context, listen: false).refreshMovies();
    } else {
      setState(() {});
      return Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesData = Provider.of<Movies>(context);
    final movies =
        _showFavorites ? moviesData.favoriteMovies : moviesData.movies;
    return Scaffold(
      appBar: AppBar(
        title: Text(_showFavorites ? 'Favorites' : 'Movies'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(0);
              }
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('All Movies'),
                value: FilterOptions.all,
              ),
              const PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.favorites,
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refresh(),
              child: movies.isEmpty
                  ? Stack(
                      children: [
                        const Center(
                          child: Text(
                            'There is no movies at the moment',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                      ],
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (ctx, index) {
                        if (index == movies.length - 1 && !_showFavorites) {
                          moviesData.fetchMovies();
                        }
                        return ChangeNotifierProvider.value(
                          value: movies[index],
                          child: MovieItem(),
                        );
                      },
                      itemCount: movies.length,
                    ),
            ),
      floatingActionButton: _isFabVisable
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: const Duration(seconds: 1), curve: Curves.linear);

                setState(() {
                  _isFabVisable = false;
                });
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
