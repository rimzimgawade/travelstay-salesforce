public with sharing class RazorpayPaymentService {

    @AuraEnabled
    public static Payment__c createOrder(Id bookingId, Decimal amount) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Razorpay_API/v1/orders');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> bodyMap = new Map<String, Object>{
            'amount' => (Integer)(amount * 100), // Razorpay expects paise, smallest INR unit
            'currency' => 'INR',
            'receipt' => 'booking_' + bookingId,
            'payment_capture' => 1
        };
        req.setBody(JSON.serialize(bodyMap));

        Http http = new Http();
        HttpResponse res = http.send(req);

        Payment__c pay = new Payment__c(
            Booking__c = bookingId,
            Amount__c = amount,
            Payment_Date__c = System.now()
        );

        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            pay.Razorpay_Order_Id__c = (String) responseMap.get('id');
            pay.Status__c = 'Success';
        } else {
            pay.Status__c = 'Failed';
        }
        insert pay;

        if (pay.Status__c == 'Success') {
            Booking__c b = new Booking__c(Id = bookingId, Status__c = 'Confirmed');
            update b;
        }
        return pay;
    }
}