@isTest
private class BookingControllerTest {

    @isTest
    static void testCreateBooking_Success() {
        Account acc = new Account(Name = 'Test Customer');
        insert acc;

        Test.startTest();
        Booking__c b = BookingController.createBooking(
            'Goa Beach Resort', Date.today().addDays(10), Date.today().addDays(13),
            'Deluxe', 18000, acc.Id
        );
        Test.stopTest();

        System.assertNotEquals(null, b.Id);
        System.assertEquals('Pending', b.Status__c);
    }

    @isTest
    static void testCreateBooking_InvalidDates_Throws() {
        Account acc = new Account(Name = 'Test Customer 2');
        insert acc;

        Boolean exceptionThrown = false;
        try {
            BookingController.createBooking(
                'Goa Beach Resort', Date.today().addDays(13), Date.today().addDays(10),
                'Deluxe', 18000, acc.Id
            );
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown);
    }

    @isTest
    static void testGetMyBookings() {
        Account acc = new Account(Name = 'Test Customer 3');
        insert acc;
        insert new Booking__c(Hotel_Name__c = 'Test Hotel', Check_In__c = Date.today(),
                               Check_Out__c = Date.today().addDays(2), Total_Amount__c = 5000,
                               Account__c = acc.Id, Status__c = 'Confirmed');

        Test.startTest();
        List<Booking__c> results = BookingController.getMyBookings(acc.Id);
        Test.stopTest();

        System.assertEquals(1, results.size());
    }
}