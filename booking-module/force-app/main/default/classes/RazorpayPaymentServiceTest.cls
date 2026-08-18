@isTest
private class RazorpayPaymentServiceTest {

    @isTest
    static void testCreateOrder_Success() {
        Account acc = new Account(Name = 'Test Customer');
        insert acc;
        Booking__c b = new Booking__c(Hotel_Name__c = 'Goa Resort', Check_In__c = Date.today(),
                                       Check_Out__c = Date.today().addDays(2),
                                       Total_Amount__c = 18000, Account__c = acc.Id);
        insert b;

        Test.setMock(HttpCalloutMock.class, new RazorpayCalloutMock());
        Test.startTest();
        Payment__c result = RazorpayPaymentService.createOrder(b.Id, 18000);
        Test.stopTest();

        System.assertEquals('Success', result.Status__c);
        Booking__c updated = [SELECT Status__c FROM Booking__c WHERE Id = :b.Id];
        System.assertEquals('Confirmed', updated.Status__c);
    }
}