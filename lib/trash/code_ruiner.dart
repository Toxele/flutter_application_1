import 'dart:math';

import 'package:flutter/material.dart';

class CodeRuiner
{
  int? _x;
  void randomizex(BuildContext context)
  {
    _x = 9;
    if(_x == 9)
    {
      Navigator.of(context).pop();
    } 
  }
}