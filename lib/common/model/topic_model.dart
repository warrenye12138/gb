class TopicModel {
  String? gameId;
  String? topicId;
  String? uid;
  String? name;
  String? time;
  int? preciseTime;
  String? content;
  List<String>? images;
  int? collect;
  int? comment;
  String? type;
  int? good;
  int? middle;
  int? bad;

  List<String>? get imagesInfo =>
      (images != null && images!.isNotEmpty) ? images : null;

  TopicModel({
    this.gameId,
    this.topicId,
    this.uid,
    this.name,
    this.time,
    this.preciseTime,
    this.content,
    this.images,
    this.collect,
    this.comment,
    this.type,
    this.good,
    this.middle,
    this.bad,
  });

  factory TopicModel.fromJson(Map<dynamic, dynamic> json) {
    return TopicModel(
      gameId: json['gameId'],
      topicId: json['topicId'],
      uid: json['uid'],
      name: json['name'],
      time: json ['time'],
      preciseTime: json['preciseTime'],
      content: json['content'],
      images: json['images'] == null
          ? null
          : List<String>.from(
              json['images'].map((e) => e.toString()).toList()),
      collect: json['collect'],
      comment: json['comment'],
      type: json['type'],
      good: json['good'],
      middle: json['middle'],
      bad: json['bad'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'gameId': gameId,
        'topicId': topicId,
        'uid': uid,
        'name': name,
        'time': time,
        'preciseTime': preciseTime,
        'content': content,
        'images': images,
        'collect': collect,
        'comment': comment,
        'type': type,
        'good': good,
        'middle': middle,
        'bad': bad,
      };
}
