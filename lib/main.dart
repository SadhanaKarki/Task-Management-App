import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/task_bloc.dart';
import 'repositories/task_repository.dart';
import 'views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TaskRepository(),
      child: BlocProvider(
        create: (context) => TaskBloc(
          repository: context.read<TaskRepository>(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task Management System',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
