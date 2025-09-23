enum OrderStatus {
  pending('Pending'),
  inProcess('In Process'),
  readyToDispatch('Ready To Dispatch'),
  delivered('Completed');

  // Declare a final field to hold the string value
  final String displayValue;

  // Add a const constructor to initialize the field
  const OrderStatus(this.displayValue);
}
