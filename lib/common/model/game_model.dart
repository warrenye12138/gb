class GameModel {
  String? gameName;
  String? gameId;
  String? gameIcon;
  String? description;

  GameModel({this.gameName, this.gameId, this.gameIcon, this.description});

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        gameName: json['gameName'],
        gameId: json['gameId'],
        gameIcon: json['gameIcon'],
        description: json['description'],
      );
  Map<String, dynamic> toJson() => {
        'gameName': gameName,
        'gameId': gameId,
        'gameIcon': gameIcon,
        'description': description,
      };
}
