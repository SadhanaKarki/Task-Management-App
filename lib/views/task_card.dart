import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../models/task.dart';
import 'task_form.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});
 
  // method to get the priority color
  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  // method to check if the task is overdue
  bool _isOverdue() {
    return task.deadline.isBefore(DateTime.now()) && task.status != TaskStatus.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      // the task card ui
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        elevation: 1,
        shape: _isOverdue()
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.red, width: 1.5),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (task.description != null && task.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.priority.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.calendar_today,
                          size: 11,
                          color: _isOverdue() ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          DateFormat('MMM d, y HH:mm').format(task.deadline),
                          style: TextStyle(
                            color: _isOverdue() ? Colors.red : Colors.grey,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // delete button
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Task'),
                        content: const Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<TaskBloc>().add(DeleteTask(task.id));
                              Navigator.of(context).pop(); // Close dialog
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            // edit button 
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => TaskForm(task: task),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
