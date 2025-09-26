// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionContainer {
  Session? get session => throw _privateConstructorUsedError;
  PaymentContext get paymentContext => throw _privateConstructorUsedError;

  /// Create a copy of SessionContainer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionContainerCopyWith<SessionContainer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionContainerCopyWith<$Res> {
  factory $SessionContainerCopyWith(
          SessionContainer value, $Res Function(SessionContainer) then) =
      _$SessionContainerCopyWithImpl<$Res, SessionContainer>;
  @useResult
  $Res call({Session? session, PaymentContext paymentContext});
}

/// @nodoc
class _$SessionContainerCopyWithImpl<$Res, $Val extends SessionContainer>
    implements $SessionContainerCopyWith<$Res> {
  _$SessionContainerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionContainer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = freezed,
    Object? paymentContext = null,
  }) {
    return _then(_value.copyWith(
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session?,
      paymentContext: null == paymentContext
          ? _value.paymentContext
          : paymentContext // ignore: cast_nullable_to_non_nullable
              as PaymentContext,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionContainerImplCopyWith<$Res>
    implements $SessionContainerCopyWith<$Res> {
  factory _$$SessionContainerImplCopyWith(_$SessionContainerImpl value,
          $Res Function(_$SessionContainerImpl) then) =
      __$$SessionContainerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Session? session, PaymentContext paymentContext});
}

/// @nodoc
class __$$SessionContainerImplCopyWithImpl<$Res>
    extends _$SessionContainerCopyWithImpl<$Res, _$SessionContainerImpl>
    implements _$$SessionContainerImplCopyWith<$Res> {
  __$$SessionContainerImplCopyWithImpl(_$SessionContainerImpl _value,
      $Res Function(_$SessionContainerImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionContainer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = freezed,
    Object? paymentContext = null,
  }) {
    return _then(_$SessionContainerImpl(
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session?,
      paymentContext: null == paymentContext
          ? _value.paymentContext
          : paymentContext // ignore: cast_nullable_to_non_nullable
              as PaymentContext,
    ));
  }
}

/// @nodoc

class _$SessionContainerImpl implements _SessionContainer {
  const _$SessionContainerImpl({this.session, required this.paymentContext});

  @override
  final Session? session;
  @override
  final PaymentContext paymentContext;

  @override
  String toString() {
    return 'SessionContainer(session: $session, paymentContext: $paymentContext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionContainerImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.paymentContext, paymentContext) ||
                other.paymentContext == paymentContext));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session, paymentContext);

  /// Create a copy of SessionContainer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionContainerImplCopyWith<_$SessionContainerImpl> get copyWith =>
      __$$SessionContainerImplCopyWithImpl<_$SessionContainerImpl>(
          this, _$identity);
}

abstract class _SessionContainer implements SessionContainer {
  const factory _SessionContainer(
      {final Session? session,
      required final PaymentContext paymentContext}) = _$SessionContainerImpl;

  @override
  Session? get session;
  @override
  PaymentContext get paymentContext;

  /// Create a copy of SessionContainer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionContainerImplCopyWith<_$SessionContainerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
