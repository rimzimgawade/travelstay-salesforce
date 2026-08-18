@isTest
global class RazorpayCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id":"order_test_12345","entity":"order","status":"created"}');
        res.setStatusCode(200);
        return res;
    }
}