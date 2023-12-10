import 'package:book_my_spot_frontend/src/models/team.dart';
import 'package:book_my_spot_frontend/src/state/teams/team_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AmenityEvent {
  @JsonKey(name: 'id')
  late int id;
  @JsonKey(name: 'amenity_id')
  late int amenityId;
  @JsonKey(name: "name")
  late String name;
  @JsonKey(name: "time_of_occourence_start")
  late String timeOfOccourenceStart;
  @JsonKey(name: "time_of_occourence_end")
  late String timeOfOccourenceEnd;
  List<Team> teams = [];

  Future<AmenityEvent> fromJson(var data, WidgetRef ref) async {
    AmenityEvent e = AmenityEvent();
    e.id = data["id"];
    e.amenityId = data["amenity_id"];
    e.name = data['name'];
    e.timeOfOccourenceStart = data["time_of_occourence_start"];
    e.timeOfOccourenceEnd = data["time_of_occourence_end"];
    for (int i = 0; i < data["team"].length; i++) {
      Team? t = await ref
          .watch(teamsProvider.notifier)
          .fetchTeamFromServer(data["team"][i], ref);
      if (t != null) {
        e.teams.add(t);
      }
    }
    return e;
  }
}
