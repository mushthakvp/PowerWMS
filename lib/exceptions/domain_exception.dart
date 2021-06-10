class DomainException implements Exception {
  final String message;

  const DomainException(this.message);

  @override
  String toString() {
    return message;
  }
}