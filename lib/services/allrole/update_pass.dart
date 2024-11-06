import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> updatePassword({
  required int userId,
  String makerID = '58', // Default makerID
  required String oldPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  // Define the API endpoint URL
  final String url = 'https://ukkcafe.smktelkom-mlg.sch.id/api/updatepass/$userId';

  // Set headers with default makerID
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'makerID': makerID,
  };

  // Set body fields
  var bodyFields = {
    'old_password': oldPassword,
    'new_password': newPassword,
    'confirm_password': confirmPassword,
  };

  // Create the PUT request
  var request = http.Request('PUT', Uri.parse(url))
    ..headers.addAll(headers)
    ..bodyFields = bodyFields;

  // Send the request
  http.StreamedResponse response = await request.send();

  // Check if the response was successful
  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    print('Password update success: $responseData');
    return true;
  } else {
    print('Failed to update password: ${response.reasonPhrase}');
    return false;
  }
}
