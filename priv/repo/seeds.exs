# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MessagingService.Repo.insert!(%MessagingService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import MessagingService
alias MessagingService.Messaging.Provider

MessagingService.Repo.insert!(%Provider{
  name: "xillio",
  type: :email,
  active: true
})

MessagingService.Repo.insert!(%Provider{
  name: "messaging_provider",
  type: :sms,
  active: true
})

MessagingService.Repo.insert!(%Provider{
  name: "messaging_provider",
  type: :mms,
  active: true
})
