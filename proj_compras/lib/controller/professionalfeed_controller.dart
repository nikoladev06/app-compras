import 'package:flutter/material.dart';
import '../model/professionalpost_model.dart';
import '../model/user_model.dart';
import '../model/comentario_model.dart';

class ProfessionalFeed extends ChangeNotifier {
  final UserModel usuarioAtual = UserModel(id: 2, email: "usuario@email.com", name: "Usuário", password: "123");
  final List<ProfessionalPost> _professionalPosts = [
    ProfessionalPost(
      id: 1,
      description: "*Vaga de emprego*\n" "Desenvolvedor Flutter Junior - Ribeirão Preto",
      date: DateTime(2025, 10, 28, 22, 0),
      // imageUrl: "https://storage.googleapis.com/cms-storage-bucket/build-more-with-flutter.f399274b364a6194c43d.png",
      user: UserModel(id: 1, email: "admin@admin.com", name: "Admin", password: "123"),
      likesCount: 15,
    ),
    ProfessionalPost(
      id: 2,
      description: "*Vaga de emprego*\n" "Analista de Suporte Junior - Ribeirão Preto",
      date: DateTime(2025, 11, 10),
      imageUrl: "https://",
      user: UserModel(id: 1, email: "admin@admin.com", name: "Admin", password: "123"),
      likesCount: 8,
    ),
    ProfessionalPost(
      id: 3,
      description: "*Vaga de emprego*\n" "Estágio em Banco de Dados - Ribeirão Preto",
      date: DateTime(2025, 12, 5),
      user: UserModel(id: 1, email: "admin@admin.com", name: "Admin", password: "123"),
      likesCount: 23,
    )
  ];

  List<ProfessionalPost> get professionalPosts => _professionalPosts;

  void addProfessionalPost(ProfessionalPost newProfessionalPost) {
    _professionalPosts.insert(0, newProfessionalPost);
    notifyListeners();
  }

  void deleteProfessionalPost(int professionalPostId) {
    _professionalPosts.removeWhere((e) => e.id == professionalPostId);
    notifyListeners();
  }

  void toggleLike(int professionalPostId) {
    final professionalPost = _professionalPosts.firstWhere((e) => e.id == professionalPostId);
    professionalPost.isLiked = !professionalPost.isLiked;
    professionalPost.likesCount += professionalPost.isLiked ? 1 : -1;
    notifyListeners();
  }

  void addComentario(int professionalPostId, String texto) {
    final professionalPost = _professionalPosts.firstWhere((e) => e.id == professionalPostId);
    professionalPost.comentarios.add(Comentario(
      id: DateTime.now().millisecondsSinceEpoch,
      user: usuarioAtual,
      text: texto,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  bool isDonoProfessionalPost(ProfessionalPost professionalPost) {
    return professionalPost.user.id == usuarioAtual.id;
  }

  void mostrarOpcoesProfessionalPost(BuildContext context, ProfessionalPost professionalPost) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF222225),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDonoProfessionalPost(professionalPost))
            _buildOpcaoMenu(
              Icons.delete, 
              'Excluir', 
              Colors.red, 
              () {
                _confirmarExclusao(context, professionalPost);
              }
            ),
          _buildOpcaoMenu(
            Icons.report, 
            'Denunciar', 
            Colors.orange, 
            () {
              Navigator.pop(context);
              _mostrarSnackbar(context, 'ProfessionalPost denunciado!', Colors.orange);
            }
          ),
          _buildOpcaoMenu(
            Icons.cancel, 
            'Cancelar', 
            Colors.grey, 
            () {
              Navigator.pop(context);
            }
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, ProfessionalPost professionalPost) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF222225),
        title: const Text('Excluir ProfessionalPost', style: TextStyle(color: Colors.white)),
        content: const Text('Tem certeza?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              deleteProfessionalPost(professionalPost.id);
              Navigator.pop(context);
              _mostrarSnackbar(context, 'ProfessionalPost excluído!', Colors.green);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void mostrarDialogComentario(BuildContext context, ProfessionalPost professionalPost) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF222225),
        title: const Text('Comentar', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Digite seu comentário...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final texto = controller.text.trim();
              if (texto.isNotEmpty) {
                addComentario(professionalPost.id, texto);
                Navigator.pop(context);
                _mostrarSnackbar(context, 'Comentário adicionado!', Colors.green);
              }
            },
            child: const Text('Comentar', style: TextStyle(color: Color(0xFF45b5b7))),
          ),
        ],
      ),
    );
  }

  void compartilharProfessionalPost(BuildContext context, ProfessionalPost professionalPost) {
    _mostrarSnackbar(context, 'Compartilhando: ${professionalPost.description.substring(0, 20)}...', const Color(0xFF45b5b7));
  }

  ListTile _buildOpcaoMenu(IconData icon, String texto, Color cor, VoidCallback onTap) { //esse ListTile é melhor para "botões" que são ícone + texto
    return ListTile(                                                                     // e pra ListTile é melhor usar onTap no lugar de onPressed
      leading: Icon(icon, color: cor),
      title: Text(texto, style: TextStyle(color: cor)),
      onTap: onTap,
    );
  }

  void _mostrarSnackbar(BuildContext context, String texto, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto), 
        backgroundColor: cor, 
        duration: const Duration(seconds: 2)
      )
    );
  }

  void adicionarProfessionalPost(ProfessionalPost novoPost) {
    _professionalPosts.insert(0, novoPost);
    notifyListeners();
  }
}