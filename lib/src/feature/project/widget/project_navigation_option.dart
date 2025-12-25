import 'package:flutter/material.dart';

class ProjectNavigationOption extends StatelessWidget {
  const ProjectNavigationOption({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
      selected: selected,
      selectedTileColor: Colors.grey.shade800,
    );
  }
}
