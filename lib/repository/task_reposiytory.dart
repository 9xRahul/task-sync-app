import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tasksync/config/app_config/api_urls.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';

class TaskRepository {
  Future<Map<String, dynamic>> addTask({
    required String title,
    required String description,
    required DateTime dueDate, // keep as DateTime
    required TimeOfDay time,
    required String category,
  }) async {
    final responseMap = {"status": false, "message": "", "data": {}};

    try {
      print("reached auth repo");
      final token = await AuthStorage.getToken();
      print(token);

      // Format dueDate as yyyy-MM-dd
      final formattedDate =
          "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}";

      final formattedTime = formatTimeOfDay(time);
      ;
      final body = {
        "title": title,
        "description": description,
        "dueDate": formattedDate,
        "time": formattedTime,
        "status": "pending",
        "category": category,
      };

      // Print the body for debugging
      final url = ApiUrls.baseUrl + ApiUrls.task + ApiUrls.createTask;
      print("API URL: $url");
      print("Sending task data: $body");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        responseMap['status'] = true;
        responseMap['message'] = "Task added successfully";
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        responseMap['data'] = data['data'];
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        responseMap['status'] = false;
        responseMap['message'] = data['error'];
      }
      return responseMap;
    } catch (e) {
      responseMap['status'] = false;
      responseMap['message'] = e.toString();
      return responseMap;
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // 12-hour format
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}
