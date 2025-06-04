abstract class DataSource<T> {
  Future<List<T>> getAll();

  Future<T> createOrUpdate(T data);

  Future<void> deleteAll();

  Future<List<T>> searchByKeyWord(String keyWord);
}
