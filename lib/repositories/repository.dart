abstract class Repository<T> {
  Future<void> add(T item);

  Future<List<T>> getAll();

  Future<void> delete(String id);

  Future<void> update(T item);
}
