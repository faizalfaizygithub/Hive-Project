import 'package:flutter/material.dart';
import 'package:hive_demo/controller/SERVICE/todo_service.dart';
import 'package:hive_demo/model/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descrController = TextEditingController();

  final TodoService todoService = TodoService();

  List<Todo> _todos = [];

  Future<void> _loadTodos() async {
    _todos = await todoService.getTodos();

    setState(() {});
  }

  @override
  void initState() {
    _loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          // ADD NEW TODO

          showAddDialog();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              final todo = _todos[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    // edit dialog
                    showUpdateDialog(todo, index);
                  },
                  title: Text(
                    todo.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    todo.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        fontSize: 10),
                  ),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        Checkbox(
                            onChanged: (value) {
                              //value toggle

                              setState(() {
                                todo.compleated = value!;
                                todoService.updateTodo(index, todo);
                              });
                            },
                            value: todo.compleated),
                        IconButton(
                            onPressed: () async {
                              await todoService.deleteTodo(index);

                              _loadTodos();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Add new task',
              style: TextStyle(fontSize: 18),
            ),
            content: Container(
              height: 200,
              // color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'title'),
                    controller: titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'description'),
                    controller: descrController,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newTodo = Todo(
                      title: titleController.text,
                      description: descrController.text,
                      createdAt: DateTime.now(),
                      compleated: false);

                  await todoService.AddTodo(newTodo);
                  titleController.clear();
                  descrController.clear();

                  Navigator.pop(context);

                  _loadTodos();
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  Future<void> showUpdateDialog(
    Todo todo,
    int index,
  ) async {
    titleController.text = todo.title;
    descrController.text = todo.description;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Update task',
              style: TextStyle(fontSize: 18),
            ),
            content: Container(
              height: 200,
              // color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'title'),
                    controller: titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'description'),
                    controller: descrController,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  todo.title = titleController.text;
                  todo.description = descrController.text;
                  todo.createdAt = DateTime.now();
                  if (todo.compleated == true) {
                    todo.compleated = false;
                    todoService.updateTodo(index, todo);
                  }

                  titleController.clear();
                  descrController.clear();

                  Navigator.pop(context);

                  _loadTodos();
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
