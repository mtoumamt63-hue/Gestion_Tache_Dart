abstract class Repository<T> {
  Future<void> add(T item);

  Future<List<T>> getAll();

  Future<void> update(T item);

  Future<void> delete(String id);
}
