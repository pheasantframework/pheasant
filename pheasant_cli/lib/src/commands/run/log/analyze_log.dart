// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'expr.dart';

String analyzeLog(String stream) {
  StringBuffer buffer = StringBuffer();
  if (stream.contains('WARNING')) {
    String newstream = stream.replaceFirst('[WARNING]', 'WARN -');
    if (stream.contains('AssetNotFoundException')) {
    } else if (stream.contains('this is not a known Builder')) {
    } else {
      buffer.write(newstream);
    }
  } else if (stream.contains('SEVERE')) {
    String newstream = stream.replaceFirst('[SEVERE]', 'PROBLEM -');
    if (stream.contains('AssetNotFoundException') ||
        stream.contains('Please check the following imports:')) {
      buffer.writeAll([
        'There is an error in your application. Fix the error in your pheasant files and try again.'
      ]);
    } else if (stream.contains('this is not a known Builder')) {
    } else if (stream.contains('phse:pheasantFileBuilder on')) {
      String filename = stream.split(' ')[3].replaceFirst('lib/', '');
      buffer.writeAll([
        'Error found in $filename: ',
        if (stream.split(':')[1].contains('RangeError (index):'))
          'There is no data in the file.'
      ]);
    } else {
      buffer.write(newstream);
    }
  }
  return buffer.toString();
}

String analyzeStream(String stream) {
  StringBuffer buffer = StringBuffer();
  buffer.writeln(extractExpressionInBrackets(stream));
  // if (stream.contains('Error')) {

  // }
  return buffer.toString();
}
