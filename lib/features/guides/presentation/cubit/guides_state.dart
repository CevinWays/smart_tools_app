import 'package:equatable/equatable.dart';
import 'package:smart_tools_app/features/guides/domain/entities/guide_entity.dart';

abstract class GuidesState extends Equatable {
  const GuidesState();

  @override
  List<Object> get props => [];
}

class GuidesInitial extends GuidesState {}

class GuidesLoading extends GuidesState {}

class GuidesLoaded extends GuidesState {
  final List<Guide> guides;

  const GuidesLoaded(this.guides);

  @override
  List<Object> get props => [guides];
}

class GuidesError extends GuidesState {
  final String message;

  const GuidesError(this.message);

  @override
  List<Object> get props => [message];
}
