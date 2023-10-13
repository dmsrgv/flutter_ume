import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'analytics_sender.freezed.dart';

@freezed
class AnalyticsSenderEvent with _$AnalyticsSenderEvent {
  const AnalyticsSenderEvent._();

  const factory AnalyticsSenderEvent.sendEvent(
      {required String tag,
      Map<String, dynamic>? params}) = $AnalyticsSenderEvent$SendEvent;

  const factory AnalyticsSenderEvent.sendCurrentScreen({
    required String screenName,
  }) = $AnalyticsSenderEvent$SendCurrentScreen;

  const factory AnalyticsSenderEvent.reportUserProfileCustomBoolean({
    required String key,
    required Object value,
  }) = $AnalyticsSenderEvent$ReportUserProfileCustomBoolean;

  const factory AnalyticsSenderEvent.reportUserProfileCustomNumber({
    required String key,
    required Object value,
  }) = $AnalyticsSenderEvent$ReportUserProfileCustomNumber;

  const factory AnalyticsSenderEvent.reportUserProfileCustomString({
    required String key,
    required Object value,
  }) = $AnalyticsSenderEvent$ReportUserProfileCustomString;

  const factory AnalyticsSenderEvent.showProductCardEvent({
    required ECommerceProduct product,
  }) = $AnalyticsSenderEvent$ShowProductCardEvent;

  const factory AnalyticsSenderEvent.showProductDetailsEvent({
    required ECommerceProduct product,
  }) = $AnalyticsSenderEvent$ShowProductDetailsEvent;

  const factory AnalyticsSenderEvent.addCartItemEvent({
    required ECommerceCartItem cartItem,
  }) = $AnalyticsSenderEvent$AddCartItemEvent;

  const factory AnalyticsSenderEvent.removeCartItemEvent({
    required ECommerceCartItem cartItem,
  }) = $AnalyticsSenderEvent$RemoveCartItemEvent;

  const factory AnalyticsSenderEvent.beginCheckoutEvent({
    required ECommerceOrder cart,
  }) = $AnalyticsSenderEvent$BeginCheckoutEvent;

  const factory AnalyticsSenderEvent.purchaseEvent({
    required ECommerceOrder cart,
  }) = $AnalyticsSenderEvent$PurchaseEvent;

  const factory AnalyticsSenderEvent.reportAppOpen({
    required String url,
  }) = $AnalyticsSenderEvent$ReportAppOpen;

  const factory AnalyticsSenderEvent.reportRevenue({
    required Revenue revenue,
  }) = $AnalyticsSenderEvent$reportRevenue;
}

abstract class AnalyticsSender {
  @protected
  Future<void> handleEvent(AnalyticsSenderEvent event);
}
