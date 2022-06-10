import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'saved_jobs_record.g.dart';

abstract class SavedJobsRecord
    implements Built<SavedJobsRecord, SavedJobsRecordBuilder> {
  static Serializer<SavedJobsRecord> get serializer =>
      _$savedJobsRecordSerializer;

  @nullable
  DocumentReference get jobSaved;

  @nullable
  DocumentReference get user;

  @nullable
  DateTime get savedTime;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(SavedJobsRecordBuilder builder) => builder;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('savedJobs');

  static Stream<SavedJobsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<SavedJobsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  SavedJobsRecord._();
  factory SavedJobsRecord([void Function(SavedJobsRecordBuilder) updates]) =
      _$SavedJobsRecord;

  static SavedJobsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createSavedJobsRecordData({
  DocumentReference jobSaved,
  DocumentReference user,
  DateTime savedTime,
}) =>
    serializers.toFirestore(
        SavedJobsRecord.serializer,
        SavedJobsRecord((s) => s
          ..jobSaved = jobSaved
          ..user = user
          ..savedTime = savedTime));
