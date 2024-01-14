import 'dart:io';

void searchFile(String fileName, String directoryPath) {
  // Create a Directory object for the specified directory path
  Directory directory = Directory(directoryPath);

  // List all files in the directory
  List<FileSystemEntity> files = directory.listSync();

  // Search for the file with the specified name
  for (FileSystemEntity file in files) {
    if (file is File && file.uri.pathSegments.last == fileName) {
      print('File found: ${file.path}');
      return; // Stop searching once the file is found
    }
  }

  // If the loop completes without finding the file
  print('File not found: $fileName');
}

void main() {
  // Specify the name of the file you want to search for
  String fileNameToSearch = 'pubspec.yaml';

  // Specify the directory path where you want to search for the file
  String directoryPath = '..';

  // Call the searchFile function with the specified file name and directory path
  searchFile(fileNameToSearch, directoryPath);
}