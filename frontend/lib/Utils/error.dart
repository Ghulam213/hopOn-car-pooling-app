import 'dart:developer';

mixin AppErrors {
  /// A method for parsing dart errors, due to backend automatically printing errors
  /// based on the field that is fault i.e password in a login function.
  ///
  /// We'll go from the most basic response structures, the one with just the error
  ///   {
  ///     "message": "error"
  /// }
  ///
  /// Then we'll move to the most complex ones, parsing erros by the field in the http response,
  /// so if password is incorrect or if a name is in correct we'll find out
  ///
  /// The [fields] arguement is used to describe the field in the body of a post request,
  /// [responseBody] is the raw json i.e responseBody = json.decode(response.body)
  ///
  ///
  static String processErrorJson(Map<String, dynamic> responseBody,
      {List<String>? fields, String operation = "Operation from Accept"}) {
    try {
      final List<String> errors = [];

      //Base error response
      if (responseBody["message"] != null) {
        errors.add(responseBody["message"].toString());
      }



      if (responseBody["error"] != null) {
        if (responseBody["error"] is String) {
          errors.add(responseBody["error"].toString());
        }

      }

      final String finalError = errors.join();

      log("$operation rar body: $responseBody");
      log("$operation error: $finalError");

      return finalError;
    } catch (e) {
      log(e.toString());
      throw e.toString();
    }
  }
}
