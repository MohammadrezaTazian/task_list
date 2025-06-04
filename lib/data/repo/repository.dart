import 'package:flutter/material.dart';
import 'package:task_list/data/source/data_source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> _localDataSource;

  Repository({required DataSource<T> localDataSource})
      : _localDataSource = localDataSource;
  @override
  Future<T> createOrUpdate(data) async {
    await _localDataSource.createOrUpdate(data);
    notifyListeners();
    return data;
  }

  @override
  Future<void> deleteAll() async {
    await _localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<List<T>> getAll() async {
    final result = await _localDataSource.getAll();
    return result.toList();
  }

  @override
  Future<List<T>> searchByKeyWord(String keyWord) async {
    return await _localDataSource.searchByKeyWord(keyWord);
  }
}
