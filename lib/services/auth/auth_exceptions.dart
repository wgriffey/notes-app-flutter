//Login Exceptions
class InvalidLoginCredentialsException implements Exception {}

//Register Exceptions
class EmailAlreadyInUseException implements Exception {}

class WeakPasswordException implements Exception {}

class InvalidEmailException implements Exception {}

//Generic Exceptions
class GenericAuthException implements Exception {}

class UserNotFoundException implements Exception {}

class UserNotLoggedInException implements Exception {}
