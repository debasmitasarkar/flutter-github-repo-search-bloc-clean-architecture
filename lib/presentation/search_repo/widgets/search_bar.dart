import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_repo_search/core/constants/style_constants.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onClear,
  });
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback onClear;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late ValueNotifier<bool> hasText;

  @override
  void initState() {
    super.initState();
    hasText = ValueNotifier(widget.searchController.text.isNotEmpty);
    widget.searchController.addListener(textListener);
  }

  void textListener() {
    hasText.value = widget.searchController.text.isNotEmpty;
  }

  @override
  void dispose() {
    hasText.dispose();
    widget.searchController.removeListener(textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(256),
      ],
      decoration: InputDecoration(
        suffixIcon: ValueListenableBuilder(
          valueListenable: hasText,
          builder: (context, value, child) {
            if (value) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.searchController.clear();
                  widget.onClear();
                },
              );
            }
            return const SizedBox();
          },
        ),
        hintText: 'Search for a repository...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: ColorConstants.grey800,
      ),
      onChanged: (value) {
        if (value.length >= 4) {
          widget.onSearch(value);
        }
      },
    );
  }
}
