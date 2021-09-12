// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/data/dataSources/data_source_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/models/local_message.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/view_models/base_model.dart';
// ignore: import_of_legacy_library_into_null_safe


class ChatsViewModel extends BaseViewModel{
  IDatasource _datasource;

  ChatsViewModel(this._datasource) : super(_datasource);

   Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
  
}