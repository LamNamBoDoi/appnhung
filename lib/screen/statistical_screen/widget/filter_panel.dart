import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dropdown_style.dart';

class FilterPanel extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final String? selectedClass;
  final List<String> classList;
  final Function(int) onChangedMonth;
  final Function(int) onChangedYear;
  final Function(String?) onChangedClass;

  const FilterPanel({
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedClass,
    required this.classList,
    required this.onChangedMonth,
    required this.onChangedYear,
    required this.onChangedClass,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (i) => 'Tháng ${i + 1}');
    final years = List.generate(12, (i) => DateTime.now().year - 10 + i);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Text('Chọn tháng'),
                    items: months
                        .asMap()
                        .entries
                        .map((entry) => DropdownMenuItem<String>(
                              value: entry.key.toString(),
                              child: Text(entry.value),
                            ))
                        .toList(),
                    value: (selectedMonth - 1).toString(),
                    onChanged: (value) => onChangedMonth(int.parse(value!) + 1),
                    buttonStyleData: dropdownButtonStyle(),
                    iconStyleData: dropdownIconStyle(),
                    dropdownStyleData: dropdownStyle(context),
                    menuItemStyleData: dropdownMenuStyle(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Text('Chọn năm'),
                    items: years
                        .map((year) => DropdownMenuItem<String>(
                              value: year.toString(),
                              child: Text(year.toString()),
                            ))
                        .toList(),
                    value: selectedYear.toString(),
                    onChanged: (value) => onChangedYear(int.parse(value!)),
                    buttonStyleData: dropdownButtonStyle(),
                    iconStyleData: dropdownIconStyle(),
                    dropdownStyleData: dropdownStyle(context),
                    menuItemStyleData: dropdownMenuStyle(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: const Text('Chọn lớp'),
              items: classList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              value: selectedClass,
              onChanged: onChangedClass,
              buttonStyleData: dropdownButtonStyle(),
              iconStyleData: dropdownIconStyle(),
              dropdownStyleData: dropdownStyle(context),
              menuItemStyleData: dropdownMenuStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
