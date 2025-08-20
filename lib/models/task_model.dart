class TaskModel {
  String? sId;
  String? owner;
  String? title;
  String? time;
  String? category;
  String? description;
  String? status;
  String? dueDate;

  TaskModel({
    this.sId,
    this.owner,
    this.title,
    this.time,
    this.category,
    this.description,
    this.status,
    this.dueDate,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    owner = json['owner'];
    title = json['title'];
    time = json['time'];
    category = json['category'];
    description = json['description'];
    status = json['status'];
    dueDate = json['dueDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['owner'] = this.owner;
    data['title'] = this.title;
    data['time'] = this.time;
    data['category'] = this.category;
    data['description'] = this.description;
    data['status'] = this.status;
    data['dueDate'] = this.dueDate;
    return data;
  }
}
