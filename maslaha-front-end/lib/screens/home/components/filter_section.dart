import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  FilterSection({
    required this.filterTitle,
    this.filterDescription,
    this.children,
    required this.enabled,
    this.onEnabled,
  });

  final String filterTitle;
  final String? filterDescription;
  final List<Widget>? children;
  bool enabled;
  final Function(bool)? onEnabled;

  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 16, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.filterTitle,
                style: const TextStyle(
                  color: Colors.black,
                  // fontFamily: 'OpenSans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: widget.enabled,
                onChanged: widget.onEnabled,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, top: 6, right: 10),
          child: Text(
            widget.filterDescription ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
        Column(
          children: widget.children ?? [],
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 4,
        ),
      ],
    );
  }
}
