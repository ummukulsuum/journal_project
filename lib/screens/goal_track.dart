// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:journally/models/goal_model.dart';

// class GoalTrackerPage extends StatefulWidget {
//   final String currentUserId;
//   const GoalTrackerPage({super.key, required this.currentUserId});

//   @override
//   State<GoalTrackerPage> createState() => _GoalTrackerPageState();
// }

// class _GoalTrackerPageState extends State<GoalTrackerPage> {
//   final TextEditingController _goalController = TextEditingController();
//   Box<GoalModel>? goalBox; // nullable
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _openGoalBox();
//   }

//   Future<void> _openGoalBox() async {
//     goalBox = await Hive.openBox<GoalModel>('goals_${widget.currentUserId}');
//     setState(() {
//       isLoading = false;
//     });
//   }

//   void _addGoal() {
//     final text = _goalController.text.trim();
//     if (text.isNotEmpty && goalBox != null) {
//       goalBox!.add(GoalModel(title: text));
//       _goalController.clear();
//       setState(() {});
//     }
//   }

//   void _toggleGoal(GoalModel goal, bool value) {
//     goal.isCompleted = value;
//     goal.save();
//     setState(() {});
//   }

//   void _deleteGoal(GoalModel goal) {
//     goal.delete();
//     setState(() {});
//   }

//   void _clearAllGoals() {
//     if (goalBox != null) {
//       for (var goal in goalBox!.values) {
//         goal.delete();
//       }
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryBrown = Color(0xFF8B5E3C);
//     const Color lightBrown = Color(0xFFD2B48C);
//     const Color backgroundColor = Color(0xFFF6F1ED);

//     if (isLoading || goalBox == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: const Text("My Goals", style: TextStyle(color: Colors.white)),
//         backgroundColor: primaryBrown,
//         centerTitle: true,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_forever_rounded, color: Colors.white),
//             tooltip: "Clear All Goals",
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (_) => AlertDialog(
//                   title: const Text("Clear All Goals"),
//                   content: const Text("Are you sure you want to delete all your goals?"),
//                   actions: [
//                     TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//                     TextButton(onPressed: () { _clearAllGoals(); Navigator.pop(context); }, child: const Text("Delete")),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Add Goal Input
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [BoxShadow(color: primaryBrown.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       child: TextField(
//                         controller: _goalController,
//                         decoration: const InputDecoration(hintText: "Add a new goal...", border: InputBorder.none),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.add_circle_rounded, color: primaryBrown, size: 30),
//                     onPressed: _addGoal,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: goalBox!.listenable(),
//                 builder: (context, Box<GoalModel> box, _) {
//                   final goals = box.values.toList();

//                   if (goals.isEmpty) {
//                     return const Center(
//                       child: Text("Add your first goal to get started!", style: TextStyle(color: Colors.grey)),
//                     );
//                   }

//                   return ListView.builder(
//                     itemCount: goals.length,
//                     itemBuilder: (context, index) {
//                       final goal = goals[index];
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(18),
//                           boxShadow: [BoxShadow(color: lightBrown.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3))],
//                         ),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                           leading: Checkbox(
//                             activeColor: primaryBrown,
//                             value: goal.isCompleted,
//                             onChanged: (val) => _toggleGoal(goal, val ?? false),
//                           ),
//                           title: Text(
//                             goal.title,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: goal.isCompleted ? Colors.grey : Colors.black87,
//                               decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
//                             ),
//                           ),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
//                             onPressed: () => _deleteGoal(goal),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
