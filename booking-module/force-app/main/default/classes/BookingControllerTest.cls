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

    @isTest
    static void testGetCurrentUserAccountId() {
        Account acc = new Account(Name = 'Test Customer 4');
        insert acc;
        Contact con = new Contact(FirstName = 'Rahul', LastName = 'Sharma',
                                   AccountId = acc.Id, Email = 'rahul.test@travelstay-dev.com');
        insert con;

        // User is a "setup object" — must be inserted inside System.runAs to avoid
        // a MIXED_DML_OPERATION error when combined with Account/Contact DML above.
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Rahul',
            LastName = 'Sharma',
            Email = 'rahul.test@travelstay-dev.com',
            Username = 'rahul.test.' + DateTime.now().getTime() + '@travelstay-dev.com',
            Alias = 'rshar',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_IN',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            ContactId = con.Id
        );
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert testUser;
        }

        Id result;
        System.runAs(testUser) {
            Test.startTest();
            result = BookingController.getCurrentUserAccountId();
            Test.stopTest();
        }

        System.assertEquals(acc.Id, result);
    }
}