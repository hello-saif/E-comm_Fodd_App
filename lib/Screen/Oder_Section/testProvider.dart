import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen6 extends StatefulWidget {
  const OrderScreen6({super.key});

  @override
  _OrderScreen6State createState() => _OrderScreen6State();
}

class _OrderScreen6State extends State<OrderScreen6> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final counterProvider = Provider.of<CounterProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {},
        ),
        title: const Text('Test'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Count:'),
                    const SizedBox(
                      width: 13,
                    ),
                    Text(todoProvider.task.length.toString(),
                      // counterProvider.count.toString(),
                      style: const TextStyle(fontSize: 65),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Add Task',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  todoProvider.addtask(_controller.text);
                  _controller.clear();
                }
              },
              child: Text('Add Task')),
          Expanded(
              child: ListView.builder(
                  itemCount: todoProvider.task.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(todoProvider.task[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle_outline_rounded),
                        onPressed: () {
                          todoProvider.removetask(index);
                        },
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              counterProvider.increment();
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              counterProvider.decrement();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) {
      _count--;
    }
    notifyListeners();
  }
}

class TodoProvider with ChangeNotifier {
  List<String> _task = [];
  List<String> get task => _task;

  void addtask(String task) {
    _task.add(task);
    notifyListeners();
  }

  void removetask(int index) {
    _task.removeAt(index);
    notifyListeners();
  }
}
