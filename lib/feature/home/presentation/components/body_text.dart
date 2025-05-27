import 'package:flutter/material.dart';

class BodyText extends StatefulWidget {
  const BodyText({super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  State<BodyText> createState() => _BodyTextState();
}

class _BodyTextState extends State<BodyText> {
  bool _expanded = false;
  bool _isOverflow = false;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.body, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        _isOverflow = tp.didExceedMaxLines;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            GestureDetector(
              onTap: _isOverflow
                  ? () => setState(() => _expanded = !_expanded)
                  : null,
              child: _expanded || !_isOverflow
                  ? Text(widget.body, style: textStyle)
                  : Text.rich(
                      TextSpan(
                        text: widget.body,
                        style: textStyle,
                        children: const [
                          TextSpan(text: '...'),
                          TextSpan(
                            text: 'more',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        );
      },
    );
  }
}
