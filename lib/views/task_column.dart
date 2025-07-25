import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';

import '../models/task.dart';
import 'task_card.dart';

class TaskColumn extends StatefulWidget {
  final String title;
  final List<Task> tasks;
  final TaskStatus status; 

  const TaskColumn({
    super.key,
    required this.title,
    required this.tasks,
    required this.status,
  });

  @override
  State<TaskColumn> createState() => _TaskColumnState();
}

class _TaskColumnState extends State<TaskColumn> {
  bool _isSortedByDeadline = false; 
  bool _isSortedByPriority = false;

 //  method to return the sorted list
  List<Task> _getSortedTasks(List<Task> tasks) {
    if (!_isSortedByDeadline && !_isSortedByPriority) return tasks;
    
    return List<Task>.from(tasks)..sort((a, b) {
      if (_isSortedByPriority) {
        // sort by priority 
        final priorityOrder = {
          TaskPriority.high: 3,
          TaskPriority.medium: 2,
          TaskPriority.low: 1,
        };

        final comparison = (priorityOrder[b.priority] ?? 0).compareTo(priorityOrder[a.priority] ?? 0);
        if (comparison != 0) return comparison;
      }
      
      if (_isSortedByDeadline) {
        // if priorities are equal or not sorting by priority then sort by deadline
        return a.deadline.compareTo(b.deadline);
      }
      
      return 0;
    });
  }
 
  // method to handle sort option
  void _handleSortOption(String value) {
    setState(() {
      if (value == 'deadline') {
        _isSortedByDeadline = !_isSortedByDeadline;
        if (_isSortedByDeadline) _isSortedByPriority = false;
      } else if (value == 'priority') {
        _isSortedByPriority = !_isSortedByPriority;
        if (_isSortedByPriority) _isSortedByDeadline = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedTasks = _getSortedTasks(widget.tasks);
  
    // the task column ui
    return Container(
      width: 280,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    // sort button
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isSortedByDeadline || _isSortedByPriority
                              ? Colors.white.withAlpha(51)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sort',
                              style: TextStyle(
                                color: Colors.white.withAlpha(229),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.sort,
                              size: 16,
                              color: Colors.white.withAlpha(229),
                            ),
                          ],
                        ),
                      ),
                      tooltip: 'Sort Tasks',  
                      onSelected: _handleSortOption,
                      itemBuilder: (context) => [
                        // sort options
                        PopupMenuItem<String>(
                          value: 'deadline',
                          child: Row(
                            children: [
                              const Text('By Deadline'),
                              const SizedBox(width: 8),
                              if (_isSortedByDeadline)
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'priority',
                          child: Row(
                            children: [
                              const Text('By Priority'),
                              const SizedBox(width: 8),
                              if (_isSortedByPriority)
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),

                    // circular task length indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.tasks.length}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // the task list
          Flexible(
            child: DragTarget<Task>(
              onAccept: (task) {
                if (task.status != widget.status) {
                  context.read<TaskBloc>().add(ReorderTask(task, widget.status));
                }
              },
              builder: (context, candidateData, rejectedData) {
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 20.0),
                  itemCount: sortedTasks.length,
                  itemBuilder: (context, index) {
                    final task = sortedTasks[index];
                    return LongPressDraggable<Task>(
                      data: task,
                      feedback: SizedBox(
                        width: 260,
                        child: TaskCard(task: task),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: TaskCard(task: task),
                      ),
                      hapticFeedbackOnStart: true,
                      delay: const Duration(milliseconds: 300),
                      child: TaskCard(task: task),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
