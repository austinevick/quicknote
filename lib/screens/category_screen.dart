import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:todo_app/widgets/category_header.dart';

class CategoryScreen extends StatelessWidget {
  final RandomColor randomColor = RandomColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        actions: [
          GestureDetector(
            onTap: () => print('hi'),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 20,
                  alignment: Alignment.center,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue,
                      )),
                  child: Icon(Icons.add)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 1, child: CategoryHeader()),
          Expanded(
              flex: 4,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          'Personal',
                        ),
                        subtitle: Text('9 tasks'),
                        trailing: IconButton(
                          onPressed: () => null,
                          icon: Icon(Icons.more_vert),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: randomColor.randomColor(),
                          child: Container(
                            height: 20,
                            alignment: Alignment.center,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
