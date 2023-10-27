import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// {@tool snippet}
/// This is a sample of a [HorizontalDatePicker] widget.
/// It supports you can create a DatePicker with flexible count of items from [begin] to [end] by [itemCount].
/// By [itemCount] its can split into days, hours, minutes, seconds, that makes you can use this widget in many situations.
///
/// ```dart
///            HorizontalDatePicker(
///                 begin: DateTime.now(),
///                 end: DateTime.now().add(Duration(days: 40)),
///                 selected: DateTime.now(),
///                 onSelected: (item) {
///                 },
///                 itemBuilder: (DateTime itemValue, DateTime? selected) {
///                   var isSelected =
///                       selected?.difference(itemValue).inMilliseconds == 0;
///                   return Text(
///                     itemValue.formatted(pattern: "EEE\ndd/MM\nHH:mm:ss"),
///                     style: TextStyle(
///                       color: isSelected ? Colors.white : Colors.black54,
///                       fontSize: 12,
///                     ),
///                     textAlign: TextAlign.center,
///                   );
///                 },
///                 itemCount: 40,
///                 itemSpacing: 12,
///             )
/// ```
/// {@end-tool}
class HorizontalDatePicker extends StatefulWidget {
  final DateTime begin;
  final DateTime end;
  final DateTime? selected;
  final Function(DateTime selected)? onSelected;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;
  final Color selectedColor;
  final Color unSelectedColor;
  final Widget Function(DateTime itemValue, DateTime? selected) itemBuilder;
  final int itemCount;
  final bool needFocus;
  final Curve focusAnimationCurve;
  final Duration focusAnimationDuration;

  /// * [begin] is the begin DateTime.
  /// * [end] is the end DateTime.
  /// * [selected] is the selected DateTime.
  /// * [needFocus] if true {default} the selected item will be scrolled to the center of ListView.
  /// * [itemHeight] is height of date item, whole this widget also.
  /// * [itemWidth] is width of date item.
  /// * [itemSpacing] is the spacing between date items.
  /// * [onSelected] is the callback when users are pressed on an item.
  /// * [selectedColor] is the background color of selected item.
  /// * [unSelectedColor] is the background color of unselected item.
  /// * [itemBuilder] is the function that create the date items.
  /// * [itemCount] is total of items, it's used to calculate how many duration (step) between every item.
  /// * [focusAnimationCurve] use for animation when [needFocus] is true.
  /// * [focusAnimationDuration] use for animation when [needFocus] is true.

  const HorizontalDatePicker({
    Key? key,
    required this.begin,
    required this.end,
    this.selected,
    this.needFocus = true,
    this.itemHeight = 55,
    this.itemWidth = 55,
    this.itemSpacing = 0,
    this.onSelected,
    this.selectedColor = Colors.orangeAccent,
    this.unSelectedColor = Colors.white,
    required this.itemBuilder,
    required this.itemCount,
    this.focusAnimationCurve = Curves.elasticOut,
    this.focusAnimationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _HorizontalDatePickerState createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  final _scrollController = ScrollController();
  late Duration _step;

  @override
  void initState() {
    _checkParameters();
    _focusSelected(_getSelectedIndex());
    super.initState();
  }

  void _checkParameters() {
    _step = Duration(
        milliseconds: widget.end.difference(widget.begin).inMilliseconds ~/
            widget.itemCount);
    // debugPrint(
    //     '_HorizontalDatePickerState._checkParameters: step=${_step.inMilliseconds}');
  }

  @override
  void didUpdateWidget(HorizontalDatePicker oldWidget) {
    _checkParameters();

    if (oldWidget.selected != widget.selected) {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _focusSelected(_getSelectedIndex());
        });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.itemHeight,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final itemValue = widget.begin.add(_step * index);
          final bool isSelected =
              widget.selected == null ? false : _getSelectedIndex() == index;
          return FittedBox(
            child: Container(
              width: widget.itemWidth,
              height: widget.itemHeight,
              margin: EdgeInsets.only(
                left: index == 0 ? widget.itemSpacing : 0,
                right: widget.itemSpacing,
              ),
              color: isSelected ? widget.selectedColor : widget.unSelectedColor,
              child: ElevatedButton(
                onPressed: () {
                  // debugPrint(
                  //     '_HorizontalDatePickerState.onPressed: itemValue=$itemValue');
                  setState(() {
                    if (widget.onSelected != null)
                      widget.onSelected!(itemValue);
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(4),
                          )),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  elevation: MaterialStateProperty.all<double>(0.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  overlayColor:
                      MaterialStateProperty.all<Color>(widget.selectedColor),
                  minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                ),
                child: widget.itemBuilder(itemValue, widget.selected),
              ),
            ),
          );
        },
        itemCount: widget.itemCount,
      ),
    );
  }

  int _getSelectedIndex() {
    int result = -1;
    if (widget.selected == null) return result;
    // debugPrint(
    //     '_HorizontalDatePickerState._getSelectedIndex: selected=${widget.selected}');
    result = (widget.selected!.difference(widget.begin).inMilliseconds /
            _step.inMilliseconds)
        .round();
    return result;
  }

  void _focusSelected(int index) {
    // debugPrint('_HorizontalDatePickerState._focusSelected: index=$index');

    if (!widget.needFocus) return;
    if (index < 0 || index >= widget.itemCount) return;
    if (_scrollController.hasClients) {
      final itemSpacing = widget.itemSpacing;
      final itemW = widget.itemWidth;
      final parentW = (context.findRenderObject() as RenderBox).size.width;
      final double a = (parentW - itemW) * 0.5;
      final double b = (itemW + itemSpacing) * index + itemSpacing;
      double offset = b - a;

      offset = offset
          .clamp(0.0, _scrollController.position.maxScrollExtent)
          .toDouble();
      _scrollController.animateTo(offset,
          duration: widget.focusAnimationDuration,
          curve: widget.focusAnimationCurve);
    } else {
      /// sometime when initializing the scrollController have no client.
      Future.delayed(Duration(milliseconds: 200))
          .then((value) => _focusSelected(index));
    }
  }
}

/// A DateTime extension use for this for [HorizontalDatePicker]
extension HorizontalDatePickerDateTimeEx on DateTime {
  /// convert to a date at 00:00:00
  DateTime get to000000 => DateTime(this.year, this.month, this.day);

  /// format with [pattern]
  String formatted({String pattern = 'dd/MM'}) {
    try {
      final f = DateFormat(pattern);
      return f.format(this.toLocal());
    } catch (e) {
      // debugPrint('_DateTimeEx.formatted: $e');
      return '';
    }
  }
}
