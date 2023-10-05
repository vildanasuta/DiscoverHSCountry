import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SearchBar extends StatefulWidget {
  final List<City> cities;
  final void Function(List<City>) onSearch;
  final VoidCallback onCancel; // Add a callback for canceling the search

  const SearchBar({super.key, required this.cities, required this.onSearch, required this.onCancel});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final bool _isSearching = false;
    List<City> searchResults = []; // Define searchResults here

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final searchResults = widget.cities.where((city) {
      return city.name.toLowerCase().contains(query);
    }).toList();
    widget.onSearch(searchResults);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(CupertinoIcons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onCancel(); // Trigger the cancel callback
          },
          child: const Text('Cancel'),
        ),
        // Display search results
        if (_isSearching)
          ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final city = searchResults[index];
              return ListTile(
                title: Text(city.name),
                // Add more information about the city if needed
              );
            },
          ),
      ],
    );
  }
}
