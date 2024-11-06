import 'package:http/http.dart' as http;

Future<bool> updateUserName({
  required int id,
  required String userName,
}) async {
  // Define the API endpoint URL
  final String url = 'https://ukkcafe.smktelkom-mlg.sch.id/api/updatename/$id';
  const String makerID = '58';

  // Set headers
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'makerID': makerID,
  };

  // Set body fields
  var bodyFields = {
    'user_name': userName,
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
    print('Update success: $responseData');
    return true;
  } else {
    print('Failed to update user name: ${response.reasonPhrase}');
    return false;
  }
}
