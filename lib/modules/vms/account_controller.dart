import 'dart:convert';

import 'package:cat_tapper_telegram_web_app/constants/cats_list.dart';
import 'package:cat_tapper_telegram_web_app/constants/storage.dart';
import 'package:cat_tapper_telegram_web_app/modules/models/account_state.dart';
import 'package:cat_tapper_telegram_web_app/services/storage.dart';
import 'package:rxdart/rxdart.dart';

class AccountController {
  final Storage storage;
  AccountController({required this.storage});

  final BehaviorSubject<AccountState> _streamController =
      BehaviorSubject.seeded(const AccountState());

  Stream<AccountState> get stream => _streamController.stream;

  AccountState get state => _streamController.value;

  Future<void> init() async {
    final savedAccount = await storage.getData(StorageKeys.account);
    if (savedAccount != null) {
      _streamController.add(AccountState.fromJson(jsonDecode(savedAccount)));
    } else {
      _streamController
          .add(state.copyWith(loadStatus: AccountStateLoadStatus.loaded));
    }
  }

  Future<void> setCat(CatNumber cat) async {
    _streamController.add(state.copyWith(selectedCat: cat));
    await saveAccount();
  }

  Future<void> tapCoin([int amount = 1]) async {
    _streamController.add(state.copyWith(coins: state.coins + amount));
  }

  Future<void> saveAccount() async {
    final account = state.toJson();
    await storage.saveData(StorageKeys.account, jsonEncode(account));
  }

  Future<void> buyCat(CatNumber cat) async {
    _streamController.add(state.copyWith(
        cats: [...state.cats, cat], coins: state.coins - catsList[cat]!));
    await saveAccount();
    setCat(cat);
  }

  void dispose() {
    _streamController.close();
  }
}
