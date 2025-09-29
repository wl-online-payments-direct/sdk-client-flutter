// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Result<T> {

 T? get data; ErrorResponse? get errorResponse; NativeException? get nativeException;
/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultCopyWith<T, Result<T>> get copyWith => _$ResultCopyWithImpl<T, Result<T>>(this as Result<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Result<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.errorResponse, errorResponse) || other.errorResponse == errorResponse)&&(identical(other.nativeException, nativeException) || other.nativeException == nativeException));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),errorResponse,nativeException);

@override
String toString() {
  return 'Result<$T>(data: $data, errorResponse: $errorResponse, nativeException: $nativeException)';
}


}

/// @nodoc
abstract mixin class $ResultCopyWith<T,$Res>  {
  factory $ResultCopyWith(Result<T> value, $Res Function(Result<T>) _then) = _$ResultCopyWithImpl;
@useResult
$Res call({
 T? data, ErrorResponse? errorResponse, NativeException? nativeException
});




}
/// @nodoc
class _$ResultCopyWithImpl<T,$Res>
    implements $ResultCopyWith<T, $Res> {
  _$ResultCopyWithImpl(this._self, this._then);

  final Result<T> _self;
  final $Res Function(Result<T>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? errorResponse = freezed,Object? nativeException = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,errorResponse: freezed == errorResponse ? _self.errorResponse : errorResponse // ignore: cast_nullable_to_non_nullable
as ErrorResponse?,nativeException: freezed == nativeException ? _self.nativeException : nativeException // ignore: cast_nullable_to_non_nullable
as NativeException?,
  ));
}

}


/// Adds pattern-matching-related methods to [Result].
extension ResultPatterns<T> on Result<T> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Result<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Result() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Result<T> value)  $default,){
final _that = this;
switch (_that) {
case _Result():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Result<T> value)?  $default,){
final _that = this;
switch (_that) {
case _Result() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( T? data,  ErrorResponse? errorResponse,  NativeException? nativeException)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Result() when $default != null:
return $default(_that.data,_that.errorResponse,_that.nativeException);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( T? data,  ErrorResponse? errorResponse,  NativeException? nativeException)  $default,) {final _that = this;
switch (_that) {
case _Result():
return $default(_that.data,_that.errorResponse,_that.nativeException);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( T? data,  ErrorResponse? errorResponse,  NativeException? nativeException)?  $default,) {final _that = this;
switch (_that) {
case _Result() when $default != null:
return $default(_that.data,_that.errorResponse,_that.nativeException);case _:
  return null;

}
}

}

/// @nodoc


class _Result<T> implements Result<T> {
   _Result({this.data, this.errorResponse, this.nativeException});
  

@override final  T? data;
@override final  ErrorResponse? errorResponse;
@override final  NativeException? nativeException;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultCopyWith<T, _Result<T>> get copyWith => __$ResultCopyWithImpl<T, _Result<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Result<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.errorResponse, errorResponse) || other.errorResponse == errorResponse)&&(identical(other.nativeException, nativeException) || other.nativeException == nativeException));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),errorResponse,nativeException);

@override
String toString() {
  return 'Result<$T>(data: $data, errorResponse: $errorResponse, nativeException: $nativeException)';
}


}

/// @nodoc
abstract mixin class _$ResultCopyWith<T,$Res> implements $ResultCopyWith<T, $Res> {
  factory _$ResultCopyWith(_Result<T> value, $Res Function(_Result<T>) _then) = __$ResultCopyWithImpl;
@override @useResult
$Res call({
 T? data, ErrorResponse? errorResponse, NativeException? nativeException
});




}
/// @nodoc
class __$ResultCopyWithImpl<T,$Res>
    implements _$ResultCopyWith<T, $Res> {
  __$ResultCopyWithImpl(this._self, this._then);

  final _Result<T> _self;
  final $Res Function(_Result<T>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? errorResponse = freezed,Object? nativeException = freezed,}) {
  return _then(_Result<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,errorResponse: freezed == errorResponse ? _self.errorResponse : errorResponse // ignore: cast_nullable_to_non_nullable
as ErrorResponse?,nativeException: freezed == nativeException ? _self.nativeException : nativeException // ignore: cast_nullable_to_non_nullable
as NativeException?,
  ));
}


}

// dart format on
