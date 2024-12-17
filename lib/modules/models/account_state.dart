import 'package:cat_tapper_telegram_web_app/constants/cats_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_state.g.dart';

enum AccountStateLoadStatus {
  initial,
  loading,
  loaded,
}
@JsonSerializable()
class AccountState {
  final AccountStateLoadStatus loadStatus;
  final int coins;
  final CatNumber selectedCat;
  final List<CatNumber> cats;

  const AccountState({
    this.loadStatus = AccountStateLoadStatus.initial,
    this.coins = 0,
    this.selectedCat = CatNumber.zero,
    this.cats = const [CatNumber.zero],
  });

  AccountState copyWith({
    AccountStateLoadStatus? loadStatus,
    int? coins,
    CatNumber? selectedCat,
    List<CatNumber>? cats,
  }) {
    return AccountState(
      loadStatus: loadStatus ?? this.loadStatus,
      coins: coins ?? this.coins,
      selectedCat: selectedCat ?? this.selectedCat,
      cats: cats ?? this.cats,
    );
  }

  factory AccountState.fromJson(Map<String, dynamic> json) =>
      _$AccountStateFromJson(json);

  Map<String, dynamic> toJson() => _$AccountStateToJson(this);
}
