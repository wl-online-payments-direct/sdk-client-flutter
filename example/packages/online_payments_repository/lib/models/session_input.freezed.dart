// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionInput {
  String? get assetUrl => throw _privateConstructorUsedError;
  String? get clientApiUrl => throw _privateConstructorUsedError;
  String? get clientSessionId => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  String? get paymentProductId => throw _privateConstructorUsedError;

  /// Create a copy of SessionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionInputCopyWith<SessionInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionInputCopyWith<$Res> {
  factory $SessionInputCopyWith(
          SessionInput value, $Res Function(SessionInput) then) =
      _$SessionInputCopyWithImpl<$Res, SessionInput>;
  @useResult
  $Res call(
      {String? assetUrl,
      String? clientApiUrl,
      String? clientSessionId,
      String? customerId,
      String? paymentProductId});
}

/// @nodoc
class _$SessionInputCopyWithImpl<$Res, $Val extends SessionInput>
    implements $SessionInputCopyWith<$Res> {
  _$SessionInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetUrl = freezed,
    Object? clientApiUrl = freezed,
    Object? clientSessionId = freezed,
    Object? customerId = freezed,
    Object? paymentProductId = freezed,
  }) {
    return _then(_value.copyWith(
      assetUrl: freezed == assetUrl
          ? _value.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      clientApiUrl: freezed == clientApiUrl
          ? _value.clientApiUrl
          : clientApiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      clientSessionId: freezed == clientSessionId
          ? _value.clientSessionId
          : clientSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProductId: freezed == paymentProductId
          ? _value.paymentProductId
          : paymentProductId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionInputImplCopyWith<$Res>
    implements $SessionInputCopyWith<$Res> {
  factory _$$SessionInputImplCopyWith(
          _$SessionInputImpl value, $Res Function(_$SessionInputImpl) then) =
      __$$SessionInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? assetUrl,
      String? clientApiUrl,
      String? clientSessionId,
      String? customerId,
      String? paymentProductId});
}

/// @nodoc
class __$$SessionInputImplCopyWithImpl<$Res>
    extends _$SessionInputCopyWithImpl<$Res, _$SessionInputImpl>
    implements _$$SessionInputImplCopyWith<$Res> {
  __$$SessionInputImplCopyWithImpl(
      _$SessionInputImpl _value, $Res Function(_$SessionInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetUrl = freezed,
    Object? clientApiUrl = freezed,
    Object? clientSessionId = freezed,
    Object? customerId = freezed,
    Object? paymentProductId = freezed,
  }) {
    return _then(_$SessionInputImpl(
      assetUrl: freezed == assetUrl
          ? _value.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      clientApiUrl: freezed == clientApiUrl
          ? _value.clientApiUrl
          : clientApiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      clientSessionId: freezed == clientSessionId
          ? _value.clientSessionId
          : clientSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProductId: freezed == paymentProductId
          ? _value.paymentProductId
          : paymentProductId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SessionInputImpl implements _SessionInput {
  const _$SessionInputImpl(
      {this.assetUrl,
      this.clientApiUrl,
      this.clientSessionId,
      this.customerId,
      this.paymentProductId});

  @override
  final String? assetUrl;
  @override
  final String? clientApiUrl;
  @override
  final String? clientSessionId;
  @override
  final String? customerId;
  @override
  final String? paymentProductId;

  @override
  String toString() {
    return 'SessionInput(assetUrl: $assetUrl, clientApiUrl: $clientApiUrl, clientSessionId: $clientSessionId, customerId: $customerId, paymentProductId: $paymentProductId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionInputImpl &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.clientApiUrl, clientApiUrl) ||
                other.clientApiUrl == clientApiUrl) &&
            (identical(other.clientSessionId, clientSessionId) ||
                other.clientSessionId == clientSessionId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.paymentProductId, paymentProductId) ||
                other.paymentProductId == paymentProductId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, assetUrl, clientApiUrl,
      clientSessionId, customerId, paymentProductId);

  /// Create a copy of SessionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionInputImplCopyWith<_$SessionInputImpl> get copyWith =>
      __$$SessionInputImplCopyWithImpl<_$SessionInputImpl>(this, _$identity);
}

abstract class _SessionInput implements SessionInput {
  const factory _SessionInput(
      {final String? assetUrl,
      final String? clientApiUrl,
      final String? clientSessionId,
      final String? customerId,
      final String? paymentProductId}) = _$SessionInputImpl;

  @override
  String? get assetUrl;
  @override
  String? get clientApiUrl;
  @override
  String? get clientSessionId;
  @override
  String? get customerId;
  @override
  String? get paymentProductId;

  /// Create a copy of SessionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionInputImplCopyWith<_$SessionInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
