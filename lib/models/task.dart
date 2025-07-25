import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';       // this is the generated file for json serialization

@JsonEnum()
enum TaskPriority {
  low,
  medium,
  high,
}

@JsonEnum()   // annotation for enum serialization
enum TaskStatus {
  todo,
  inProgress,
  completed,
}

@JsonSerializable()   // annotation for JSON serialization
class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime deadline;
  final TaskPriority priority;
  final TaskStatus status;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.deadline,
    required this.priority,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json); // factory constructor for json deserialization
  Map<String, dynamic> toJson() => _$TaskToJson(this); // method for json serialization

  // custom json converters for DateTime
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();
  

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    TaskPriority? priority,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
  

  @override
  List<Object?> get props => [id, title, description, deadline, priority, status]; // list of properties to be used for equality comparison
}
