import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/trade_info_socket.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/network_util.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/socket_response.dart';

class SocketProvider extends GetxController {
  IOWebSocketChannel? webSocket;
  late Timer _timer;
  List channelList = [""];
  List<SocketListener> listenerList = [];
  bool _disconnected = true;

  @override
  void onInit() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (webSocket == null) {
        connectSocket();
      } else {
        if (_disconnected && await NetworkCheck.isOnline(showError: false)) {
          connectSocket();
        } else {
          webSocket?.sink.add('{"event":"pusher:ping","data":{}}');
        }
      }
    });

    webSocket?.stream.handleError((error) {
      printFunction("webSocket error", error);
    });
    super.onInit();
  }

  void connectSocket() {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.userApiSecret] = dotenv.env[EnvKeyValue.kApiSecret] ?? "";
    webSocket = IOWebSocketChannel.connect(Uri.parse(SocketConstants.baseUrl), headers: mapObj);
    _disconnected = false;
    webSocket?.stream.listen((message) {
      //printFunction("webSocket message", message);
      parseMessage(socketResponseFromJson(message));
    }, onDone: () {
      _disconnected = true;
      printFunction("webSocket _disconnected", _disconnected);
    }, onError: (error) {
      printFunction("webSocket error", error);
    });

    if (channelList.isNotEmpty) {
      for (String channel in channelList) {
        webSocket?.sink.add('{"event":"pusher:subscribe","data":{"channel":"$channel"}}');
      }
    }
  }

  parseMessage(SocketResponse socketResponse) {
    printFunction("webSocket channel:event", "${socketResponse.channel} : ${socketResponse.event}");

    switch (socketResponse.event) {
      case "pusher:connection_established":
        return;
      case SocketConstants.eventNotification:
        NotificationData data = notificationDataFromJson(socketResponse.data ?? "");
        _callListeners(socketResponse.channel ?? "", SocketConstants.eventNotification, data);
        return;
      case SocketConstants.eventOrderPlace:
        if ((socketResponse.channel ?? "").contains(SocketConstants.channelDashboard)) {
          final sData = socketOrderPlaceFromJson(socketResponse.data ?? "");
          _callListeners(socketResponse.channel ?? "", SocketConstants.eventOrderPlace, sData);
        }
        return;
      case SocketConstants.eventOrderRemove:
        if ((socketResponse.channel ?? "").contains(SocketConstants.channelDashboard)) {
          final sData = socketOrderPlaceFromJson(socketResponse.data ?? "");
          _callListeners(socketResponse.channel ?? "", SocketConstants.eventOrderRemove, sData);
        }
        return;
      case SocketConstants.eventProcess:
        SocketTradeInfo data = socketTradeInfoFromJson(socketResponse.data ?? "");
        _callListeners(socketResponse.channel ?? "", SocketConstants.eventProcess, data);
        return;
      case SocketConstants.eventFutureTradeData:
        FutureTradeMyOrders data = futureTradeMyOrdersFromJson(socketResponse.data ?? "");
        _callListeners(socketResponse.channel ?? "", SocketConstants.eventFutureTradeData, data);
        return;
      case SocketConstants.eventMarketDetailsData:
        final data = json.decode(socketResponse.data ?? "");
        _callListeners(socketResponse.channel ?? "", SocketConstants.eventMarketDetailsData, data);
        return;
      case SocketConstants.eventMarketOverviewCoinStatisticList:
        final data = json.decode(socketResponse.data ?? "");
        _callListeners(socketResponse.channel ?? "", SocketConstants.eventMarketOverviewCoinStatisticList, data);
        return;
      case SocketConstants.eventMarketOverviewTopCoinList:
        final data = json.decode(socketResponse.data ?? "");
        _callListeners(socketResponse.channel ?? "", SocketConstants.eventMarketOverviewTopCoinList, data);
        return;
    }
    final selfEvent = "${SocketConstants.eventOrderPlace}_${gUserRx.value.id}";
    if (socketResponse.event == selfEvent) {
      final sData = socketUserHistoryFromJson(socketResponse.data ?? "");
      _callListeners(socketResponse.channel ?? "", socketResponse.event ?? "", sData);
      return;
    }
  }

  void subscribeEvent(String channel, SocketListener listener) {
    if (!channelList.contains(channel)) {
      webSocket?.sink.add('{"event":"pusher:subscribe","data":{"channel":"$channel"}}');
      channelList.add(channel);
    }
    if (!listenerList.contains(listener)) {
      listenerList.add(listener);
    }
  }

  void unSubscribeEvent(String channel, SocketListener? listener) {
    printFunction("unSubscribeEvent channel", channel);
    webSocket?.sink.add('{"event":"pusher:unsubscribe","data":{"channel":"$channel"}}');
    channelList.remove(channel);
    if (listener != null) listenerList.remove(listener);
  }

  void unSubscribeAllChannel() {
    for (var channel in channelList) {
      webSocket?.sink.add('{"event":"pusher:unsubscribe","data":{"channel":"$channel"}}');
    }
    channelList.clear();
    listenerList.clear();
  }

  void closeWebSocket() {
    webSocket?.sink.close(status.goingAway);
    _timer.cancel();
    channelList.clear();
    listenerList.clear();
  }

  void _callListeners(String channel, String event, dynamic data) {
    for (var element in listenerList) {
      element.onDataGet(channel, event, data);
    }
  }
}

abstract class SocketListener {
  void onDataGet(String channel, String event, dynamic data);
}

//{channel: test_notification, event: admin_notification, data: {"title":"Test notification title","body":{"name":"Test 1","role":"Admin","description":"Some text will be written here"}}}
///webSocket.sink.add('{"event":"pusher:subscribe","data":{"channel":"test_notification"}}');
