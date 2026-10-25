// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GalleryCard _$GalleryCardFromJson(Map<String, dynamic> json) => _GalleryCard(
  id: json['id'] as String? ?? '',
  itemName: json['itemName'] as String? ?? '',
  itemDescription: json['itemDescription'] as String? ?? '',
  imgSource: json['imgSource'] as String? ?? '',
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  reviewPassed: json['reviewPassed'] as bool? ?? false,
  userName: json['userName'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$GalleryCardToJson(_GalleryCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemName': instance.itemName,
      'itemDescription': instance.itemDescription,
      'imgSource': instance.imgSource,
      'likes': instance.likes,
      'reviewPassed': instance.reviewPassed,
      'userName': instance.userName,
      'createdAt': instance.createdAt,
    };

_GalleryListResponse _$GalleryListResponseFromJson(Map<String, dynamic> json) =>
    _GalleryListResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => GalleryCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GalleryCard>[],
    );

Map<String, dynamic> _$GalleryListResponseToJson(
  _GalleryListResponse instance,
) => <String, dynamic>{'items': instance.items};

_GallerySubmitRequest _$GallerySubmitRequestFromJson(
  Map<String, dynamic> json,
) => _GallerySubmitRequest(
  itemName: json['itemName'] as String,
  itemDescription: json['itemDescription'] as String? ?? '',
  imgSource: json['imgSource'] as String,
);

Map<String, dynamic> _$GallerySubmitRequestToJson(
  _GallerySubmitRequest instance,
) => <String, dynamic>{
  'itemName': instance.itemName,
  'itemDescription': instance.itemDescription,
  'imgSource': instance.imgSource,
};

_GalleryItemResponse _$GalleryItemResponseFromJson(Map<String, dynamic> json) =>
    _GalleryItemResponse(
      item: GalleryCard.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GalleryItemResponseToJson(
  _GalleryItemResponse instance,
) => <String, dynamic>{'item': instance.item};

_LikeResponse _$LikeResponseFromJson(Map<String, dynamic> json) =>
    _LikeResponse(likes: (json['likes'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$LikeResponseToJson(_LikeResponse instance) =>
    <String, dynamic>{'likes': instance.likes};

_MessageItem _$MessageItemFromJson(Map<String, dynamic> json) => _MessageItem(
  id: json['id'] as String? ?? '',
  senderName: json['senderName'] as String? ?? '',
  text: json['text'] as String? ?? '',
  timeText: json['timeText'] as String? ?? '',
  haveRead: json['haveRead'] as bool? ?? false,
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$MessageItemToJson(_MessageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderName': instance.senderName,
      'text': instance.text,
      'timeText': instance.timeText,
      'haveRead': instance.haveRead,
      'createdAt': instance.createdAt,
    };

_MessageListResponse _$MessageListResponseFromJson(Map<String, dynamic> json) =>
    _MessageListResponse(
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MessageItem>[],
    );

Map<String, dynamic> _$MessageListResponseToJson(
  _MessageListResponse instance,
) => <String, dynamic>{'messages': instance.messages};

_UnreadResponse _$UnreadResponseFromJson(Map<String, dynamic> json) =>
    _UnreadResponse(unread: (json['unread'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$UnreadResponseToJson(_UnreadResponse instance) =>
    <String, dynamic>{'unread': instance.unread};

_WorkOrderItem _$WorkOrderItemFromJson(Map<String, dynamic> json) =>
    _WorkOrderItem(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      orderTitle: json['orderTitle'] as String? ?? '',
      orderText: json['orderText'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      closed: json['closed'] as bool? ?? false,
    );

Map<String, dynamic> _$WorkOrderItemToJson(_WorkOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'orderTitle': instance.orderTitle,
      'orderText': instance.orderText,
      'createdAt': instance.createdAt,
      'closed': instance.closed,
    };

_WorkOrderListResponse _$WorkOrderListResponseFromJson(
  Map<String, dynamic> json,
) => _WorkOrderListResponse(
  orders:
      (json['orders'] as List<dynamic>?)
          ?.map((e) => WorkOrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <WorkOrderItem>[],
);

Map<String, dynamic> _$WorkOrderListResponseToJson(
  _WorkOrderListResponse instance,
) => <String, dynamic>{'orders': instance.orders};

_CreateWorkOrderRequest _$CreateWorkOrderRequestFromJson(
  Map<String, dynamic> json,
) => _CreateWorkOrderRequest(
  title: json['title'] as String,
  text: json['text'] as String,
);

Map<String, dynamic> _$CreateWorkOrderRequestToJson(
  _CreateWorkOrderRequest instance,
) => <String, dynamic>{'title': instance.title, 'text': instance.text};

_WorkOrderResponse _$WorkOrderResponseFromJson(Map<String, dynamic> json) =>
    _WorkOrderResponse(
      order: WorkOrderItem.fromJson(json['order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkOrderResponseToJson(_WorkOrderResponse instance) =>
    <String, dynamic>{'order': instance.order};

_MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    _MessageResponse(message: json['message'] as String? ?? '');

Map<String, dynamic> _$MessageResponseToJson(_MessageResponse instance) =>
    <String, dynamic>{'message': instance.message};
