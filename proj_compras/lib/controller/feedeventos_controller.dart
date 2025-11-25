import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/postevento_model.dart';
import '../model/user_model.dart';

class FeedEventos {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Evento>> obterEventos() async {
    try {
      print('🔄 Obtendo eventos do Firebase...');
      print('📍 Acessando collection: eventos');
      
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('eventos')
          .orderBy('createdAt', descending: true)
          .get();

      print('✅ ${snapshot.docs.length} eventos encontrados');
      
      if (snapshot.docs.isEmpty) {
        print('⚠️ Nenhum documento encontrado na collection');
        return [];
      }

      List<Evento> eventos = [];
      
      for (var doc in snapshot.docs) {
        print('📄 Documento: ${doc.id}');
        print('📊 Dados: ${doc.data()}');
        
        try {
          // 🔥 CORREÇÃO: Use 'doc' em vez de 'data'
          final data = doc.data() as Map<String, dynamic>;
          
          final user = UserModel(
            uid: data['userId'] ?? '', // 🔥 CORREÇÃO: use 'data'
            email: data['userId'] ?? '',
            nomeCompleto: data['nomeCompleto'] ?? 'Usuário',
            username: data['username'] ?? 'usuario',
            universidade: 'FATEC RP',
            curso: 'ADS',
            telefone: '',
          );
          
          final evento = Evento(
            id: data['id'] ?? 0, // 🔥 CORREÇÃO: use 'data'
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            date: data['date'] != null 
                ? (data['date'] as Timestamp).toDate()
                : DateTime.now(),
            location: data['location'] ?? '', // 🔥 CORREÇÃO: 'location' em vez de '_fieldLocation'
            latitude: data['latitude']?.toDouble(),  // ✅
            longitude: data['longitude']?.toDouble(), // 🔥 CORREÇÃO: faltava vírgula
            imageUrl: data['imageUrl'] ?? '',
            user: user,
            createdAt: data['createdAt'] != null
                ? (data['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
            isLiked: data['isLiked'] ?? false,
            likesCount: data['likesCount'] ?? 0,
            comentarios: [],
          );
          
          eventos.add(evento);
          print('✅ Evento adicionado: ${evento.title}');
        } catch (e) {
          print('❌ Erro ao processar documento ${doc.id}: $e');
        }
      }
      
      print('✅ Total de eventos processados: ${eventos.length}');
      return eventos;
    } catch (e) {
      print('❌ Erro ao obter eventos: $e');
      return [];
    }
  }
}