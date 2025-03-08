import 'package:flutter/material.dart';
import 'package:restoro_fav_app/common/navigation.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;

  const CustomScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            body,
            _buildShortAppBar(context),
          ],
        ),
      ),
    );
  }

  Card _buildShortAppBar(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigation.back();
            },
          ),
        ],
      ),
    );
  }
}
