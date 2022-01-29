import 'package:flutter/material.dart';

/// 阅读器工具箱
class ReaderUtils {
  /// 根据内容长度、视图宽高、字号、行间距将内容分页
  /// The [content] e.g.移舟泊烟渚\n日暮客愁新
  static List<Map<String, int>> getPageOffsets(
    String content,
    double width,
    double height,
    double fontSize,
    double lineHeight,
  ) {
    String tempContent = content;
    List<Map<String, int>> pageConfig = [];
    int last = 0;
    while (true) {
      Map<String, int> offset = {};
      offset['start'] = last;
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
          text: tempContent,
          style: TextStyle(
            fontSize: fontSize,
            height: lineHeight,
          ));
      textPainter.layout(maxWidth: width);
      int end = textPainter.getPositionForOffset(Offset(width, height)).offset;
      if (end == 0) {
        break;
      }
      tempContent = tempContent.substring(end, tempContent.length);
      offset['end'] = last + end;
      last = last + end;
      pageConfig.add(offset);
    }
    return pageConfig;
  }

  /// 根据HTML格式的内容长度、视图宽高、字号、行间距将内容分页
  /// The [content] e.g.移舟泊烟渚<br />日暮客愁新
  static List<Map<String, int>> getPageOffsetsFromHTML(String content,
      double height, double width, double fontSize, double lineHeight) {
    String tempContent = content;
    List<Map<String, int>> pageConfig = [];
    int last = 0;

    while (true) {
      Map<String, int> offset = {};
      offset['start'] = last;
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
          text: tempContent,
          style: TextStyle(
            fontSize: fontSize,
            height: lineHeight,
          ));
      textPainter.layout(maxWidth: width);
      int end = textPainter.getPositionForOffset(Offset(width, height)).offset;
      if (end == 0) {
        break;
      }
      tempContent = tempContent.substring(end, tempContent.length);
      offset['end'] = last + end;
      last = last + end;
      pageConfig.add(offset);
    }
    return pageConfig;
  }
}
