import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/activity_list_viewmodel.dart';
import '../model/activity_model.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({
    super.key,
    required this.selectedClass,
  });

  final int selectedClass;

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  late int currentClass;

  @override
  void initState() {
    super.initState();
    currentClass = widget.selectedClass;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityListViewModel>().loadActivities(currentClass);
    });
  }

  void _onClassChanged(int newClass) {
    setState(() {
      currentClass = newClass;
    });
    context.read<ActivityListViewModel>().loadActivities(newClass);
  }

  @override
  Widget build(BuildContext context) {
    return _ActivityListView(
      selectedClass: currentClass,
      onClassChanged: _onClassChanged,
    );
  }
}

class _ActivityListView extends StatelessWidget {
  const _ActivityListView({
    required this.selectedClass,
    required this.onClassChanged,
  });

  final int selectedClass;
  final ValueChanged<int> onClassChanged;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivityListViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text('CLASS $selectedClass Activities',style: TextStyle(color: Colors.white),),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.class_rounded, color: Colors.white),
            tooltip: 'Change Class',
            onSelected: onClassChanged,
            itemBuilder: (context) {
              return List.generate(8, (index) {
                final classNum = index + 3;
                return PopupMenuItem<int>(
                  value: classNum,
                  child: Text('Class $classNum'),
                );
              });
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/background/background.jpeg'),
          fit: BoxFit.cover
          )
        ),
        child: Stack(
          children: [
            if (vm.activities.isEmpty)
              const Center(
                child: Text(
                  'No activities available.',
                ),
              )
            else
              GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: vm.activities.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final activity = vm.activities[index];
        
                  return _ActivityCard(
                    activity: activity,
                    onTap: () {
                      _selectActivity(
                        context,
                        activity,
                      );
                    },
                  );
                },
              ),
        
            if (vm.isSending)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Starting activity...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectActivity(
    BuildContext context,
    ActivityModel activity,
  ) async {
    final vm = context.read<ActivityListViewModel>();

    final success = await vm.sendActivity(activity);

    if (!context.mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage ?? 'Failed to start activity.',
          ),
        ),
      );

      return;
    }

    // .bin successfully sent.
    // Now open the activity page.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => activity.pageBuilder(),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
    required this.onTap,
  });

  final ActivityModel activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                activity.icon,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                activity.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
