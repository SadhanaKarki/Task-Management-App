import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final TaskPriority? priorityFilter;
  final bool sortByDeadline;

  const TaskLoaded({
    required this.tasks,
    this.priorityFilter,
    this.sortByDeadline = false,
  });

  Map<TaskStatus, List<Task>> get tasksByStatus {
    var filteredAndSortedTasks = _getFilteredAndSortedTasks();
    return {
      for (var status in TaskStatus.values)
        status: filteredAndSortedTasks
            .where((task) => task.status == status)
            .toList(),
    };
  }

  List<Task> _getFilteredAndSortedTasks() {
    // a copy of all tasks
    var result = List<Task>.from(tasks);

    // apply priority filter if set
    if (priorityFilter != null) {
      result = result.where((task) => task.priority == priorityFilter).toList();
    }

    // apply sorting if enabled
    if (sortByDeadline) {
      result.sort((a, b) => a.deadline.compareTo(b.deadline));
    }

    return result;
  }

  TaskLoaded copyWith({
    List<Task>? tasks,
    TaskPriority? priorityFilter,
    bool? sortByDeadline,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      priorityFilter: priorityFilter, // if null is passed, it will clear the filter
      sortByDeadline: sortByDeadline ?? this.sortByDeadline,
    );
  }

  @override
  List<Object?> get props => [tasks, priorityFilter, sortByDeadline];   //
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
