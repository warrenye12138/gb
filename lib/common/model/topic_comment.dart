class TopicCommentModel {
  String? gameId;
  String? topicId;
  String? time;
  String? commentId;
  String? content;
  String? name;

  TopicCommentModel({
    this.gameId,
    this.topicId,
    this.time,
    this.commentId,
    this.content,
    this.name,
  });

  factory TopicCommentModel.fromJson(Map<String, dynamic> json) {
    return TopicCommentModel(
      gameId: json['gameId'],
      topicId: json['topicId'],
      time: json['time'],
      commentId: json['commentId'],
      content: json['content'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'gameId': gameId,
        'topicId': topicId,
        'time': time,
        'commentId': commentId,
        'content': content,
        'name': name,
      };
}

class CommentModel {
  String? id;
  String? topicId;
  String? time;
  String? content;
  String? uid;
  String? name;
  int? preciseTime;

  CommentModel(
      {this.id,
      this.topicId,
      this.time,
      this.content,
      this.uid,
      this.name,
      this.preciseTime});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        id: json['id'],
        topicId: json['topicId'],
        time: json['time'],
        content: json['content'],
        uid: json['uid'],
        name: json['name'],
        preciseTime: json['preciseTime']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'topicId': topicId,
        'time': time,
        'content': content,
        'uid': uid,
        'name': name,
        'preciseTime': preciseTime
      };
}

class OpinionModel {
  String? topicId;
  String? gameId;
  int? time;
  int? state;
  String? uid;

  OpinionModel({
    this.topicId,
    this.gameId,
    this.time,
    this.state,
    this.uid,
  });

  factory OpinionModel.fromJson(Map<String, dynamic> json) {
    return OpinionModel(
      topicId: json['topicId'],
      gameId: json['gameId'],
      time: json['time'],
      state: json['state'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'topicId': topicId,
        'gameId': gameId,
        'time': time,
        'state': state,
        'uid': uid,
      };
}
