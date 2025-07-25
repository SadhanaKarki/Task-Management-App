import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ReorderTask extends TaskEvent {
  final Task task;
  final TaskStatus newStatus;

  const ReorderTask(this.task, this.newStatus);

  @override
  List<Object?> get props => [task, newStatus];
}

class FilterByPriority extends TaskEvent {
  final TaskPriority? priority;

  const FilterByPriority(this.priority);

  @override
  List<Object?> get props => [priority];
}

class ToggleSortByDeadline extends TaskEvent {
  final bool sortByDeadline;

  const ToggleSortByDeadline(this.sortByDeadline);

  @override
  List<Object?> get props => [sortByDeadline];
}
