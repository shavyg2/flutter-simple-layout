library simple_layout;

import 'dart:math';
import 'package:flutter/material.dart';


class Layout extends StatelessWidget {
  final String options;
  final Widget child;
  final _aRegex = RegExp(r'a-(\d+)');
  final _hRegex = RegExp(r'x-(\d+)');
  final _vRegex = RegExp(r'y-(\d+)');

  final _tRegex = RegExp(r't-(\d+)');
  final _bRegex = RegExp(r'b-(\d+)');
  final _lRegex = RegExp(r'l-(\d+)');
  final _rRegex = RegExp(r'r-(\d+)');

  final _allRegex = RegExp(r'[A-Za-z]-(\d+)');

  Layout({
    this.options,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    var fullOptions = "a-0 $options"
        .split(" ")
        .map(_convertAll)
        .join(" ")
        .split(" ")
        .map(_convertHorizontal)
        .join(" ")
        .split(" ")
        .map(_convertVertical)
        .join(" ")
        .split(" ")
        .where((x) => _allRegex.hasMatch(x))
        .toList();

    final _top = _getTop(fullOptions).last;
    final _left = _getLeft(fullOptions).last;
    final _right = _getRight(fullOptions).last;
    final _btm = _getBtm(fullOptions).last;

    return Padding(
      padding: EdgeInsets.only(
        top: _convertToSize(context, _top),
        left: _convertToSize(context, _left),
        right: _convertToSize(context, _right),
        bottom: _convertToSize(context, _btm),
      ),
      child: child,
    );
  }

  String _convertAll(String option) {
    if (_aRegex.hasMatch(option)) {
      final size = _aRegex.firstMatch(option).group(1);
      return "x-$size y-$size";
    } else {
      return option;
    }
  }

  String _convertHorizontal(String option) {
    if (_hRegex.hasMatch(option)) {
      final size = _hRegex.firstMatch(option).group(1);
      return "l-$size r-$size";
    } else {
      return option;
    }
  }

  String _convertVertical(String option) {
    if (_vRegex.hasMatch(option)) {
      final size = _vRegex.firstMatch(option).group(1);
      return "t-$size b-$size";
    } else {
      return option;
    }
  }

  List<String> _getTop(List<String> options) {
    return options.where((x) => _tRegex.hasMatch(x)).toList();
  }

  List<String> _getLeft(List<String> options) {
    return options.where((x) => _lRegex.hasMatch(x)).toList();
  }

  List<String> _getRight(List<String> options) {
    return options.where((x) => _rRegex.hasMatch(x)).toList();
  }

  List<String> _getBtm(List<String> options) {
    return options.where((x) => _bRegex.hasMatch(x)).toList();
  }

  double _convertToSize(BuildContext context, String option) {
    final minSize = minScreenSize(context);
    final strSize = _allRegex.firstMatch(option).group(1);
    final multiplier = double.parse(strSize);

    final size = multiplier * 0.05 * minSize * 0.3;
    return size;
  }
}

double minScreenSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final minSize = min(size.width, size.height);
  return minSize;
}

double maxScreenSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final minSize = max(size.width, size.height);
  return minSize;
}