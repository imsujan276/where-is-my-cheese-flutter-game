import 'package:maze/maze.dart';
import 'package:equatable/equatable.dart';

class Level extends Equatable {
  Level({required this.level,required this.row, required this.column, required this.checkpoints});
  final int level;
  final int row;
  final int column;
  final List<MazeItem> checkpoints;

  @override
  List<Object> get props => [level,row, column, checkpoints];
}
