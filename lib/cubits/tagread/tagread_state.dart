// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TagreadState extends Equatable {
  final bool tagread;

  TagreadState({required this.tagread});

  factory TagreadState.initial() {
    return TagreadState(tagread: false);
  }

  @override
  List<Object> get props => [tagread];

  TagreadState copyWith({
    bool? tagread,
  }) {
    return TagreadState(
      tagread: tagread ?? this.tagread,
    );
  }

  @override
  bool get stringify => true;
}
