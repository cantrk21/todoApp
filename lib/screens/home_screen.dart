import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/models/todo_model.dart';
import 'package:todoo_app/screens/add_todo_screen.dart';
import 'package:todoo_app/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*final _databaseService = DatabaseService();*/

  /*void _getTodoList() async {
    await _databaseService.fetchTodos();
    setState(() {});
  }*/

  /*void _addTodo() async {
    await _databaseService.addTodo(_textFieldController.text);
    _textFieldController.clear();
    setState(() {});
  }*/

  /*void _updateTodo(Todo todo) async {
    await _databaseService.updateTodo(todo);
    setState(() {});
  }*/

  void _fetchTodos() {
    context.read<DatabaseService>().fetchTodos();
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoScreen(),
      ),
    );
  }

  @override
  void initState() {
    _fetchTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("todoApp"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _navigateToAddScreen,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: _todoListWidget(),
      ),
    );
  }

  Expanded _todoListWidget() {
    return Expanded(
      child: Consumer<DatabaseService>(
        builder: (context, databaseService, child) => ListView.separated(
          itemCount: databaseService.currentTodos.length,
          itemBuilder: (context, index) {
            final Todo todo = databaseService.currentTodos[index];
            return ListTile(
              title: Text(
                todo.text,
                style: TextStyle(
                  decoration: todo.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(todo.datetime.toString()),
              tileColor: Colors.brown.shade200,
              trailing: Checkbox(
                value: todo.isDone,
                onChanged: (isDone) {
                  todo.isDone = isDone!;
                  databaseService.updateTodo(todo);
                },
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            height: 0,
            color: Colors.blueGrey.shade100,
          ),
        ),
      ),
    );
  }
/*
  Container _addTodoWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                context
                    .read<DatabaseService>()
                    .addTodo(_textFieldController.text);
              },
              icon: const Icon(Icons.add)),
          border: const OutlineInputBorder(),
          isDense: true,
          hintText: "Write something.",
        ),
      ),
    );
  }*/
}
