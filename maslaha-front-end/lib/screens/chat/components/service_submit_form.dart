import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../shared/constants.dart';
import '../../../utils/size_config.dart';

class ServiceSubmitForm extends StatefulWidget {
  final String receiverId;
  final IO.Socket socket;

  ServiceSubmitForm({required this.receiverId, required this.socket});

  @override
  _ServiceSubmitFormState createState() => _ServiceSubmitFormState();
}

class _ServiceSubmitFormState extends State<ServiceSubmitForm> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  final _serviceTitleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  Future<String?> _sendServiceProposal({
    date,
    startTime,
    endTime,
    price,
    location,
    service,
    notes,
  }) async {
    var userPrefs = await SharedPreferences.getInstance();
    var currentToken = userPrefs.getString('token');

    var url = Uri.parse('https://masla7a.herokuapp.com/orders/create-order');
    var response = await http.post(url, headers: {
      'x-auth-token': '$currentToken',
    }, body: {
      'customerId': widget.receiverId,
      'orderDate': date,
      'startsAt': startTime,
      'endsAt': endTime,
      'price': price,
      'address': location,
      'serviceName': service,
      'notes': notes,
    });

    var resBody = json.decode(response.body);
    print(response.statusCode);
    print(resBody);

    if (response.statusCode != 200 && response.statusCode != 201) {
      Fluttertoast.showToast(
        msg: resBody['message'],
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      return null;
    }

    return resBody['orderInfo']['_id'];
  }

  @override
  void dispose() {
    super.dispose();
    _serviceTitleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Center(
              child: const Text(
                'Pose your service',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                buildFieldTitle('Info'),
                TextField(
                  controller: _serviceTitleController,
                  onChanged: (_) {
                    print(_serviceTitleController.value.text);
                  },
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.help),
                    labelText: 'Service desc.',
                    hintText: 'What you gonna do?',
                    hintStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(15)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money_rounded),
                    labelText: 'Price',
                    hintText: '1200 EGP.',
                    hintStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(15)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on),
                    labelText: 'Location',
                    hintText: 'Where you gonna operate?',
                    hintStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(15)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                buildFieldTitle('Date & Time'),
                TextField(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2023),
                    ).then((pickedDate) {
                      if (pickedDate == null) return;
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    });
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                    hintText: _selectedDate == null
                        ? 'Choose the agreed upon date'
                        : '${DateFormat.yMd().format(_selectedDate!)}',
                    hintStyle: TextStyle(
                        color: _selectedDate == null
                            ? Colors.black54
                            : kPrimaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((pickedTime) {
                      if (pickedTime == null) return;
                      setState(() {
                        _selectedStartTime = pickedTime;
                      });
                      print(pickedTime.format(context));
                    });
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.timelapse_rounded),
                    hintText: _selectedStartTime != null
                        ? _selectedStartTime?.format(context)
                        : 'Start time.',
                    hintStyle: TextStyle(
                        color: _selectedStartTime != null
                            ? kPrimaryColor
                            : Colors.black54),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((pickedTime) {
                      if (pickedTime == null) return;
                      setState(() {
                        _selectedEndTime = pickedTime;
                      });
                      print(pickedTime.format(context));
                    });
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.timelapse_rounded),
                    hintText: _selectedEndTime != null
                        ? _selectedEndTime?.format(context)
                        : 'Expected end time.',
                    hintStyle: TextStyle(
                        color: _selectedEndTime != null
                            ? kPrimaryColor
                            : Colors.black54),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildFieldTitle('Notes'),
                    SizedBox(width: 4),
                    Text(
                      '(Optional)',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextField(
                    controller: _notesController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Private notes for future reference.',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: ElevatedButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: kPrimaryColor,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                var prefs = await SharedPreferences.getInstance();
                var token = prefs.getString('token');
                var now = DateTime.now();

                var orderId = await _sendServiceProposal(
                  date: _selectedDate != null
                      ? _selectedDate.toString()
                      : now.toString(),
                  startTime: _selectedStartTime != null
                      ? DateTime(
                              now.year,
                              now.month,
                              now.day,
                              _selectedStartTime!.hour,
                              _selectedStartTime!.minute)
                          .toString()
                      : now.toString(),
                  endTime: _selectedEndTime != null
                      ? DateTime(now.year, now.month, now.day,
                              _selectedEndTime!.hour, _selectedEndTime!.minute)
                          .toString()
                      : now.add(Duration(hours: 3)).toString(),
                  price: _priceController.value.text.isEmpty
                      ? '200'
                      : _priceController.value.text,
                  location: _locationController.value.text.isEmpty
                      ? 'el zohor prot said egypt'
                      : _locationController.value.text,
                  service: _serviceTitleController.value.text.isEmpty
                      ? 'New Service'
                      : _serviceTitleController.value.text,
                  notes: _notesController.value.text.isEmpty
                      ? 'notes'
                      : _notesController.value.text.isEmpty,
                );

                if (orderId != null) {
                  widget.socket.connect();
                  print('sending');
                  widget.socket.emit('authenticate', {'token': token});
                  widget.socket.emit(
                    'private',
                    {
                      'to': widget.receiverId,
                      'type': 'order',
                      'content': orderId,
                    },
                  );
                  print('sent');
                } else {
                  print('failed');
                  return;
                }

                Navigator.pop(context);
              },
              child: Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
