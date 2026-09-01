import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorage {
  static final Map<String, List<Map<String, String>>> _cachedMessages = {};

  
  static Future<List<Map<String, String>>> loadMessages(String chatName) async {
    if (_cachedMessages.containsKey(chatName)) {
      return _cachedMessages[chatName]!;
    }

    final prefs = await SharedPreferences.getInstance();
    String? messagesJson = prefs.getString("chat_$chatName");

    if (messagesJson != null) {
      List<Map<String, String>> messages =
          List<Map<String, String>>.from(jsonDecode(messagesJson));
      _cachedMessages[chatName] = messages;
      return messages;
    }

    return [];
  }

  
  static Future<void> saveMessages(
      String chatName, List<Map<String, String>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    String messagesJson = jsonEncode(messages);
    await prefs.setString("chat_$chatName", messagesJson);

    _cachedMessages[chatName] = messages;
  }
}
