import 'package:flutter/material.dart';

class ErrorExplainer {
  //TODO: Add more error codes to the list
  Map<int, String> errorMessages = {
    0: "Houve um problema de conexão",
    401: "Senha ou usuário incorretos",
    500: "Houve um erro"
  };

  void showErrorSnackbar({int code, Function callback, BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(days: 365),
      action: SnackBarAction(
        label: "Tentar novamente",
        onPressed: () {
          callback();
        },
      ),
      content: Text(errorMessages[code]),
    ));
  }
}
