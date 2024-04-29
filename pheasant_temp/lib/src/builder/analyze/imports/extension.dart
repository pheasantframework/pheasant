/// Function to help get file extension, without using the `path` package
String fileExtension(String filePath) {
  return Uri.file(filePath).path.split('.').last.replaceFirst('\'', '');
}
