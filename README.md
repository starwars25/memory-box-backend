# Memory Box Backend

This is a service-side part of **MemoryBox** application.

The application is intended to keep long-term bets among users.

User signs up, creates *Box*, invites other users to the box, and create a *Bet* with the video attached. User cannot create *Bet* without video. While creating *Bet*, User sets the expirationd date of the *Bet*. At expiration date, an email will be sent to all of the users in the *Box*. User can also finish the *Bet*, in this case emails will be sent too.

This is a server-side of **MemoryBox**. The server is REST API. In development BDD approach was used. In production PostgreSQL is used. The application also has **iOS** and **Android** clients.