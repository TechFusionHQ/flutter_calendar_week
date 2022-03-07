import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/src/cache_stream_widget.dart';
import 'package:flutter_calendar_week/src/utils/cache_stream.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';

class DateItem extends StatefulWidget {
  /// Today
  final DateTime today;

  /// Date of item
  final DateTime? date;

  /// Style of [date]
  final TextStyle? dateStyle;

  /// Background
  final Color? dateBgColor;

  /// Style of day after pressed
  final TextStyle? highlightDateStyle;

  /// Specify a background after pressed
  final Color? highlightDateBgColor;

  /// Specify a splash color on pressed
  final Color? splashColor;

  /// Alignment a decoration
  final Alignment? decorationAlignment;

  /// Specify a shape
  final OutlinedBorder? dayShapeBorder;

  /// [Callback] function for press event
  final void Function(DateTime)? onDatePressed;

  /// [Callback] function for long press event
  final void Function(DateTime)? onDateLongPressed;

  /// Decoration widget
  final Widget? decoration;

  /// [cacheStream] for emit date press event
  final CacheStream<DateTime?> cacheStream;

  DateItem({
    required this.today,
    required this.date,
    required this.cacheStream,
    this.dateStyle,
    this.dateBgColor = Colors.transparent,
    this.highlightDateStyle,
    this.highlightDateBgColor,
    this.decorationAlignment = FractionalOffset.center,
    this.dayShapeBorder,
    this.onDatePressed,
    this.onDateLongPressed,
    this.decoration,
    this.splashColor = Colors.white,
  });

  @override
  __DateItemState createState() => __DateItemState();
}

class __DateItemState extends State<DateItem> {
  /// Default background
  Color? _defaultBackgroundColor;

  /// Default style
  TextStyle? _defaultTextStyle;

  @override
  Widget build(BuildContext context) => widget.date != null
      ? CacheStreamBuilder<DateTime?>(
          cacheStream: widget.cacheStream,
          cacheBuilder: (_, data) {
            /// Set default each [builder] is called
            _defaultBackgroundColor = widget.dateBgColor;

            /// Set default style each [builder] is called
            _defaultTextStyle = widget.dateStyle;

            // Set bg and style for highlight Date (default is Today)
            var dateSelected = widget.today;
            if (!data.hasError && data.hasData) {
              dateSelected = data.data ?? widget.today;
            }
            if (compareDate(widget.date, dateSelected)) {
              _defaultBackgroundColor = widget.highlightDateBgColor;
              _defaultTextStyle = widget.highlightDateStyle;
            }

            return _body();
          },
        )
      : Container(
          width: 50,
          height: 50,
        );

  /// Body layout
  Widget _body() => Container(
        width: 36,
        height: 36,
        alignment: FractionalOffset.center,
        child: GestureDetector(
          onLongPress: _onLongPressed,
          child: TextButton(
              onPressed: _onPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(5),
                backgroundColor: _defaultBackgroundColor!,
                shape: widget.dayShapeBorder!,
                primary: widget.splashColor,
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${widget.date!.day}',
                        style: _defaultTextStyle!,
                      ),
                    ),
                  ),
                  _decoration()
                ],
              )),
        ),
      );

  /// Decoration layout
  Widget _decoration() => Positioned(
        top: 28,
        left: 0,
        right: 0,
        child: Container(
            width: 50,
            height: 12,
            alignment: widget.decorationAlignment,
            child: widget.decoration != null
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: widget.decoration!,
                  )
                : Container()),
      );

  /// Handler press event
  void _onPressed() {
    if (widget.date != null) {
      widget.cacheStream.add(widget.date);
      widget.onDatePressed!(widget.date!);
    }
  }

  /// Handler long press event
  void _onLongPressed() {
    if (widget.date != null) {
      widget.cacheStream.add(widget.date);
      widget.onDateLongPressed!(widget.date!);
    }
  }
}
