part of 'agent_bloc.dart';

class AgentState {
  AgentState({
    this.createAgentStatus = const StatusInitial(),
    this.getAgentStatus = const StatusInitial(),
    this.agent = const Agent(),
  });

  final Status createAgentStatus;
  final Status getAgentStatus;
  final Agent agent;

  AgentState copyWith({
    Status? createAgentStatus,
    Status? getAgentStatus,
    Agent? agent,
  }) {
    return AgentState(
      createAgentStatus: createAgentStatus ?? this.createAgentStatus,
      getAgentStatus: getAgentStatus ?? this.getAgentStatus,
      agent: agent ?? this.agent,
    );
  }
}
