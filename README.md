#LoanMate
##Distributed Loan Sharing
LoanMate anonymously distributes loans across a large amount of lenders. Each
person can make a small contribution which in the end will go into a pool for
the person requesting the loan.

Loanmate uses braintree to handle the pooling of payments, sendgrid to send
confirmation emails, and paypal to pay out the person requesting the loan. The
server can be found in the Loanmate project.

*****Note this is not fully completed, with respect to the implementation with
the paypal api. The application can successully accept payments (when
a braintree account is added) and performs the distribution logic but no money
will be sent.

![Screenshot main](/../screenshots/screenshots/top.png "Main page")
![Screenshot deficit](/../screenshots/screenshots/bottom.png "Deficit example")
![Screenshot create](/../screenshots/screenshots/create.png "Create a loan")
