import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventAdd extends StatefulWidget {
  const EventAdd({super.key});

  @override
  State<EventAdd> createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  final eventkey = GlobalKey<FormState>();
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _eventDate = TextEditingController();
  final TextEditingController _eventTime = TextEditingController();
  final TextEditingController _description = TextEditingController();

  late bool status;
  late String message;

  @override
  void initState() {
    status = false;
    message = '';
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
    final var picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        final var formattedTime = DateFormat('hh:mm a').format(
          DateTime(2023, 1, 1, picked.hour, picked.minute),
        );
        _eventTime.text = formattedTime;
      });
    }
  }

  Future<void> submit() async {
    if (!mounted) {
      return;
    }

    final mapedData = <String, String>{
      'name': _eventName.text.trim(),
      'event_date': _eventDate.text.trim(),
      'event_time': _eventTime.text.trim(),
      'description': _description.text.trim(),
      'uid': 'admin',
    };

    try {
      final response =
          await http.post(Uri.parse(URL.eventRegisterAdmin), body: mapedData);

      if (response.body.isEmpty) {
        if (mounted) {
          setState(() {
            status = false;
            message = 'Empty response from the server.';
          });
        }
      } else {
        final data = jsonDecode(response.body);
        final responseMessage = data['message'];
        final responseError = data['error'];
        if (responseError) {
          if (mounted) {
            setState(() {
              status = false;
              message = responseMessage;
            });
          }
        } else {
          _eventName.clear();
          _description.clear();
          _eventDate.clear();
          _eventTime.clear();
          if (mounted) {
            setState(() {
              status = true;
              message = responseMessage;
            });
          }
        }
      }
    } on FormatException catch (e) {
      print('Error decoding JSON: $e');

      if (mounted) {
        setState(() {
          status = false;
          message = 'Check mapped data.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD EVENTS'),
      ),
      body: Form(
        key: eventkey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TFF(
                controller: _eventName,
                hintText: 'Event name',
                focus: true,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Event name cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _eventDate,
                hintText: 'Event date',
                keyboardType: TextInputType.none,
                onTap: () async {
                  await _selectDate(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Date cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _eventTime,
                hintText: 'Event time',
                keyboardType: TextInputType.none,
                onTap: () async {
                  await _selectTime(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Time cannot be empty';
                  }
                },
              ),
              TFF(
                controller: _description,
                hintText: 'Description',
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Description cannot be empty';
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ELB(
                onPressed: () {
                  if (eventkey.currentState!.validate()) {
                    setState(() {
                      submit();
                      Navigator.pop(context);
                    });
                  }
                },
                text: 'ADD EVENT',
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
