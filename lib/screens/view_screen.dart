import 'package:flutter/material.dart';
import 'package:complete_form_example/models/form_data_model.dart';
import 'package:complete_form_example/services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final _hiveService = HiveService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Entries"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: "Delete All Data",
            onPressed: _showDeleteAllDialog,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _hiveService.listenable(),
        builder: (context, Box<FormDataModel> box, _) {
          final entries = box.values.toList().cast<FormDataModel>();
          if (entries.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No data has been saved yet.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                elevation: 2,
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Text(
                      entry.name.isNotEmpty ? entry.name[0].toUpperCase() : "?",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.name.isNotEmpty ? entry.name : "Unnamed",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    entry.email.isNotEmpty ? entry.email : "No email",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _showDeleteDialog(entry.key),
                  ),
                  children: _buildExpansionChildren(entry),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildExpansionChildren(FormDataModel entry) {
    final children = <Widget>[];

    _addDataRow(children, "Password", entry.password);
    _addDataRow(children, "Phone", entry.phone);
    _addDataRow(children, "Age", entry.age);
    _addDataRow(children, "Gender", entry.gender);
    _addDataRow(children, "Country", entry.country);

    if (entry.selectedDate != null) {
      _addDataRow(
        children,
        "Date",
        entry.selectedDate!.toLocal().toString().split(' ')[0],
      );
    }

    _addDataRow(children, "Time", entry.selectedTime);
    _addDataRow(children, "Rating", entry.rating.toStringAsFixed(1));
    _addDataRow(children, "Percentage", "${entry.percentage.toInt()}%");
    _addDataRow(
      children,
      "Price Range",
      "${entry.priceRangeStart?.toInt() ?? 'N/A'} - ${entry.priceRangeEnd?.toInt() ?? 'N/A'}",
    );
    _addDataRow(children, "Notifications", entry.notifications ? "Yes" : "No");
    _addDataRow(children, "Agree Policy", entry.agreePolicy ? "Yes" : "No");

    if (children.isEmpty) {
      children.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "No additional information",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return children;
  }

  void _addDataRow(List<Widget> children, String label, dynamic value) {
    if (value != null && (value is bool || value.toString().isNotEmpty)) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "$label:",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showDeleteDialog(int key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Entry"),
        content: const Text("Are you sure you want to delete this entry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _hiveService.deleteData(key);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Entry deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete All Data"),
        content: const Text(
          "Are you sure you want to delete all saved data? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _hiveService.clearAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete All"),
          ),
        ],
      ),
    );
  }
}
