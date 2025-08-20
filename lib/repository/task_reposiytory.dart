import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tasksync/config/app_config/api_urls.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/models/task_model.dart';

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

  Future<Map<String, dynamic>> getTasks({
    required String status,
    required String category,
  }) async {
    var apiResponse = {"status": false, "message": "", "data": []};

    final token = await AuthStorage.getToken();

    print("Reached API call");
    print("Token: $token");

    try {
      final url = ApiUrls.baseUrl + ApiUrls.task + ApiUrls.getTasks;

      print("category:$category ${status.toString()}");

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"category": category, "status": status}),

        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Parse into TaskModel list
        List<TaskModel> tasks = [];

        var res = responseData['data'] as List; // cast to List
        for (var json in responseData['data']) {
          try {
            final task = TaskModel.fromJson(json);
            tasks.add(task);
          } catch (e) {}
        }

        apiResponse['status'] = true;
        apiResponse['message'] = "Tasks fetched successfully";
        apiResponse['data'] = tasks;
      } else {
        apiResponse['status'] = false;
        apiResponse['message'] = "No tasks added";
        apiResponse['data'] = <TaskModel>[]; // empty list if failed
      }
    } catch (e) {
      apiResponse['status'] = false;
      apiResponse['message'] = e.toString();
      apiResponse['data'] = <TaskModel>[]; // empty list on error
    }

    return apiResponse;
  }

  Future<Map<String, dynamic>> updateTaskStatus({
    required String sId,
    required String status,
  }) async {
    var apiResponse = {"status": false, "message": "", "data": []};

    final token = await AuthStorage.getToken();

    try {
      final body = jsonEncode({"status": status});
      final url = ApiUrls.baseUrl + ApiUrls.task + ApiUrls.updateTask + sId;

      final response = await http.put(
        Uri.parse(url),

        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        var res = responseData['data'] as List; // cast to List
        apiResponse['status'] = true;
        apiResponse['message'] = "Tasks Updated successfully";
      } else {
        apiResponse['status'] = false;
        apiResponse['message'] = "Error in changing the status";
        apiResponse['data'] = <TaskModel>[]; // empty list if failed
      }
    } catch (e) {
      apiResponse['status'] = false;
      apiResponse['message'] = e.toString();
    }

    return apiResponse;
  }

  Future<Map<String, dynamic>> deleteTask({required String sId}) async {
    var apiResponse = {"status": false, "message": "", "data": []};

    final token = await AuthStorage.getToken();

    try {
      final url = ApiUrls.baseUrl + ApiUrls.task + ApiUrls.deleteTask + sId;

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        apiResponse['status'] = true;
        apiResponse['message'] = "Task deleted successfully";
        apiResponse['data'] =
            []; // optional, can include deleted task info if backend returns it
      } else {
        apiResponse['status'] = false;
        apiResponse['message'] = "Error deleting the task";
        apiResponse['data'] = [];
      }
    } catch (e) {
      apiResponse['status'] = false;
      apiResponse['message'] = e.toString();
    }

    return apiResponse;
  }
}
