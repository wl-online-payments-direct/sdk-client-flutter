// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionInput {

 String? get assetUrl; String? get clientApiUrl; String? get clientSessionId; String? get customerId; String? get paymentProductId;
/// Create a copy of SessionInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionInputCopyWith<SessionInput> get copyWith => _$SessionInputCopyWithImpl<SessionInput>(this as SessionInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionInput&&(identical(other.assetUrl, assetUrl) || other.assetUrl == assetUrl)&&(identical(other.clientApiUrl, clientApiUrl) || other.clientApiUrl == clientApiUrl)&&(identical(other.clientSessionId, clientSessionId) || other.clientSessionId == clientSessionId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.paymentProductId, paymentProductId) || other.paymentProductId == paymentProductId));
}


@override
int get hashCode => Object.hash(runtimeType,assetUrl,clientApiUrl,clientSessionId,customerId,paymentProductId);

@override
String toString() {
  return 'SessionInput(assetUrl: $assetUrl, clientApiUrl: $clientApiUrl, clientSessionId: $clientSessionId, customerId: $customerId, paymentProductId: $paymentProductId)';
}


}

/// @nodoc
abstract mixin class $SessionInputCopyWith<$Res>  {
  factory $SessionInputCopyWith(SessionInput value, $Res Function(SessionInput) _then) = _$SessionInputCopyWithImpl;
@useResult
$Res call({
 String? assetUrl, String? clientApiUrl, String? clientSessionId, String? customerId, String? paymentProductId
});




}
/// @nodoc
class _$SessionInputCopyWithImpl<$Res>
    implements $SessionInputCopyWith<$Res> {
  _$SessionInputCopyWithImpl(this._self, this._then);

  final SessionInput _self;
  final $Res Function(SessionInput) _then;

/// Create a copy of SessionInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetUrl = freezed,Object? clientApiUrl = freezed,Object? clientSessionId = freezed,Object? customerId = freezed,Object? paymentProductId = freezed,}) {
  return _then(_self.copyWith(
assetUrl: freezed == assetUrl ? _self.assetUrl : assetUrl // ignore: cast_nullable_to_non_nullable
as String?,clientApiUrl: freezed == clientApiUrl ? _self.clientApiUrl : clientApiUrl // ignore: cast_nullable_to_non_nullable
as String?,clientSessionId: freezed == clientSessionId ? _self.clientSessionId : clientSessionId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,paymentProductId: freezed == paymentProductId ? _self.paymentProductId : paymentProductId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionInput].
extension SessionInputPatterns on SessionInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionInput value)  $default,){
final _that = this;
switch (_that) {
case _SessionInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionInput value)?  $default,){
final _that = this;
switch (_that) {
case _SessionInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? assetUrl,  String? clientApiUrl,  String? clientSessionId,  String? customerId,  String? paymentProductId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionInput() when $default != null:
return $default(_that.assetUrl,_that.clientApiUrl,_that.clientSessionId,_that.customerId,_that.paymentProductId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? assetUrl,  String? clientApiUrl,  String? clientSessionId,  String? customerId,  String? paymentProductId)  $default,) {final _that = this;
switch (_that) {
case _SessionInput():
return $default(_that.assetUrl,_that.clientApiUrl,_that.clientSessionId,_that.customerId,_that.paymentProductId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? assetUrl,  String? clientApiUrl,  String? clientSessionId,  String? customerId,  String? paymentProductId)?  $default,) {final _that = this;
switch (_that) {
case _SessionInput() when $default != null:
return $default(_that.assetUrl,_that.clientApiUrl,_that.clientSessionId,_that.customerId,_that.paymentProductId);case _:
  return null;

}
}

}

/// @nodoc


class _SessionInput implements SessionInput {
  const _SessionInput({this.assetUrl, this.clientApiUrl, this.clientSessionId, this.customerId, this.paymentProductId});
  

@override final  String? assetUrl;
@override final  String? clientApiUrl;
@override final  String? clientSessionId;
@override final  String? customerId;
@override final  String? paymentProductId;

/// Create a copy of SessionInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionInputCopyWith<_SessionInput> get copyWith => __$SessionInputCopyWithImpl<_SessionInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionInput&&(identical(other.assetUrl, assetUrl) || other.assetUrl == assetUrl)&&(identical(other.clientApiUrl, clientApiUrl) || other.clientApiUrl == clientApiUrl)&&(identical(other.clientSessionId, clientSessionId) || other.clientSessionId == clientSessionId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.paymentProductId, paymentProductId) || other.paymentProductId == paymentProductId));
}


@override
int get hashCode => Object.hash(runtimeType,assetUrl,clientApiUrl,clientSessionId,customerId,paymentProductId);

@override
String toString() {
  return 'SessionInput(assetUrl: $assetUrl, clientApiUrl: $clientApiUrl, clientSessionId: $clientSessionId, customerId: $customerId, paymentProductId: $paymentProductId)';
}


}

/// @nodoc
abstract mixin class _$SessionInputCopyWith<$Res> implements $SessionInputCopyWith<$Res> {
  factory _$SessionInputCopyWith(_SessionInput value, $Res Function(_SessionInput) _then) = __$SessionInputCopyWithImpl;
@override @useResult
$Res call({
 String? assetUrl, String? clientApiUrl, String? clientSessionId, String? customerId, String? paymentProductId
});




}
/// @nodoc
class __$SessionInputCopyWithImpl<$Res>
    implements _$SessionInputCopyWith<$Res> {
  __$SessionInputCopyWithImpl(this._self, this._then);

  final _SessionInput _self;
  final $Res Function(_SessionInput) _then;

/// Create a copy of SessionInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetUrl = freezed,Object? clientApiUrl = freezed,Object? clientSessionId = freezed,Object? customerId = freezed,Object? paymentProductId = freezed,}) {
  return _then(_SessionInput(
assetUrl: freezed == assetUrl ? _self.assetUrl : assetUrl // ignore: cast_nullable_to_non_nullable
as String?,clientApiUrl: freezed == clientApiUrl ? _self.clientApiUrl : clientApiUrl // ignore: cast_nullable_to_non_nullable
as String?,clientSessionId: freezed == clientSessionId ? _self.clientSessionId : clientSessionId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,paymentProductId: freezed == paymentProductId ? _self.paymentProductId : paymentProductId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
