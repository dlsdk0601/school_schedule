import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  final bool hasFavorite;
  final VoidCallback onPress;

  const FavoriteIcon({
    super.key,
    required this.hasFavorite,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      tooltip: "add favorite",
      icon: hasFavorite
          ? const Icon(
              Icons.star,
              color: Colors.white,
            )
          : const Icon(
              Icons.star_border,
              color: Colors.white,
            ),
    );
  }
}
