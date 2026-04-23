import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiv/features/info/domain/test_entity.dart';

// Хелпер: достаёт текст по локали из плоских полей (text_ru / text_kz)
String _loc(Map<String, dynamic> json, String field, String locale) {
  final lang = locale == 'kk' ? 'kz' : locale; // kk → kz
  return json['${field}_$lang'] as String? ??
      json['${field}_ru'] as String? ??
      '';
}

class TestOptionModel {
  final Map<String, dynamic> _raw;
  final String risk;
  TestOptionModel(this._raw, this.risk);

  factory TestOptionModel.fromJson(Map<String, dynamic> json) =>
      TestOptionModel(json, json['risk'] as String);

  TestOption toEntity(String locale) => TestOption(
        text: _loc(_raw, 'text', locale),
        risk: risk,
        comment: _loc(_raw, 'comment', locale).isEmpty
            ? null
            : _loc(_raw, 'comment', locale),
      );
}

class TestQuestionModel {
  final String id;
  final Map<String, dynamic> _raw;
  final List<TestOptionModel> options;

  TestQuestionModel(this.id, this._raw, this.options);

  factory TestQuestionModel.fromJson(Map<String, dynamic> json) =>
      TestQuestionModel(
        json['id'] as String,
        json,
        (json['options'] as List)
            .map((e) => TestOptionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  TestQuestion toEntity(String locale) => TestQuestion(
        id: id,
        text: _loc(_raw, 'text', locale),
        options: options.map((o) => o.toEntity(locale)).toList(),
      );
}

class TestBlockModel {
  final String id;
  final Map<String, dynamic> _raw;
  final List<TestQuestionModel> questions;

  TestBlockModel(this.id, this._raw, this.questions);

  factory TestBlockModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TestBlockModel(
      doc.id,
      data,
      (data['questions'] as List)
          .map((e) => TestQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  TestBlock toEntity(String locale) => TestBlock(
        id: id,
        title: _loc(_raw, 'title', locale),
        questions: questions.map((q) => q.toEntity(locale)).toList(),
      );
}

class TestResultsLogicModel {
  final Map<String, dynamic> _raw;
  TestResultsLogicModel(this._raw);

  factory TestResultsLogicModel.fromFirestore(DocumentSnapshot doc) =>
      TestResultsLogicModel(doc.data() as Map<String, dynamic>);

  TestResultsLogic toEntity(String locale) {
    final cats = _raw['categories'] as Map<String, dynamic>;

    TestResultCategory parse(String key) {
      final cat = cats[key] as Map<String, dynamic>;
      final lang = locale == 'kk' ? 'kz' : locale;
      return TestResultCategory(
        description: cat['label_$lang'] as String? ?? cat['label_ru'] as String? ?? '',
        recommendation: cat['rec_$lang'] as String? ?? cat['rec_ru'] as String? ?? '',
      );
    }

    return TestResultsLogic(
      minimal: parse('minimal'),
      moderate: parse('moderate'),
      high: parse('high'),
    );
  }
}