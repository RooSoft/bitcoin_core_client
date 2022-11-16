alias BitcoinCoreClient.Http

%Http.Settings{
  username: "electrum",
  password: "Rh_KUrE42MtGtUqhtjc",
  ip: "electrum",
  port: 8332
}
|> BitcoinCoreClient.start_link()
