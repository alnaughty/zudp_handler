import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class ZUDPHandler {
  Future<void> send(String ip, int port, String message,
      {ValueChanged<String>? onDataReceive}) async {
    try {
      final RawDatagramSocket socket =
          await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      // if (mounted) setState(() {});
      if (onDataReceive != null) {
        socket.listen((RawSocketEvent event) {
          if (event == RawSocketEvent.read) {
            final Datagram? datagram = socket.receive();
            if (datagram != null) {
              String message = String.fromCharCodes(datagram.data);
              onDataReceive(message);
              print('Received message: $message');
            }
          }
        });
      }
      InternetAddress serverAddress = InternetAddress(ip);
      int serverPort = port;
      socket.send(message.codeUnits, serverAddress, serverPort);
      socket.close();
    } catch (e, s) {
      print(s);
    }
  }
}
