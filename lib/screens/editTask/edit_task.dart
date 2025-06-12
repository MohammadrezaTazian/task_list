import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/editTask/cubit/edit_task_cubit.dart';

class EditTaskScreen extends StatefulWidget {
  // This is a placeholder for the TaskEntity that will be edited.
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.taskEntity.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        Provider.of<Repository<TaskEntity>>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          context.read<EditTaskCubit>().onSaveChangedClick();
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
          BlocBuilder<EditTaskCubit, EditTaskState>(
            builder: (context, state) {
              return Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                      flex: 1,
                      child: PeriorityCheckBox(
                        color: Colors.blue,
                        lable: 'high',
                        isSelected:
                            state.taskEntity.periority == Periority.high,
                        onTap: () {
                          context.read<EditTaskCubit>().onPeriorityChanged(
                                Periority.high,
                              );
                        },
                      )),
                  Flexible(
                      flex: 1,
                      child: PeriorityCheckBox(
                        color: Colors.yellow,
                        lable: 'normal',
                        isSelected:
                            state.taskEntity.periority == Periority.normal,
                        onTap: () {
                          context.read<EditTaskCubit>().onPeriorityChanged(
                                Periority.normal,
                              );
                        },
                      )),
                  Flexible(
                      flex: 1,
                      child: PeriorityCheckBox(
                        color: Colors.red,
                        lable: 'low',
                        isSelected: state.taskEntity.periority == Periority.low,
                        onTap: () {
                          context.read<EditTaskCubit>().onPeriorityChanged(
                                Periority.low,
                              );
                        },
                      )),
                ],
              );
            },
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
              context
                  .read<EditTaskCubit>()
                  .onTextChanged(value); // ارسال تغییرات به Cubit
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
