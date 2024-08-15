extension RemoveAll on String {
  String removeAll(Iterable<String> value) => value.fold(
        this,
        (result, pattern) => result.replaceAll(
          pattern,
          '',
        ),
      );
}
