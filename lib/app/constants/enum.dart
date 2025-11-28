enum PricingKey {
  mainPrice,
  rentPerMonth,
  roomRent,
  maintenance,
  pricePerSqft,
  securityDeposit,
  brokerCommission,
  mealCharges,
  electricityCharges,
  noticePeriod,
  lockInPeriod,
}

extension PricingKeyLabel on PricingKey {
  String get label {
    switch (this) {
      case PricingKey.mainPrice:
        return "Main Price";
      case PricingKey.rentPerMonth:
        return "Rent / Month";
      case PricingKey.roomRent:
        return "Room Rent";
      case PricingKey.maintenance:
        return "Maintenance";
      case PricingKey.pricePerSqft:
        return "Price per Sqft";
      case PricingKey.securityDeposit:
        return "Security Deposit";
      case PricingKey.brokerCommission:
        return "Broker Commission";
      case PricingKey.mealCharges:
        return "Meal Charges";
      case PricingKey.electricityCharges:
        return "Electricity Charges";
      case PricingKey.noticePeriod:
        return "Notice Period";
      case PricingKey.lockInPeriod:
        return "Lock-in Period";
    }
  }
}
