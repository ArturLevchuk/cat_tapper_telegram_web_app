// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountState _$AccountStateFromJson(Map<String, dynamic> json) => AccountState(
      loadStatus: $enumDecodeNullable(
              _$AccountStateLoadStatusEnumMap, json['loadStatus']) ??
          AccountStateLoadStatus.initial,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      selectedCat:
          $enumDecodeNullable(_$CatNumberEnumMap, json['selectedCat']) ??
              CatNumber.zero,
      cats: (json['cats'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CatNumberEnumMap, e))
              .toList() ??
          const [CatNumber.zero],
    );

Map<String, dynamic> _$AccountStateToJson(AccountState instance) =>
    <String, dynamic>{
      'loadStatus': _$AccountStateLoadStatusEnumMap[instance.loadStatus]!,
      'coins': instance.coins,
      'selectedCat': _$CatNumberEnumMap[instance.selectedCat]!,
      'cats': instance.cats.map((e) => _$CatNumberEnumMap[e]!).toList(),
    };

const _$AccountStateLoadStatusEnumMap = {
  AccountStateLoadStatus.initial: 'initial',
  AccountStateLoadStatus.loading: 'loading',
  AccountStateLoadStatus.loaded: 'loaded',
};

const _$CatNumberEnumMap = {
  CatNumber.zero: 'zero',
  CatNumber.one: 'one',
  CatNumber.two: 'two',
  CatNumber.three: 'three',
  CatNumber.four: 'four',
  CatNumber.five: 'five',
  CatNumber.six: 'six',
};
