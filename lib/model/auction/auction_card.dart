import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard(
      {Key? key, required this.onPressed, required this.valueChanged})
      : super(key: key);
  final VoidCallback onPressed;
  final VoidCallback valueChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Ink.image(
                image: const NetworkImage(''),
                height: 240,
                fit: BoxFit.cover,
              ),
              const Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: Text(
                  'Cats rule the world!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            child: const Text(
              'The cat is the only domesticated species in the family Felidae and is often referred to as the domestic cat to distinguish it from the wild members of the family.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                child: const Text('Start Bidding'),
                onPressed: onPressed,
              ),
              FavoriteButton(
                valueChanged: valueChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
