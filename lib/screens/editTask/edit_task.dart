import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity taskEntity;
  // This is a placeholder for the TaskEntity that will be edited.
  const EditTaskScreen({super.key, required this.taskEntity});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.taskEntity.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository<TaskEntity>>(context, listen: false);


    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          widget.taskEntity.name = _controller.text;
          repository.createOrUpdate(widget.taskEntity);
          Navigator.pop(context); // بستن صفحه بعد از ذخیره
        },
        label: const Text('save'),
      ),
      backgroundColor: Colors.red,
      body: Column(
        children: [
          AppBar(
            title: const Text('ویرایش وظایف'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                  flex: 1,
                  child: PeriorityCheckBox(
                    color: Colors.blue,
                    lable: 'high',
                    isSelected: widget.taskEntity.periority == Periority.high,
                    onTap: () {
                      setState(() {
                        widget.taskEntity.periority = Periority.high;
                      });
                    },
                  )),
              Flexible(
                  flex: 1,
                  child: PeriorityCheckBox(
                    color: Colors.yellow,
                    lable: 'normal',
                    isSelected: widget.taskEntity.periority == Periority.normal,
                    onTap: () {
                      setState(() {
                        widget.taskEntity.periority = Periority.normal;
                      });
                    },
                  )),
              Flexible(
                  flex: 1,
                  child: PeriorityCheckBox(
                    color: Colors.red,
                    lable: 'low',
                    isSelected: widget.taskEntity.periority == Periority.low,
                    onTap: () {
                      setState(() {
                        widget.taskEntity.periority = Periority.low;
                      });
                    },
                  )),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'نام ',
              border: OutlineInputBorder(),
            ),
            controller: _controller,
            onChanged: (value) {
              // مقدار name را همزمان به‌روزرسانی کن (اختیاری)
              widget.taskEntity.name = value;
            },
          ),
        ],
      ),
    );
  }
}

class PeriorityCheckBox extends StatelessWidget {
  final Color color;
  final String lable;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PeriorityCheckBox({
    super.key,
    required this.color,
    required this.lable,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 16.0,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(lable),
      ],
    );
  }
}
