import 'package:flutter/material.dart';

class SelectCustom extends StatefulWidget {
  final String nameSelect, hint;
  final List<String> options;
  final Function action;
  SelectCustom({this.nameSelect, this.hint, this.options, this.action});

  @override
  _SelectCustomState createState() => _SelectCustomState();
}

class _SelectCustomState extends State<SelectCustom> {
  //Item selected
  String selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: DropdownButton<String>(
          value: selectedItem,
          isExpanded: true,
          icon: Icon(Icons.arrow_downward),
          iconSize: 20,
          elevation: 0,
          hint: Text(
            widget.hint,            
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              letterSpacing: 1.2
            ),
          ),
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.pink,
          ),
          onChanged: (val) => {
            this.setState(() => selectedItem = val),
            widget.action(selectedItem)
          },
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
