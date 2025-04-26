import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

ButtonStyleData dropdownButtonStyle() {
  return ButtonStyleData(
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
      color: Colors.white,
    ),
    elevation: 2,
  );
}

IconStyleData dropdownIconStyle() {
  return IconStyleData(
    icon: const Icon(Icons.arrow_drop_down),
    iconSize: 24,
    iconEnabledColor: Colors.grey[700],
    iconDisabledColor: Colors.grey[400],
  );
}

DropdownStyleData dropdownStyle(BuildContext context) {
  return DropdownStyleData(
    maxHeight: 250,
    width: MediaQuery.of(context).size.width / 2.3,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    elevation: 4,
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(10),
      thickness: WidgetStateProperty.all(4),
      thumbVisibility: WidgetStateProperty.all(true),
    ),
  );
}

MenuItemStyleData dropdownMenuStyle() {
  return const MenuItemStyleData(
    height: 45,
    padding: EdgeInsets.symmetric(horizontal: 14),
  );
}
