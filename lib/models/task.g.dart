// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  deadline: Task._dateTimeFromJson(json['deadline'] as String),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'deadline': Task._dateTimeToJson(instance.deadline),
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'status': _$TaskStatusEnumMap[instance.status]!,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
};
