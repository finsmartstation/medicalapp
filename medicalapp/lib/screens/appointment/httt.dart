import 'package:flutter/material.dart';

class MultiselectDropdown extends StatefulWidget {
  const MultiselectDropdown({
    super.key,
  });

  @override
  _MultiselectDropdownState createState() => _MultiselectDropdownState();
}

class _MultiselectDropdownState extends State<MultiselectDropdown> {
  List<String> selectedItems = [];
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  String hintText = 'Select items';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            hintText: hintText,
          ),
          value: selectedItems.isEmpty ? null : selectedItems.join(', '),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedItems.contains(item),
                          onChanged: (value) {
                            setState(() {
                              print(selectedItems);
                              if (value != null && value) {
                                selectedItems.add(item);
                              } else {
                                selectedItems.remove(item);
                              }
                            });
                          },
                        ),
                        SizedBox(width: 8.0),
                        Text(item),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}
