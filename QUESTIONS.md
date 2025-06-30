- Should we assume that we only want to support one on one conversations?

- Should we assume that we only want to support one conversation between users? Can one pair of users have multiple conversations? In that case, how do we differentiate between which conversation they're having?

- Do we want to save attachment contents?

- The README states "Conversations consist of messages from multiple providers.". Does that mean that a single conversation could have multiple providers? I'm wondering how to handle a case where a user texts and email address or something

- How can we guess the provider for a message? Should we assume for the moment that all sms/mms has a single provider, and all email has a single provider?

- What sort of API should we use to mock the providers? I'm guessing Provider.send() for outgoing messages, do we want to forward the message to the device otherwise? For Twilio you're supposed to translate the incoming address to a device ID.
