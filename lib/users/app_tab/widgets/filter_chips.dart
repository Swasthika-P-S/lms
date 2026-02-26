import 'package:flutter/material.dart';
import '../utils/colors.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterChips({
    Key? key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 50,
      color: AppColors.getBackground(context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFilter == filters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: isSelected,
              onSelected: (selected) {
                onFilterSelected(filters[index]);
              },
              backgroundColor: AppColors.getCard(context),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected 
                    ? Colors.white 
                    : (isDarkMode 
                        ? Colors.white70 
                        : Colors.black54),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected 
                    ? AppColors.primary 
                    : (isDarkMode 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.3)),
                width: 1,
              ),
              elevation: isDarkMode ? 0 : 2,
              shadowColor: Colors.black.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }
}
