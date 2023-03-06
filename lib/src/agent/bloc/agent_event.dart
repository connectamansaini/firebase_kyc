part of 'agent_bloc.dart';

abstract class AgentEvent {
  const AgentEvent();
}

class AgentReceived extends AgentEvent {
  AgentReceived(this.agent);

  final Agent agent;
}

class AgentCreated extends AgentEvent {
  AgentCreated(this.agent);

  final Agent agent;
}
