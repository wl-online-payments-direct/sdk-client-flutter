// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Result<T> {
  T? get data => throw _privateConstructorUsedError;
  ErrorResponse? get errorResponse => throw _privateConstructorUsedError;
  NativeException? get nativeException => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResultCopyWith<T, Result<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCopyWith<T, $Res> {
  factory $ResultCopyWith(Result<T> value, $Res Function(Result<T>) then) =
      _$ResultCopyWithImpl<T, $Res, Result<T>>;
  @useResult
  $Res call(
      {T? data,
      ErrorResponse? errorResponse,
      NativeException? nativeException});
}

/// @nodoc
class _$ResultCopyWithImpl<T, $Res, $Val extends Result<T>>
    implements $ResultCopyWith<T, $Res> {
  _$ResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? errorResponse = freezed,
    Object? nativeException = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      errorResponse: freezed == errorResponse
          ? _value.errorResponse
          : errorResponse // ignore: cast_nullable_to_non_nullable
              as ErrorResponse?,
      nativeException: freezed == nativeException
          ? _value.nativeException
          : nativeException // ignore: cast_nullable_to_non_nullable
              as NativeException?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResultImplCopyWith<T, $Res>
    implements $ResultCopyWith<T, $Res> {
  factory _$$ResultImplCopyWith(
          _$ResultImpl<T> value, $Res Function(_$ResultImpl<T>) then) =
      __$$ResultImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {T? data,
      ErrorResponse? errorResponse,
      NativeException? nativeException});
}

/// @nodoc
class __$$ResultImplCopyWithImpl<T, $Res>
    extends _$ResultCopyWithImpl<T, $Res, _$ResultImpl<T>>
    implements _$$ResultImplCopyWith<T, $Res> {
  __$$ResultImplCopyWithImpl(
      _$ResultImpl<T> _value, $Res Function(_$ResultImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? errorResponse = freezed,
    Object? nativeException = freezed,
  }) {
    return _then(_$ResultImpl<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      errorResponse: freezed == errorResponse
          ? _value.errorResponse
          : errorResponse // ignore: cast_nullable_to_non_nullable
              as ErrorResponse?,
      nativeException: freezed == nativeException
          ? _value.nativeException
          : nativeException // ignore: cast_nullable_to_non_nullable
              as NativeException?,
    ));
  }
}

/// @nodoc

class _$ResultImpl<T> implements _Result<T> {
  _$ResultImpl({this.data, this.errorResponse, this.nativeException});

  @override
  final T? data;
  @override
  final ErrorResponse? errorResponse;
  @override
  final NativeException? nativeException;

  @override
  String toString() {
    return 'Result<$T>(data: $data, errorResponse: $errorResponse, nativeException: $nativeException)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.errorResponse, errorResponse) ||
                other.errorResponse == errorResponse) &&
            (identical(other.nativeException, nativeException) ||
                other.nativeException == nativeException));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(data),
      errorResponse,
      nativeException);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultImplCopyWith<T, _$ResultImpl<T>> get copyWith =>
      __$$ResultImplCopyWithImpl<T, _$ResultImpl<T>>(this, _$identity);
}

abstract class _Result<T> implements Result<T> {
  factory _Result(
      {final T? data,
      final ErrorResponse? errorResponse,
      final NativeException? nativeException}) = _$ResultImpl<T>;

  @override
  T? get data;
  @override
  ErrorResponse? get errorResponse;
  @override
  NativeException? get nativeException;
  @override
  @JsonKey(ignore: true)
  _$$ResultImplCopyWith<T, _$ResultImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
