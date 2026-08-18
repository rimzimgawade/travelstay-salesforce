import { LightningElement, wire } from 'lwc';
import createBooking from '@salesforce/apex/BookingController.createBooking';
import createOrder from '@salesforce/apex/RazorpayPaymentService.createOrder';
import getCurrentUserAccountId from '@salesforce/apex/BookingController.getCurrentUserAccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BookingForm extends LightningElement {
    hotelName = '';
    checkIn;
    checkOut;
    roomType = 'Standard';
    totalAmount;
    accountId;
    accountIdError;

    roomOptions = [
        { label: 'Standard', value: 'Standard' },
        { label: 'Deluxe', value: 'Deluxe' },
        { label: 'Suite', value: 'Suite' }
    ];

    // Resolves the logged-in portal user's Account once, when the component loads.
    @wire(getCurrentUserAccountId)
    wiredAccountId({ data, error }) {
        if (data) {
            this.accountId = data;
        } else if (error) {
            this.accountIdError = error;
            // eslint-disable-next-line no-console
            console.error('Could not resolve Account for current user', error);
        }
    }

    handleHotelChange(e) { this.hotelName = e.target.value; }
    handleCheckInChange(e) { this.checkIn = e.target.value; }
    handleCheckOutChange(e) { this.checkOut = e.target.value; }
    handleRoomTypeChange(e) { this.roomType = e.detail.value; }
    handleAmountChange(e) { this.totalAmount = e.target.value; }

    async handleBookAndPay() {
        if (!this.accountId) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Cannot Book',
                message: 'No customer account is linked to your login yet. Contact support.',
                variant: 'error'
            }));
            return;
        }

        try {
            const booking = await createBooking({
                hotelName: this.hotelName,
                checkIn: this.checkIn,
                checkOut: this.checkOut,
                roomType: this.roomType,
                totalAmount: this.totalAmount,
                accountId: this.accountId
            });

            const payment = await createOrder({
                bookingId: booking.Id,
                amount: this.totalAmount
            });

            this.dispatchEvent(new ShowToastEvent({
                title: 'Booking Confirmed',
                message: `Payment ${payment.Status__c}. Booking ${booking.Name} confirmed.`,
                variant: 'success'
            }));
        } catch (err) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: err.body ? err.body.message : err.message,
                variant: 'error'
            }));
        }
    }
}