import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_state.dart';
import '../blocs/task_event.dart';
import '../models/task.dart';
import 'task_column.dart';
import 'task_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Management',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
             final currentPriority = (state is TaskLoaded) ? state.priorityFilter : null;
              // priority filters dropdown button
              return PopupMenuButton<TaskPriority>(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: currentPriority != null
                        ? Theme.of(context).primaryColor.withAlpha(25)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: currentPriority != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: currentPriority != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.filter_list,
                        size: 18,
                        color: currentPriority != null
                            ? Theme.of(context).primaryColor
                            : Colors.grey[700],
                      ),
                    ],
                  ),
                ),
                tooltip: 'Filter by Priority',
                onSelected: (priority) {
                  context.read<TaskBloc>().add(FilterByPriority(priority));
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<TaskPriority>(
                    value: TaskPriority.high,
                    child: Text('HIGH'),
                  ),
                  const PopupMenuItem<TaskPriority>(
                    value: TaskPriority.medium,
                    child: Text('MEDIUM'),
                  ),
                  const PopupMenuItem<TaskPriority>(
                    value: TaskPriority.low,
                    child: Text('LOW'),
                  ),
                ],
              );
            },
          ),
          // clear filters button
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              final isLoaded = state is TaskLoaded;
              final hasFilters = isLoaded && state.priorityFilter != null;

              if (!hasFilters) return const SizedBox.shrink();
              
              return IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear Filters',
                onPressed: () {
                  context.read<TaskBloc>().add(const FilterByPriority(null));
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {  // showing loading indicator while tasks are fetched
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskError) {  // showing error message if tasks cannot be loaded
            return Center(child: Text(state.message));
          }
          if (state is TaskLoaded) {  // showing task columns when data is loaded
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskColumn(
                    title: 'Todo',
                    tasks: state.tasksByStatus[TaskStatus.todo] ?? [],
                    status: TaskStatus.todo,
                  ),
                  TaskColumn(
                    title: 'In Progress',
                    tasks: state.tasksByStatus[TaskStatus.inProgress] ?? [],
                    status: TaskStatus.inProgress,
                  ),
                  TaskColumn(
                    title: 'Completed',
                    tasks: state.tasksByStatus[TaskStatus.completed] ?? [],
                    status: TaskStatus.completed,
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No tasks found'));
        },
      ),
      //  button to add new tasks
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const TaskForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
