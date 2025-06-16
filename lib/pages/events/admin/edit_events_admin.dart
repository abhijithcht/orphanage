import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventEdit extends StatefulWidget {
  const EventEdit({required this.eventUser, super.key});

  final EventModel eventUser;

  @override
  State<EventEdit> createState() => _EventEditState();
}

class _EventEditState extends State<EventEdit> {
  TextEditingController _eventName = TextEditingController();
  TextEditingController _eventDate = TextEditingController();
  TextEditingController _eventTime = TextEditingController();
  TextEditingController _description = TextEditingController();

  @override
  void initState() {
    _eventName = TextEditingController(text: widget.eventUser.name);
    _eventDate = TextEditingController(text: widget.eventUser.eventDate);
    _eventTime = TextEditingController(text: widget.eventUser.eventTime);
    _description = TextEditingController(text: widget.eventUser.description);
    super.initState();
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _eventDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        final formattedTime = DateFormat('hh:mm a').format(
          DateTime(2023, 1, 1, picked.hour, picked.minute),
        );
        _eventTime.text = formattedTime;
      });
    }
  }

  Future<void> update() async {
    final response = await http
        .post(Uri.parse('http://$iPAddress/Hope/admin_edit_event.php'), body: {
      'id': widget.eventUser.id,
      'name': _eventName.text.trim(),
      'event_date': _eventDate.text.trim(),
      'event_time': _eventTime.text.trim(),
      'description': _description.text.trim(),
      'uid': 'admin',
    });
    if (response.statusCode == 200) {
      _eventName.clear();
      _description.clear();
      if (!mounted) return;
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Data updated successfully'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Not updated'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'U P D A T E - E V E N T S',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TFF(
            controller: _eventName,
            hintText: 'Event name',
          ),
          TFF(
            controller: _eventDate,
            hintText: 'Event date',
            keyboardType: TextInputType.none,
            onTap: () async {
              await _selectDate(context);
            },
          ),
          TFF(
            controller: _eventTime,
            hintText: 'Event time',
            keyboardType: TextInputType.none,
            onTap: () async {
              await _selectTime(context);
            },
          ),
          TFF(
            controller: _description,
            hintText: 'Description',
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              update();
              _eventName.clear();
              _eventDate.clear();
              _eventTime.clear();
              _description.clear();
            },
            child: const Text('Update'),
          )
        ],
      ),
    );
  }
}
