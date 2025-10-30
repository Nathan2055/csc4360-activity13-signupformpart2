import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

// Define dropdown menu for avatar selection
typedef IconEntry = DropdownMenuEntry<IconLabel>;

enum IconLabel {
  smiley('Smiley Face', Icons.sentiment_satisfied_outlined),
  rocket('Rocket', Icons.rocket),
  pawprint('Paw Print', Icons.pets);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;

  static final List<IconEntry> entries = UnmodifiableListView<IconEntry>(
    values.map<IconEntry>(
      (IconLabel icon) => IconEntry(
        value: icon,
        label: icon.label,
        leadingIcon: Icon(icon.icon),
      ),
    ),
  );
}
