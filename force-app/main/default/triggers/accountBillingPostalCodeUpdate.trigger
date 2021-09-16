trigger accountBillingPostalCodeUpdate on Account (after insert, after update) {
    accountBillingPostalCodeUpdateHelper.accBillPsCodeUpdate(Trigger.New);
}