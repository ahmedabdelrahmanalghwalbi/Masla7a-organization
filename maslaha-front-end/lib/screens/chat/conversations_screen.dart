import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/conversation_tile_model.dart';
import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'components/conversation_card.dart';

class ConversationsScreen extends StatefulWidget {
  static const routeName = '/conversations';
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final _srchController = TextEditingController();
  var _isSearchActive = false;

  List<ConversationTile> _conversations = [];
  var _isLoading = false;

  late Timer requestTimer;

  String formatMessageTime(DateTime dateTime) {
    var timePassed = DateTime.now().difference(dateTime);

    if (timePassed.inDays == 0 &&
        timePassed.inHours == 0 &&
        timePassed.inMinutes == 0) {
      return 'Just now';
    } else if (timePassed.inDays == 0 &&
        timePassed.inHours == 0 &&
        (timePassed.inMinutes > 2 && timePassed.inMinutes <= 10)) {
      return 'Few minutes ago';
    } else if (timePassed.inDays == 0 && timePassed.inHours != 0) {
      return '${timePassed.inHours} h ago';
    } else if (timePassed.inDays == 1) {
      return 'Yesterday';
    } else if (timePassed.inDays > 1 && timePassed.inDays <= 5) {
      return '${timePassed.inDays} days ago';
    }
    return DateFormat('dd MMM').format(dateTime);
  }

  _getUserConversations() async {
    setState(() {
      _isLoading = true;
    });
    var userPrefs = await SharedPreferences.getInstance();
    var uid = userPrefs.getString('id');
    var currentToken = userPrefs.getString('token');

    var url =
        Uri.parse('https://masla7a.herokuapp.com/chatting/my-conversations');

    requestTimer = Timer.periodic(Duration(seconds: 1), (_) async {
      var request = http.Request('GET', url)
        ..headers.addAll({'x-auth-token': '$currentToken'});
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      var resBody = json.decode(respStr);

      if (response.statusCode == 200) {
        List<ConversationTile> conversations = [];

        resBody.forEach((conv) {
          var recevierData =
              (conv['users'] as List).firstWhere((usr) => usr['_id'] != uid);
          var currentUser =
              (conv['users'] as List).firstWhere((usr) => usr['_id'] == uid);
          conversations.add(ConversationTile(
            convId: conv['_id'],
            myRole: currentUser['role'],
            receiverId: recevierData['_id'],
            receiverName: recevierData['name'],
            receiverProfilePic: recevierData['profilePic'],
            receiverStatus: recevierData['availability'],
            lastMessage: conv['lastMessage']['user'] == uid
                ? 'Me: ${conv['lastMessage']['content']}'
                : '${recevierData['name'].split(' ')[0]}: ${conv['lastMessage']['content']}',
            lastMessageTime: formatMessageTime(
                DateTime.parse((conv['lastMessage']['createdAt']))),
          ));
        });
        if (_isSearchActive == false) {
          try {
            setState(() {
              _conversations = conversations;
            });
          } catch (err) {}
        }
        try {
          setState(() {
            _isLoading = false;
          });
        } catch (err) {}
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserConversations();
  }

  @override
  void dispose() {
    super.dispose();
    requestTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kPrimaryColor,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Chat',
          style: const TextStyle(
            fontSize: 24,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(getProportionateScreenHeight(65)),
          child: Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: TextField(
              controller: _srchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _isSearchActive = false;
                  });
                  return;
                }
                setState(() {
                  _isSearchActive = true;
                });
                List<ConversationTile> results = [];
                _conversations.forEach((conv) {
                  if (conv.receiverName
                      .toLowerCase()
                      .contains(value.toLowerCase())) {
                    results.add(ConversationTile(
                      convId: conv.convId,
                      myRole: conv.myRole,
                      receiverId: conv.receiverId,
                      receiverName: conv.receiverName,
                      receiverProfilePic: conv.receiverProfilePic,
                      receiverStatus: conv.receiverStatus,
                      lastMessage: conv.lastMessage,
                      lastMessageTime: conv.lastMessageTime,
                    ));
                  }
                });
                setState(() {
                  _conversations = results;
                });
              },
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade300,
                hintText: 'Search',
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.only(left: 15),
                suffixIcon: const Icon(Icons.person_search_rounded),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: const CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          : _conversations.isEmpty
              ? const Center(child: const Text('No chats yet!'))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 4),
                  itemBuilder: (ctx, index) => Column(
                    children: [
                      ConversationCard(
                        onDismissed: (_) async {
                          var userPrefs = await SharedPreferences.getInstance();
                          var currentToken = userPrefs.getString('token');

                          var url = Uri.parse(
                              'https://masla7a.herokuapp.com/chatting/${_conversations[index].convId}');
                          await http.delete(url,
                              headers: {'x-auth-token': '$currentToken'});

                          _conversations.removeAt(index);
                        },
                        convId: _conversations[index].convId,
                        myRole: _conversations[index].myRole,
                        receiverId: _conversations[index].receiverId,
                        receiverName: _conversations[index].receiverName,
                        receiverProfilePic:
                            _conversations[index].receiverProfilePic,
                        receiverStatus: _conversations[index].receiverStatus,
                        lastMessage: _conversations[index].lastMessage,
                        lastMessageTime: _conversations[index].lastMessageTime,
                      ),
                      if (index != _conversations.length - 1)
                        Divider(
                          endIndent: getProportionateScreenWidth(20),
                          indent: getProportionateScreenWidth(20),
                        ),
                    ],
                  ),
                  itemCount: _conversations.length,
                ),
    );
  }
}
