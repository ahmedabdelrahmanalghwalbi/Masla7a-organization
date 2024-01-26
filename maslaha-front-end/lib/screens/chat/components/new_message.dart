import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../../../shared/constants.dart';
import 'service_submit_form.dart';

class NewMessage extends StatefulWidget {
  final String convId;
  final String receiverId;
  final String myRole;
  final IO.Socket socket;

  const NewMessage({
    required this.convId,
    required this.receiverId,
    required this.myRole,
    required this.socket,
  });

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage>
    with SingleTickerProviderStateMixin {
  File? _selectedMediaFile;
  final _picker = ImagePicker();

  final _controller = TextEditingController();

  var _showSendButton = false;

  Future getMedia() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedMediaFile = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _showSendButton = widget.myRole == 'customer' ? true : false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: _controller,
                  onChanged: (msg) {
                    if (msg.isNotEmpty) {
                      if (widget.myRole == 'customer') return;
                      setState(() {
                        _showSendButton = true;
                      });
                    }
                  },
                  onSubmitted: (msg) async {
                    var prefs = await SharedPreferences.getInstance();
                    var token = prefs.getString('token');

                    if (_controller.text.isNotEmpty) {
                      widget.socket.connect();
                      print('sending');
                      widget.socket.emit('authenticate', {'token': token});
                      widget.socket.emit(
                        'private',
                        {
                          'content': _controller.value.text,
                          'to': widget.receiverId,
                        },
                      );
                      print('sent');

                      _controller.clear();
                      if (widget.myRole != 'customer') {
                        setState(() {
                          _showSendButton = false;
                        });
                      }
                    }
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    prefixIcon: SizedBox.shrink(),
                    hintText: 'Send a message...',
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.photo,
                    size: 28,
                    color: kPrimaryColor,
                  ),
                  splashRadius: 1,
                  onPressed: () async {
                    await getMedia();

                    var prefs = await SharedPreferences.getInstance();
                    var token = prefs.getString('token');

                    var url =
                        Uri.parse('https://masla7a.herokuapp.com/chatting/');

                    if (_selectedMediaFile != null) {
                      var request = http.MultipartRequest('POST', url);
                      request.headers.addAll({'x-auth-token': '$token'});
                      final file = await http.MultipartFile.fromPath(
                          "image", _selectedMediaFile!.path);
                      request.files.add(file);
                      request.fields['conversationID'] = widget.convId;

                      var response = await request.send();
                      final respStr = await response.stream.bytesToString();
                      var result = json.decode(respStr);
                      print(result);

                      widget.socket.connect();
                      widget.socket.emit('authenticate', {'token': token});
                      widget.socket.emit(
                        'files',
                        {
                          'to': widget.receiverId,
                          'conversationID': widget.convId,
                          'type': 'image',
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: _showSendButton
                ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/chat_icons/send.svg',
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      print('sent button pressed');
                      var prefs = await SharedPreferences.getInstance();
                      var token = prefs.getString('token');

                      if (_controller.text.isNotEmpty) {
                        widget.socket.connect();
                        print('sending');
                        widget.socket.emit('authenticate', {'token': token});
                        widget.socket.emit(
                          'private',
                          {
                            'to': widget.receiverId,
                            'type': 'text',
                            'content': _controller.value.text,
                          },
                        );

                        print('sent');

                        _controller.clear();
                        if (widget.myRole != 'customer') {
                          setState(() {
                            _showSendButton = false;
                          });
                        }
                      }
                    },
                  )
                : IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/chat_icons/contract.svg',
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        enableDrag: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        builder: (context) {
                          return ServiceSubmitForm(
                            receiverId: widget.receiverId,
                            socket: widget.socket,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildMediaPicker(
      {required IconData icon, required Function() tapHandler}) {
    return GestureDetector(
      onTap: tapHandler,
      child: CircleAvatar(
        radius: 25,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
