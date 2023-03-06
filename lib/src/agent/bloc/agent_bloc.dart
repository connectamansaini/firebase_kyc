import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_kyc/src/agent/models/agent.dart';
import 'package:firebase_kyc/src/agent/repository/agent_repository.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';

part 'agent_event.dart';
part 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  AgentBloc(this.agentRepository) : super(AgentState()) {
    on<AgentReceived>(_onAgentReceived);
    on<AgentCreated>(_onAgentCreated);
  }
  final AgentRepository agentRepository;
  void _onAgentReceived(
    AgentReceived event,
    Emitter<AgentState> emit,
  ) {
    emit(state.copyWith(agent: event.agent));
  }

  Future<void> _onAgentCreated(
    AgentCreated event,
    Emitter<AgentState> emit,
  ) async {
    try {
      emit(state.copyWith(createAgentStatus: Status.loading()));

      await agentRepository.createAgent(event.agent);

      emit(state.copyWith(createAgentStatus: Status.success()));
    } on Failure catch (f) {
      emit(state.copyWith(createAgentStatus: Status.failure(f)));
    }
  }
}
