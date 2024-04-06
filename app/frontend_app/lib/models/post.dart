class Post {
  final int id;
  String user;
  String userDescription;
  DateTime time;
  String area;
  int commentsCount;
  int repostCount;
  int followerCount;
  String content;
  double isRumor;

  Post({
    required this.id,
    required this.user,
    required this.userDescription,
    required this.time,
    required this.area,
    required this.commentsCount,
    required this.repostCount,
    required this.followerCount,
    required this.content,
    required this.isRumor,
  });

  Map<String, dynamic> toMap() {
    return {
      // auto increase id
      'user': user,
      'userDescription': userDescription,
      'time': time.millisecondsSinceEpoch,
      'area': area,
      'commentsCount': commentsCount,
      'repostCount': repostCount,
      'followerCount': followerCount,
      'content': content,
      'isRumor': isRumor,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      user: map['user'],
      userDescription: map['userDescription'],
      time: DateTime.parse(map['time']),
      area: map['area'],
      commentsCount: map['commentsCount'],
      repostCount: map['repostCount'],
      followerCount: map['followerCount'],
      content: map['content'],
      isRumor: map['isRumor'],
    );
  }
}
