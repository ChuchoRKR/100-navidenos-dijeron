class Answer {
  final String text;
  final int points;
  Answer({required this.text, required this.points});

  Map<String, dynamic> toJson() => {"text": text, "points": points};
  static Answer fromJson(Map<String, dynamic> j) => Answer(text: j["text"], points: j["points"]);
}

class Question {
  final String text;
  final List<Answer> answers;
  Question({required this.text, required this.answers});

  Map<String, dynamic> toJson() => {
        "text": text,
        "answers": answers.map((a) => a.toJson()).toList(),
      };

  static Question fromJson(Map<String, dynamic> j) => Question(
        text: j["text"],
        answers: (j["answers"] as List).map((a) => Answer.fromJson(Map<String, dynamic>.from(a))).toList(),
      );
}
