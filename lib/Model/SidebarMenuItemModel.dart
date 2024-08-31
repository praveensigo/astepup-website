import 'package:flutter/material.dart';

enum MenuType {
  stage,
  module,
  section,
  video,
  sectionQuiz,
  moduleQuiz,
  stageQuiz,
  finalMasteryQuiz,
  unvaild
}

class SideMenuItem {
  SideMenuItem(
      {required this.key,
      this.title = const Text(""),
      required this.type,
      required this.id,
      this.titleString,
      this.currentIndex = 0,
      this.isLastModule = false,
      this.isLastStage = false,
      this.isLastVideo = false,
      this.isLastSection = false,
      this.idMapper,
      this.children = const [],
      this.currentData = const {},
      this.parentKey,
      this.isExpanded});

  final Widget title;
  final MenuType type;
  final String id;
  final String key;
  final String? titleString;
  final bool isLastModule;
  final bool isLastStage;
  final bool isLastSection;
  final bool isLastVideo;
  final int currentIndex;
  final Map<String, dynamic> currentData;
  final IdMap? idMapper;
  final List<SideMenuItem?> children;
  final String? parentKey;
  bool? isExpanded;

  factory SideMenuItem.fromJson(Map<String, dynamic> json) => SideMenuItem(
        key: json['key'],
        type: MenuType.values[json['type']],
        id: json['id'],
        titleString: json['titleString'],
        isLastModule: json['isLastModule'],
        isLastStage: json['isLastStage'],
        isLastSection: json['isLastSection'],
        isLastVideo: json['isLastVideo'],
        currentIndex: json['currentIndex'],
        idMapper: json['idMapper'],
        children: List<SideMenuItem?>.from(
            json['children']?.map((x) => SideMenuItem.fromJson(x)) ?? []),
        parentKey: json['parentKey'],
        isExpanded: json['isExpanded'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'type': type.index,
        'id': id,
        'titleString': titleString,
        'isLastModule': isLastModule,
        'isLastStage': isLastStage,
        'isLastSection': isLastSection,
        'isLastVideo': isLastVideo,
        'currentIndex': currentIndex,
        'idMapper': idMapper,
        'children': List<dynamic>.from(children.map((x) => x?.toJson())),
        'parentKey': parentKey,
        'isExpanded': isExpanded,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SideMenuItem &&
          key == other.key &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          type == other.type &&
          id == other.id &&
          titleString == other.titleString &&
          isLastVideo == other.isLastVideo &&
          isLastModule == other.isLastModule &&
          isLastStage == other.isLastStage &&
          isLastSection == other.isLastSection &&
          currentIndex == other.currentIndex &&
          idMapper == other.idMapper &&
          listEquals(children, other.children) &&
          parentKey == other.parentKey &&
          isExpanded == other.isExpanded;

  @override
  int get hashCode =>
      title.hashCode ^
      key.hashCode ^
      type.hashCode ^
      id.hashCode ^
      titleString.hashCode ^
      isLastModule.hashCode ^
      isLastStage.hashCode ^
      isLastVideo.hashCode ^
      isLastSection.hashCode ^
      currentIndex.hashCode ^
      idMapper.hashCode ^
      listHashCode(children) ^
      parentKey.hashCode ^
      isExpanded.hashCode;

  @override
  String toString() {
    return """{
      "Key":"$key", 
      "type": "$type", 
      "id": $id, 
      "titleString": "$titleString", 
      "isLastModule": $isLastModule, 
      "isLastStage": $isLastStage, 
      "isLastSection": $isLastSection, 
      "isLastVideo": $isLastVideo, 
      "currentIndex": $currentIndex,
      "idMapper": $idMapper, 
      "children": $children, 
      "parentKey": $parentKey,
      "isExpanded": $isExpanded
      }""";
  }

  SideMenuItem copyWith({
    Widget? title,
    String? key,
    MenuType? type,
    String? id,
    String? titleString,
    bool? isLastModule,
    bool? isLastStage,
    bool? isLastSection,
    bool? isLastVideo,
    int? currentIndex,
    String? nextVideoId,
    IdMap? idMapper,
    List<SideMenuItem?>? children,
    Object? data,
    String? parentKey,
    bool? isExpanded,
  }) {
    return SideMenuItem(
      key: key ?? this.key,
      title: title ?? this.title,
      type: type ?? this.type,
      id: id ?? this.id,
      titleString: titleString ?? this.titleString,
      isLastModule: isLastModule ?? this.isLastModule,
      isLastStage: isLastStage ?? this.isLastStage,
      isLastSection: isLastSection ?? this.isLastSection,
      isLastVideo: isLastVideo ?? this.isLastVideo,
      currentIndex: currentIndex ?? this.currentIndex,
      idMapper: idMapper ?? this.idMapper,
      children: children ?? this.children,
      parentKey: parentKey ?? this.parentKey,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

bool listEquals(List<SideMenuItem?> list1, List<SideMenuItem?> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

int listHashCode(List<SideMenuItem?> list) {
  int result = 0;
  for (var item in list) {
    result ^= item.hashCode;
  }
  return result;
}

class IdMap {
  String? sectionId;
  String? moduleId;
  String? stageId;
  String? courseId;

  IdMap({
    this.sectionId = '',
    this.moduleId = '',
    this.stageId = '',
    this.courseId = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdMap &&
          runtimeType == other.runtimeType &&
          sectionId == other.sectionId &&
          moduleId == other.moduleId &&
          stageId == other.stageId &&
          courseId == other.courseId;

  @override
  int get hashCode =>
      sectionId.hashCode ^
      moduleId.hashCode ^
      stageId.hashCode ^
      courseId.hashCode;

  @override
  String toString() {
    return """{
     "sectionId": $sectionId,
     "moduleId": $moduleId, 
     "stageId": $stageId, 
     "courseId": $courseId
     }""";
  }

  IdMap copyWith({
    String? sectionId,
    String? moduleId,
    String? stageId,
    String? courseId,
  }) {
    return IdMap(
      sectionId: sectionId ?? this.sectionId,
      moduleId: moduleId ?? this.moduleId,
      stageId: stageId ?? this.stageId,
      courseId: courseId ?? this.courseId,
    );
  }
}
