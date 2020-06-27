abstract class Repository<T> {
  /// ***
  /// *** CAUTION ***
  ///
  /// Exercise care when calling Repository.save()
  ///
  /// Ensure that this save() is what you want to
  ///
  /// access.  Repository.save() should only be called
  ///
  /// from an instance of RepositoryService.
  ///
  /// ***
  ///
  Future<void> save(T newObject);

  T getAtIndex(int index);

  T getByName(String name);

  /// ***
  /// *** CAUTION ***
  ///
  /// Exercise care when calling Repository.delete()
  ///
  /// Ensure that this delete() is what you want to
  ///
  /// access.  Repository.delete() should only be called
  ///
  /// from an instance of RepositoryService.
  ///
  /// ***
  ///
  Future<void> delete(T objectToDelete);

  Future deleteAll();

  List<T> getAll();

  int size();

  Future deleteBox();
}
