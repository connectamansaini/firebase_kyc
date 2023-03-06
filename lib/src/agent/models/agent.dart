import 'package:json_annotation/json_annotation.dart';

part 'agent.g.dart';

@JsonSerializable()
class Agent {
  const Agent({this.id = '', this.email = ''});

  factory Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);
  Map<String, dynamic> toJson() => _$AgentToJson(this);

  final String id;
  final String email;

  Agent copyWith({
    String? id,
    String? email,
  }) {
    return Agent(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }
}
