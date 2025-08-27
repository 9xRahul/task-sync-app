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
    required int categoryIndex,
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
        "categoryIndex": categoryIndex,
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
    bool isUpdateTask = false,
    required String sId,
    String? status,
    String title = "",
    String description = "",
    DateTime? dueDate,
    TimeOfDay? time,
    String category = "",
    int categoryIndex = 0,
  }) async {
    var apiResponse = {"status": false, "message": "", "data": []};

    final token = await AuthStorage.getToken();

    try {
      final body = isUpdateTask == true
          ? jsonEncode({
              "title": title,
              "description": description,
              "dueDate": dueDate?.toIso8601String(),
              "time": time != null ? "${time.hour}:${time.minute}" : null,
              "category": category,
              "categoryIndex": categoryIndex,
            })
          : jsonEncode({"status": status});
      final url = ApiUrls.baseUrl + ApiUrls.task + ApiUrls.updateTask + sId;

      print(body);
      final response = await http.put(
        Uri.parse(url),

        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        var data = responseData['data'];

        if (data is List) {
          // handle list of tasks
          for (var task in data) {
            print(task); // each task is a Map
          }
        } else if (data is Map<String, dynamic>) {
          // handle single task
          print(data);
        }

        apiResponse['status'] = true;
        apiResponse['message'] = "Tasks Updated successfully";
      } else {
        apiResponse['status'] = false;
        apiResponse['message'] = "Error in changing the status";
        apiResponse['data'] = <TaskModel>[]; // empty list if failed
      }
    } catch (e) {
      print(e);
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

  Future<Map<String, dynamic>> searchTasks({required String query,required String status}) async {
    final apiResponse = {"status": false, "message": "", "data": []};

    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      apiResponse['message'] = "Not authenticated";
      return apiResponse;
    }

    try {
      final url =
          ApiUrls.baseUrl +
          ApiUrls.task +
          ApiUrls.search; // e.g. /api/tasks/search
      final uri = Uri.parse(url).replace(queryParameters: {"q": query,"status":status});

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        apiResponse['status'] =
            responseData['success'] == true ||
            responseData['status'] == true ||
            true;
        apiResponse['message'] =
            responseData['message'] ?? "Tasks fetched successfully";
        apiResponse['data'] =
            (responseData['data'] as List<dynamic>?)
                ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
      } else {
        final Map<String, dynamic> err = jsonDecode(response.body);
        apiResponse['status'] = false;
        apiResponse['message'] =
            err['message'] ?? err['error'] ?? "Failed to fetch tasks";
        apiResponse['data'] = [];
      }
    } catch (e) {
      apiResponse['status'] = false;
      apiResponse['message'] = e.toString();
      apiResponse['data'] = [];
    }

    return apiResponse;
  }
}
