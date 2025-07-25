import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/task_repository.dart';
import '../models/task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;
  TaskPriority? _currentPriorityFilter;
  bool _sortByDeadline = false;

  TaskBloc({required TaskRepository repository})
      : _repository = repository,
        super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ReorderTask>(_onReorderTask);
    on<FilterByPriority>(_onFilterByPriority);
    on<ToggleSortByDeadline>(_onToggleSortByDeadline);
    
    // load tasks when bloc is created
    add(LoadTasks());
  }

  // method to load tasks from the repository
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await _repository.loadTasks();
      emit(TaskLoaded(
        tasks: tasks,
        priorityFilter: _currentPriorityFilter,
        sortByDeadline: _sortByDeadline,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // method to add a new task
  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final currentTasks = state is TaskLoaded 
          ? (state as TaskLoaded).tasks 
          : await _repository.loadTasks();
      
      final updatedTasks = [...currentTasks, event.task];
      await _repository.saveTasks(updatedTasks);
      
      emit(TaskLoaded(
        tasks: updatedTasks,
        priorityFilter: _currentPriorityFilter,
        sortByDeadline: _sortByDeadline,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // method to update an existing task
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        await _repository.saveTasks(updatedTasks);
        emit(TaskLoaded(
          tasks: updatedTasks,
          priorityFilter: _currentPriorityFilter,
          sortByDeadline: _sortByDeadline,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // method to delete a task
  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final updatedTasks =
            currentState.tasks.where((task) => task.id != event.taskId).toList();
        await _repository.saveTasks(updatedTasks);
        emit(TaskLoaded(
          tasks: updatedTasks,
          priorityFilter: _currentPriorityFilter,
          sortByDeadline: _sortByDeadline,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
  
  // method to reorder tasks in the column
  Future<void> _onReorderTask(ReorderTask event, Emitter<TaskState> emit) async {
    try {
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        final updatedTask = event.task.copyWith(status: event.newStatus);
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == event.task.id ? updatedTask : task;
        }).toList();
        await _repository.saveTasks(updatedTasks);
        emit(TaskLoaded(
          tasks: updatedTasks,
          priorityFilter: _currentPriorityFilter,
          sortByDeadline: _sortByDeadline,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // method to filter tasks by priority
  void _onFilterByPriority(FilterByPriority event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      _currentPriorityFilter = event.priority; 
      emit(currentState.copyWith(
        priorityFilter: event.priority, 
      ));
    }
  }

  // method to toggle sorting by deadline
  void _onToggleSortByDeadline(
      ToggleSortByDeadline event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      _sortByDeadline = event.sortByDeadline;
      emit(currentState.copyWith(
        sortByDeadline: event.sortByDeadline,
      ));
    }
  }
}
