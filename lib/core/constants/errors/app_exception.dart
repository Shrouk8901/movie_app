abstract class AppException {
  final String message;
  const AppException(this.message);
}

class APIException extends AppException {
  const APIException(super.message);
}

class SharedPrefException extends AppException {
  const SharedPrefException(super.message);
}
