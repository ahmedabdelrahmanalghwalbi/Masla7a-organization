class Notification {
  late List<String> targetUsers;
  late bool seen;
  late String icon;
  late String sId;
  late String title;
  late String body;
  late SenderUser senderUser;
  late String subjectType;
  late String subject;
  late String createdAt;
  late String updatedAt;
  late int iV;

  Notification(
      {required this.targetUsers,
        required this.seen,
        required this.icon,
        required this.sId,
        required this.title,
        required this.body,
        required this.senderUser,
        required this.subjectType,
        required this.subject,
        required this.createdAt,
        required this.updatedAt,
        required this.iV});

  Notification.fromJson(Map<String, dynamic> json) {
    targetUsers = json['targetUsers'].cast<String>();
    seen = json['seen'];
    icon = json['icon'];
    sId = json['_id'];
    title = json['title'];
    body = json['body'];
    senderUser = (json['senderUser'] != null
        ? new SenderUser.fromJson(json['senderUser'])
        : null)!;
    subjectType = json['subjectType'];
    subject = json['subject'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['targetUsers'] = this.targetUsers;
    data['seen'] = this.seen;
    data['icon'] = this.icon;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['body'] = this.body;
    if (this.senderUser != null) {
      data['senderUser'] = this.senderUser.toJson();
    }
    data['subjectType'] = this.subjectType;
    data['subject'] = this.subject;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class SenderUser {
  late String sId;
  late String name;
  late String profilePic;

  SenderUser({required this.sId, required this.name, required this.profilePic});

  SenderUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    return data;
  }
}