import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../providers/game_provider.dart';
import '../styles.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _form = GlobalKey<FormState>();
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _answerCtrls = [];
  final List<TextEditingController> _pointsCtrls = [];

  @override
  void initState() {
    super.initState();
    // start with 4
    for (int i = 0; i < 4; i++) {
      _answerCtrls.add(TextEditingController());
      _pointsCtrls.add(TextEditingController(text: (20 - i * 4).toString()));
    }
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    for (var c in _answerCtrls) c.dispose();
    for (var c in _pointsCtrls) c.dispose();
    super.dispose();
  }

  void _addAnswerField() {
    setState(() {
      _answerCtrls.add(TextEditingController());
      _pointsCtrls.add(TextEditingController(text: "5"));
    });
  }

  void _save() {
    if (_form.currentState?.validate() ?? false) {
      final qText = _questionCtrl.text.trim();
      final answers = <Answer>[];
      for (int i = 0; i < _answerCtrls.length; i++) {
        final at = _answerCtrls[i].text.trim();
        final pt = int.tryParse(_pointsCtrls[i].text) ?? 0;
        if (at.isNotEmpty) answers.add(Answer(text: at, points: pt));
      }
      if (answers.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Agrega al menos 2 respuestas")));
        return;
      }
      final q = Question(text: qText, answers: answers);
      Provider.of<GameProvider>(context, listen: false).addCustomQuestion(q);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pregunta guardada")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar pregunta personalizada"),
        backgroundColor: XmasColors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionCtrl,
                decoration: const InputDecoration(labelText: "Pregunta"),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Escribe la pregunta" : null,
              ),
              const SizedBox(height: 12),
              const Text("Respuestas (texto y puntos)", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...List.generate(_answerCtrls.length, (i) {
                return Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        controller: _answerCtrls[i],
                        decoration: InputDecoration(labelText: "Respuesta ${i + 1}"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _pointsCtrls[i],
                        decoration: const InputDecoration(labelText: "Pts"),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                );
              }),
              const SizedBox(height: 8),
              TextButton.icon(onPressed: _addAnswerField, icon: const Icon(Icons.add), label: const Text("Agregar respuesta")),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(backgroundColor: XmasColors.green), child: const Text("Guardar pregunta"))
            ],
          ),
        ),
      ),
    );
  }
}
