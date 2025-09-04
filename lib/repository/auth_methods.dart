import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:tasksync/config/app_config/api_urls.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/models/user_model.dart';

class AuthRepository {
  static final _fcm = FirebaseMessaging.instance;

  Future<Map<String, dynamic>> logoutUser({required String email}) async {
    final apiResponse = {"status": false, "message": ""};
    print("logout called");
    try {
      String? token = await _fcm.getToken();
      print("🗑 Logout FCM Token: $token");

      final response = await http.post(
        Uri.parse(ApiUrls.baseUrl + ApiUrls.auth + ApiUrls.logout),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "fcmToken": token}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        AuthStorage.logout();
        apiResponse['status'] = true;
        apiResponse['message'] = "Logged out ";
      } else {
        apiResponse['status'] = true;
        apiResponse['message'] = "Error in logout";
      }
    } catch (e, stackTrace) {
      print("❌ Logout error: $e");
      print("📌 Stack trace: $stackTrace");
      apiResponse['status'] = true;
      apiResponse['message'] = "Error in logout";
    }
    return apiResponse;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final apiResponse = {
      "status": false,
      "message": "",
      "errors": [],
      "user": null,
      "token": "",
    };

    String? token = await _fcm.getToken();
    print("🔑 Login FCM Token: $token");

    try {
      final response = await http.post(
        Uri.parse(ApiUrls.baseUrl + ApiUrls.auth + ApiUrls.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "fcmToken": token,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // ✅ Extract user data
        final userData = jsonResponse['data'] ?? {};

        // ✅ Convert to UserModel
        final userModelData = UserModel.fromJson(userData);

        apiResponse['status'] = true;
        apiResponse['message'] = jsonResponse['message'] ?? "Login successful";
        apiResponse['user'] = userModelData;

        String token = jsonResponse['token'] ?? '';

        apiResponse['token'] = token;

        print("User Model Data: ${userModelData.toJson()}");
        print("Auth Token: $token");

        await AuthStorage.saveLoginData(loginData: userModelData, token: token);

        return apiResponse;
      } else {
        final errorResponse = jsonDecode(response.body);
        apiResponse['status'] = false;
        apiResponse['message'] = errorResponse['error'] ?? "Login failed";
        apiResponse['error'] = errorResponse['error'] ?? [];
        return apiResponse;
      }
    } catch (e) {
      apiResponse['message'] = "An error occurred: $e";
      apiResponse['errors'] = [e.toString()];
      return apiResponse;
    }
  }

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    final apiResponse = {"status": false, "message": "", "errors": []};

    final response = await http.post(
      Uri.parse(ApiUrls.baseUrl + ApiUrls.auth + ApiUrls.register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password, "name": name}),
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      apiResponse["status"] = true;
      apiResponse["message"] =
          jsonResponse['message'] ??
          "Registration successful. Please verify your email to complete registration.";

      return apiResponse;
    } else {
      // Handle array of field errors
      if (jsonResponse.containsKey('errors') &&
          jsonResponse['errors'] is List) {
        List<dynamic> errorsList = jsonResponse['errors'];
        apiResponse["errors"] = errorsList
            .map((e) => e['msg']?.toString() ?? "")
            .toList();
        apiResponse["message"] = (apiResponse["errors"] as List<String>).join(
          "\n",
        );
      }
      // Handle single error string
      else if (jsonResponse.containsKey('error')) {
        apiResponse["message"] = jsonResponse['error'].toString();
      }
      // Handle generic message
      else if (jsonResponse.containsKey('message')) {
        apiResponse["message"] = jsonResponse['message'].toString();
      } else {
        apiResponse["message"] = "Signup failed. Please try again.";
      }

      return apiResponse;
    }
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String verificationCode,
  }) async {
    var apiResponse = {"status": false, "message": ""};
    final response = await http.post(
      Uri.parse(ApiUrls.baseUrl + ApiUrls.auth + ApiUrls.verifyEmail),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"code": verificationCode}),
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      apiResponse['status'] = true;
      apiResponse['message'] =
          jsonResponse['message'] ?? "Email verified successfully.";
      return apiResponse;
    } else {
      apiResponse['status'] = false;
      apiResponse['message'] = "Invalid or expired verification code.";
      return apiResponse;
    }
  }

  Future<Map<String, dynamic>> resetPassword({required String email}) async {
    var apiResponse = {"status": false, "resettoken": "", "message": ""};

    try {
      final response = await http.post(
        Uri.parse(ApiUrls.baseUrl + ApiUrls.auth + ApiUrls.forgotPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse['status'] = true;
        apiResponse['resettoken'] = jsonResponse['resetToken'] ?? "";
        apiResponse['message'] =
            jsonResponse['message'] ?? "Reset token generated successfully.";
      } else {
        apiResponse['message'] = jsonResponse['error'] ?? "Invalid Email ";
      }
    } catch (error) {
      apiResponse['status'] = false;
      apiResponse['message'] = "Something went wrong. Please try again.";
    }

    return apiResponse;
  }

  Future<Map<String, dynamic>> updatePassword({
    required String newPassword,
    required String resetToken,
  }) async {
    var apiResponse = {"status": false, "message": ""};

    try {
      final response = await http.post(
        Uri.parse(ApiUrls.baseUrl + ApiUrls.auth + ApiUrls.resetPassword),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $resetToken", // ✅ Bearer token in header
        },
        body: jsonEncode({"password": newPassword}),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse['status'] = true;
        apiResponse['message'] =
            jsonResponse['message'] ?? "Password updated successfully.";
      } else {
        apiResponse['message'] =
            jsonResponse['error'] ?? "Failed to update password.";
      }
    } catch (error) {
      apiResponse['status'] = false;
      apiResponse['message'] = "Something went wrong. Please try again.";
    }

    return apiResponse;
  }
}
