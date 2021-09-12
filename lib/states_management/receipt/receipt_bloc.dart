//@dart = 2.9
import 'dart:async';

import 'package:bloc/bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IReceiptService _receiptService;
  StreamSubscription _subscription;

  ReceiptBloc(this._receiptService) : super(ReceiptState.initial());

  @override
  Stream<ReceiptState> mapEventToState(ReceiptEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _receiptService
          .receipts(event.user)
          .listen((receipt) => add(_ReceiptReceived(receipt)));
    }

    if (event is _ReceiptReceived) {
      yield ReceiptState.received(event.receipt);
    }
    if (event is ReceiptSent) {
      await _receiptService.send(event.receipt);
      yield ReceiptState.sent(event.receipt);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _receiptService.dispose();
    return super.close();
  }
}
