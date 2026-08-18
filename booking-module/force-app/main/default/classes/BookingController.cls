public with sharing class BookingController {

    @AuraEnabled
    public static Booking__c createBooking(String hotelName, Date checkIn, Date checkOut,
                                            String roomType, Decimal totalAmount, Id accountId) {
        if (checkOut <= checkIn) {
            throw new AuraHandledException('Check-out date must be after check-in date.');
        }
        Booking__c b = new Booking__c(
            Hotel_Name__c = hotelName,
            Check_In__c = checkIn,
            Check_Out__c = checkOut,
            Room_Type__c = roomType,
            Total_Amount__c = totalAmount,
            Status__c = 'Pending',
            Account__c = accountId
        );
        insert b;
        return b;
    }

    @AuraEnabled(cacheable=true)
    public static List<Booking__c> getMyBookings(Id accountId) {
        return [
            SELECT Id, Name, Hotel_Name__c, Check_In__c, Check_Out__c,
                   Total_Amount__c, Status__c
            FROM Booking__c
            WHERE Account__c = :accountId
            ORDER BY CreatedDate DESC
        ];
    }
}