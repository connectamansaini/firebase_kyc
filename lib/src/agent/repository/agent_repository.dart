import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_kyc/src/agent/models/agent.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';

class AgentRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> createAgent(Agent agent) async {
    try {
      await db.collection('agents').doc(agent.id).set(agent.toJson());
    } on SocketException {
      throw Failure.network();
    } catch (e) {
      throw Failure.server(e.toString());
    }
  }

  Future<Agent> getAgent(String agentId) async {
    try {
      final snapshot = await db.collection('agents').doc(agentId).get();
      if (snapshot.exists) {
        final agent = Agent.fromJson(snapshot.data()!);
        return agent;
      }
      return const Agent();
    } on SocketException {
      throw Failure.network();
    } catch (e) {
      throw Failure.server(e.toString());
    }
  }

  
}
