import 'package:blank_street/models/error_data_model.dart';
import 'package:dartz/dartz.dart';

typedef ApiServiceOutput<T> = Future<Either<ErrorDataModel, T>>;
