import 'package:flutter/material.dart';

class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  List<String> selectedCuisines = [];

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Filter Restaurants',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildCategoryChip('American cuisine', setState),
                      _buildCategoryChip('Italian cuisine', setState),
                      _buildCategoryChip('Mexican cuisine', setState),
                      _buildCategoryChip('Chinese cuisine', setState),
                      _buildCategoryChip('Japanese cuisine', setState),
                      _buildCategoryChip('Mediterranean cuisine', setState),
                      _buildCategoryChip(
                          'Vegetarian and vegan cuisine', setState),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedCuisines);
                    },
                    child: Text('Apply Filter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedCuisines = List.from(result);
        });
      }
    });
  }

  Widget _buildCategoryChip(String label, StateSetter setState) {
    bool isSelected = selectedCuisines.contains(label);

    return InputChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            selectedCuisines.add(label);
          } else {
            selectedCuisines.remove(label);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Center(
        child: Text('Restaurant List Screen'),
      ),
    );
  }
}
