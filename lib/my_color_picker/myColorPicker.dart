import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyColorPicker extends StatefulWidget {
  final Color pickerColor;
  final List paletteColors;
  final ValueChanged<Color> onColorChanged;

  const MyColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    required this.paletteColors
  }) : super(key: key);

  @override
  State<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {

  double _borderRadius = 30;
  double _iconSize = 24;
  bool colorsListExist=false;
  int size=0;


  Widget pickerLayoutBuilder(BuildContext context, List<Color> colors, PickerItem child) {
    if(widget.paletteColors.isNotEmpty) {
      size = widget.paletteColors.length;
    }
    return SizedBox(
      height: 100,
      child: size!=0?GridView.count(
        crossAxisCount: size,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        children: [for (Color color in widget.paletteColors) child(color)],//:Text("None"),
      ):Container(child: const Text("None"),padding: const EdgeInsets.fromLTRB(15.0,0.0,0.0,0.0),),
    );
  }

  Widget pickerItemBuilder(Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),

              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HueRingPicker(
                      pickerColor: widget.pickerColor,
                      onColorChanged: widget.onColorChanged,
                    ),
                    Container(child: const Text("Suggested Colors:"),padding: const EdgeInsets.all(10.0),),
                    BlockPicker(
                      pickerColor: widget.pickerColor,
                      onColorChanged: widget.onColorChanged,
                      layoutBuilder: pickerLayoutBuilder,
                      itemBuilder: pickerItemBuilder,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.color_lens_outlined),
      backgroundColor: const Color(0xFFF87217),
    );
  }
}