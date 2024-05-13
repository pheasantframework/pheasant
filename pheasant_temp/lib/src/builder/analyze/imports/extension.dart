// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


/// Function to help get file extension, without using the `path` package
String fileExtension(String filePath) {
  return Uri.file(filePath).path.split('.').last.replaceFirst('\'', '');
}
