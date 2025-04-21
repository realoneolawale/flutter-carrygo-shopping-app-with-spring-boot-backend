import 'dart:io';

import 'package:http/io_client.dart';

// HttpClient _createHttpClient() {
//   final HttpClient client = HttpClient();
//   client.badCertificateCallback =
//       (X509Certificate cert, String host, int port) => true;
//   return client;
// }
// final client = IOClient(_createHttpClient());
//....
HttpClient _createHttpClient() {
  final HttpClient client = HttpClient();
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return client;
}

IOClient createUnsafeClient() {
  return IOClient(_createHttpClient());
}
