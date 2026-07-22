Account (Customer)
│
├── Booking**c
│ ├── Hotel_Name**c (Text)
│ ├── Check_In**c (Date)
│ ├── Check_Out**c (Date)
│ ├── Room_Type**c (Picklist)
│ ├── Total_Amount**c (Currency)
│ ├── Status**c (Picklist: Pending/Confirmed/Cancelled/Completed)
│ ├── Customer_Tier**c (Formula/Picklist: Standard/Silver/Gold)
│ └── Account**c (Lookup)
│
├── Payment**c
│ ├── Booking**c (Lookup)
│ ├── Amount**c (Currency)
│ ├── Stripe_Payment_Intent_Id\_\_c (Text, External Id)
│ ├── Status**c (Picklist: Pending/Success/Failed/Refunded)
│ ├── Payment_Date**c (DateTime)
│ └── Refund_Amount**c (Currency)
│
├── Case (standard object, extended)
│ ├── Booking**c (Lookup)
│ ├── Case_Type**c (Picklist: General/EarlyCheckin/Refund/Complaint)
│ ├── AI_Confidence_Score**c (Number)
│ ├── AI_Resolved**c (Checkbox)
│ └── Escalated_To_Human**c (Checkbox)
│
├── Refund_Request**c
│ ├── Payment**c (Lookup)
│ ├── Case**c (Lookup)
│ ├── Reason**c (Long Text)
│ ├── Approval_Status**c (Picklist)
│ └── Refund_Processed_Date**c (Date)
│
└── AI_Conversation**c (or use Case Comments / Agentforce transcript objects)
├── Case**c (Lookup)
├── Message**c (Long Text)
├── Sender**c (Customer/AI/Agent)
└── Timestamp\*\*c (DateTime)

Knowledge\_\_kav (standard Knowledge object)
├── Article_Type: Refund_Policy, Checkin_Policy, General_FAQ
└── Used by Agentforce for grounded responses

## Booking\_\_c

| Field Label   | API Name           | Type            | Notes                                                              |
| ------------- | ------------------ | --------------- | ------------------------------------------------------------------ |
| Account       | `Account__c`       | Lookup(Account) | Required                                                           |
| Hotel Name    | `Hotel_Name__c`    | Text(120)       | Required                                                           |
| Check In      | `Check_In__c`      | Date            | Required                                                           |
| Check Out     | `Check_Out__c`     | Date            | Required                                                           |
| Room Type     | `Room_Type__c`     | Picklist        | Values: Standard, Deluxe, Suite                                    |
| Total Amount  | `Total_Amount__c`  | Currency(16,2)  | Required                                                           |
| Status        | `Status__c`        | Picklist        | Values: Pending, Confirmed, Cancelled, Completed. Default: Pending |
| Customer Tier | `Customer_Tier__c` | Picklist        | Values: Standard, Silver, Gold. Default: Standard                  |

## Payment\_\_c

| Field Label       | API Name               | Type                 | Notes                                      |
| ----------------- | ---------------------- | -------------------- | ------------------------------------------ |
| Booking           | `Booking__c`           | Lookup(Booking\_\_c) | Required                                   |
| Amount            | `Amount__c`            | Currency(16,2)       | Required                                   |
| Razorpay Order Id | `Razorpay_Order_Id__c` | Text(255)            | External ID, Unique                        |
| Status            | `Status__c`            | Picklist             | Values: Pending, Success, Failed, Refunded |
| Payment Date      | `Payment_Date__c`      | Date/Time            |                                            |
| Refund Amount     | `Refund_Amount__c`     | Currency(16,2)       |                                            |
