import 'dart:io';

bool searchFile(String fileName, String directoryPath) {
  // Create a Directory object for the specified directory path
  Directory directory = Directory(directoryPath);

  // List all files in the directory
  List<FileSystemEntity> files = directory.listSync();

  // Search for the file with the specified name
  for (FileSystemEntity file in files) {
    if (file is File && file.uri.pathSegments.last == fileName) {
      return true;
    }
  }

  // If the loop completes without finding the file
  return false;
}
