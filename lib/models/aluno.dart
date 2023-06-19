class Aluno {
  final String alunoId;
  final String nome;
  final String? ra;
  final String? curso;
  final String? fotoUrl;

  Aluno(
      {required this.alunoId,
        required this.nome,
        required this.ra,
        required this.curso,
        required this.fotoUrl});

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
        alunoId: json['id'],
        nome: json['nome'],
        ra: json['ra'],
        curso: json['curso'],
        fotoUrl: json['caminhoFoto']);
  }

  @override
  int get hashCode => alunoId.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}