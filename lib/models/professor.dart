class Professor {
  final String id;
  final String nome;

  Professor({required this.id, required this.nome});

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: json['id'],
      nome: json['nome'],
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}