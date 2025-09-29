// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionContainer {

 Session? get session; PaymentContext get paymentContext;
/// Create a copy of SessionContainer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionContainerCopyWith<SessionContainer> get copyWith => _$SessionContainerCopyWithImpl<SessionContainer>(this as SessionContainer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionContainer&&(identical(other.session, session) || other.session == session)&&(identical(other.paymentContext, paymentContext) || other.paymentContext == paymentContext));
}


@override
int get hashCode => Object.hash(runtimeType,session,paymentContext);

@override
String toString() {
  return 'SessionContainer(session: $session, paymentContext: $paymentContext)';
}


}

/// @nodoc
abstract mixin class $SessionContainerCopyWith<$Res>  {
  factory $SessionContainerCopyWith(SessionContainer value, $Res Function(SessionContainer) _then) = _$SessionContainerCopyWithImpl;
@useResult
$Res call({
 Session? session, PaymentContext paymentContext
});




}
/// @nodoc
class _$SessionContainerCopyWithImpl<$Res>
    implements $SessionContainerCopyWith<$Res> {
  _$SessionContainerCopyWithImpl(this._self, this._then);

  final SessionContainer _self;
  final $Res Function(SessionContainer) _then;

/// Create a copy of SessionContainer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = freezed,Object? paymentContext = null,}) {
  return _then(_self.copyWith(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,paymentContext: null == paymentContext ? _self.paymentContext : paymentContext // ignore: cast_nullable_to_non_nullable
as PaymentContext,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionContainer].
extension SessionContainerPatterns on SessionContainer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionContainer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionContainer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionContainer value)  $default,){
final _that = this;
switch (_that) {
case _SessionContainer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionContainer value)?  $default,){
final _that = this;
switch (_that) {
case _SessionContainer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Session? session,  PaymentContext paymentContext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionContainer() when $default != null:
return $default(_that.session,_that.paymentContext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Session? session,  PaymentContext paymentContext)  $default,) {final _that = this;
switch (_that) {
case _SessionContainer():
return $default(_that.session,_that.paymentContext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Session? session,  PaymentContext paymentContext)?  $default,) {final _that = this;
switch (_that) {
case _SessionContainer() when $default != null:
return $default(_that.session,_that.paymentContext);case _:
  return null;

}
}

}

/// @nodoc


class _SessionContainer implements SessionContainer {
  const _SessionContainer({this.session, required this.paymentContext});
  

@override final  Session? session;
@override final  PaymentContext paymentContext;

/// Create a copy of SessionContainer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionContainerCopyWith<_SessionContainer> get copyWith => __$SessionContainerCopyWithImpl<_SessionContainer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionContainer&&(identical(other.session, session) || other.session == session)&&(identical(other.paymentContext, paymentContext) || other.paymentContext == paymentContext));
}


@override
int get hashCode => Object.hash(runtimeType,session,paymentContext);

@override
String toString() {
  return 'SessionContainer(session: $session, paymentContext: $paymentContext)';
}


}

/// @nodoc
abstract mixin class _$SessionContainerCopyWith<$Res> implements $SessionContainerCopyWith<$Res> {
  factory _$SessionContainerCopyWith(_SessionContainer value, $Res Function(_SessionContainer) _then) = __$SessionContainerCopyWithImpl;
@override @useResult
$Res call({
 Session? session, PaymentContext paymentContext
});




}
/// @nodoc
class __$SessionContainerCopyWithImpl<$Res>
    implements _$SessionContainerCopyWith<$Res> {
  __$SessionContainerCopyWithImpl(this._self, this._then);

  final _SessionContainer _self;
  final $Res Function(_SessionContainer) _then;

/// Create a copy of SessionContainer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = freezed,Object? paymentContext = null,}) {
  return _then(_SessionContainer(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,paymentContext: null == paymentContext ? _self.paymentContext : paymentContext // ignore: cast_nullable_to_non_nullable
as PaymentContext,
  ));
}


}

// dart format on
