// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Category {
  const Category(this.catTitle, this.color);

  final String catTitle;
  final Color color;

  @override
  String toString() => 'Category(catTitle: $catTitle, color: $color)';
}
