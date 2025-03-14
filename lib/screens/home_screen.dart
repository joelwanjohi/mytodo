import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytodo/models/task_model.dart';
import 'package:mytodo/providers/date_provider.dart';
import 'package:mytodo/providers/issearchperformed_provider.dart';

import 'package:mytodo/providers/tasklist_provider.dart';
import 'package:mytodo/services/firestore_service%20.dart';
import 'package:mytodo/theme/theme.dart';
import 'package:mytodo/widgets/newtask_modal.dart';
import 'package:mytodo/widgets/responsive_layout.dart';
import 'package:mytodo/widgets/searchtask_modal.dart';
import 'package:mytodo/widgets/sortingmethod_modal.dart';
import 'package:mytodo/widgets/task_card.dart';
import 'package:mytodo/widgets/taskerror_card.dart';
import 'package:mytodo/widgets/taskloading_card.dart';
import 'package:mytodo/widgets/updatetask_modal.dart';
import 'package:mytodo/widgets/usersetting_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isSearchPerformed = ref.watch(isSearchPerformedProvider);
    final AsyncValue<List<Task>> taskList = ref.watch(taskListProvider);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 64.0,
          automaticallyImplyLeading: false,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Tasks List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 24.0),
                Text(ref.watch(dateProvider),style: TextStyle(
                    fontSize: 10.0)),
                if (isSearchPerformed)
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 24.0),
                      IconButton(
                        onPressed: () {
                          ref.read(isSearchPerformedProvider.notifier).state =
                              false;
                          ref.read(taskListProvider.notifier).fetchTasks();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.trash,
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(width: 24.0),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: ResponsiveLayout(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 12.0),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: taskList.when(
                    data: (List<Task> taskList) {
                      return ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(
                          dragDevices: <PointerDeviceKind>{
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.trackpad,
                            PointerDeviceKind.stylus,
                          },
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: taskList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(taskList[index].id!),
                              // Swiping to the right is for deleting the task.
                              background: const TaskCardBackgroundDelete(),
                              secondaryBackground:
                                  // Swiping to the left is for editing the
                                  // task.
                                  const TaskCardBackGroundEdit(),
                              confirmDismiss: (DismissDirection direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  return showDeleteTaskModal(
                                    context,
                                    ref,
                                    taskList,
                                    index,
                                  );
                                } else {
                                  return showUpdateTaskModal(
                                    context,
                                    ref,
                                    taskList,
                                    index,
                                  );
                                }
                              },
                              child: TaskCard(
                                taskList[index],
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return TaskErrorCard(error, stackTrace);
                    },
                    loading: () {
                      return const TaskLoadingCard();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 64.0,
          notchMargin: 12.0,
          shape: const CircularNotchedRectangle(),
          child: ResponsiveLayout(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // IconButton(
                    //   onPressed: () {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text(
                    //           'Timer is coming!',
                    //         ),
                    //         behavior: SnackBarBehavior.floating,
                    //       ),
                    //     );
                    //   },
                    //   icon: const Icon(
                    //     FontAwesomeIcons.stopwatch20,
                    //   ),
                    // ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet<Widget>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const UserSettingsModal();
                          },
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.user,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 64.0),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet<Widget>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const SearchTaskModal();
                          },
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet<Widget>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const SortingMethodModal();
                          },
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.sortAlphaDown,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<Widget>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return const NewTaskModal();
              },
            );
          },
          child: const Icon(
            FontAwesomeIcons.circlePlus,
            size: 32.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future<bool?> showUpdateTaskModal(
    BuildContext context,
    WidgetRef ref,
    List<Task> taskList,
    int index,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.0,
            0.0,
            24.0,
            MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Edit this task?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await showModalBottomSheet<Widget>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return UpdateTaskModal(taskList[index]);
                          },
                        );
                      },
                      child: const Text(
                        'EDIT',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> showDeleteTaskModal(
    BuildContext context,
    WidgetRef ref,
    List<Task> taskList,
    int index,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.0,
            0.0,
            24.0,
            MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Delete this task?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        FirestoreService(ref).deleteTask(
                          taskList[index].id!,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sIsDark.value
                            ? cFlexSchemeDark().error
                            : cFlexSchemeLight().error,
                      ),
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                          color: sIsDark.value
                              ? cFlexSchemeDark().onError
                              : cFlexSchemeLight().onError,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class TaskCardBackGroundEdit extends ConsumerWidget {
  const TaskCardBackGroundEdit({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: sIsDark.value
              ? cFlexSchemeDark().primary
              : cFlexSchemeLight().primary,
          width: 4.0,
        ),
      ),
      child: Container(
        height: 140.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.solidPenToSquare,
                color: sIsDark.value
                    ? cFlexSchemeDark().primary
                    : cFlexSchemeLight().primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCardBackgroundDelete extends ConsumerWidget {
  const TaskCardBackgroundDelete({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: sIsDark.value
              ? cFlexSchemeDark().error
              : cFlexSchemeLight().error,
          width: 4.0,
        ),
      ),
      child: Container(
        height: 140.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Row(
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.trash,
                color: sIsDark.value
                    ? cFlexSchemeDark().error
                    : cFlexSchemeLight().error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
