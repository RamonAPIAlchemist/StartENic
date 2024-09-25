import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userMessage = TextEditingController();

  static const apiKey = "AIzaSyDYwjUZ9QQexlss2L2dUKxNZ2Z6G9K-w5w";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];
  bool _loading = false;

  Future<void> sendMessage() async {
    final message = _userMessage.text.trim();
    if (message.isEmpty) return; // Evitar enviar mensajes vacíos

    _userMessage.clear();

    setState(() {
      // Añadir el mensaje del usuario al chat
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
      _loading = true; // Mostrar indicador de carga
    });

    // Enviar el mensaje del usuario al bot y esperar la respuesta
    final content = [Content.text(message)];
    try {
      final response = await model.generateContent(content);
      setState(() {
        // Añadir la respuesta del bot al chat
        _messages.add(Message(
            isUser: false, message: response.text ?? "", date: DateTime.now()));
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _loading = false; // Ocultar indicador de carga
      });
    }
  }

  void _showError(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente StartENic'),
        backgroundColor: const Color.fromARGB(255, 178, 245, 137),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  date: DateFormat('HH:mm').format(message.date),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    controller: _userMessage,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      label: const Text("Pidele Una Recomendación"),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: const EdgeInsets.all(15),
                  iconSize: 30,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 107, 177, 2)),
                    foregroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 250, 250, 250)),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                  ),
                  onPressed: _loading
                      ? null
                      : sendMessage, // Deshabilitar el botón mientras carga
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          if (_loading)
            const CircularProgressIndicator(), // Mostrar indicador de carga
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? const Color.fromARGB(255, 184, 240, 121)
            : const Color.fromARGB(255, 206, 253, 152),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
          topRight: const Radius.circular(10),
          bottomRight: isUser ? Radius.zero : const Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                color:
                    isUser ? const Color.fromARGB(255, 0, 0, 0) : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(
                color:
                    isUser ? const Color.fromARGB(255, 2, 1, 1) : Colors.black),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}
