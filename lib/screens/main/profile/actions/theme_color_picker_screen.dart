import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThemeColorPickerScreen extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorSelected;

  const ThemeColorPickerScreen({
    Key? key,
    required this.initialColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  _ThemeColorPickerScreenState createState() => _ThemeColorPickerScreenState();
}

class _ThemeColorPickerScreenState extends State<ThemeColorPickerScreen> {
  late Color _selectedColor;
  late HSVColor _hsvColor;
  late double _hue;
  late double _saturation;
  late double _value;
  late TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _hsvColor = HSVColor.fromColor(_selectedColor);
    _hue = _hsvColor.hue;
    _saturation = _hsvColor.saturation;
    _value = _hsvColor.value;
    _hexController = TextEditingController(text: _colorToHex(_selectedColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  Color _hexToColor(String hexString) {
    try {
      final hexCode = hexString.replaceFirst('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return _selectedColor;
    }
  }

  void _updateColor({double? hue, double? saturation, double? value}) {
    setState(() {
      _hue = hue ?? _hue;
      _saturation = saturation ?? _saturation;
      _value = value ?? _value;
      _hsvColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value);
      _selectedColor = _hsvColor.toColor();
      _hexController.text = _colorToHex(_selectedColor);
    });
  }

  void _updateFromHex(String hexValue) {
    if (hexValue.length == 7 || hexValue.length == 6) {
      String formattedHex = hexValue;
      if (!formattedHex.startsWith('#') && hexValue.length == 6) {
        formattedHex = '#$hexValue';
      }

      final color = _hexToColor(formattedHex);
      final hsv = HSVColor.fromColor(color);

      setState(() {
        _selectedColor = color;
        _hsvColor = hsv;
        _hue = hsv.hue;
        _saturation = hsv.saturation;
        _value = hsv.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed to white background
      appBar: AppBar(
        backgroundColor: Colors.white, // Changed to white
        elevation: 0,
        title: Center(
          child: Text(
            _hexController.text,
            style: TextStyle(color: Colors.black), // Changed text color to black for contrast
          ),
        ),
        leading: IconButton(
          icon: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onColorSelected(_selectedColor);
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.black), // Changed text color to black
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Color preview
            Container(
              width: double.infinity,
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),

            // Hue slider
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    HSVColor.fromAHSV(1.0, 0, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, 60, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, 120, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, 180, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, 240, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, 300, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, 360, 1.0, 1.0).toColor(),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                  thumbColor: Colors.white,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  overlayColor: Colors.white.withOpacity(0.2),
                ),
                child: Slider(
                  value: _hue,
                  min: 0,
                  max: 360,
                  onChanged: (value) {
                    _updateColor(hue: value);
                  },
                ),
              ),
            ),

            // Saturation and brightness sliders in a row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  // Saturation slider
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            HSVColor.fromAHSV(1.0, _hue, 0.0, _value).toColor(),
                            HSVColor.fromAHSV(1.0, _hue, 1.0, _value).toColor(),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackShape: CustomTrackShape(),
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          overlayColor: Colors.white.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _saturation,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            _updateColor(saturation: value);
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  // Brightness slider
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            HSVColor.fromAHSV(1.0, _hue, _saturation, 0.0).toColor(),
                            HSVColor.fromAHSV(1.0, _hue, _saturation, 1.0).toColor(),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackShape: CustomTrackShape(),
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          overlayColor: Colors.white.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _value,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            _updateColor(value: value);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hex input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextField(
                controller: _hexController,
                decoration: InputDecoration(
                  labelText: 'Hex Color',
                  labelStyle: TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: _updateFromHex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom track shape to match the appearance in screenshot
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}