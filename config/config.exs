import Config

config :honey_bucket,
  bots: [
    [
      bot: HoneyBucket.Tmi,
      user: "coach",
      pass: System.get_env("TWITCH_PASSWORD"),
      channels: ["#freedrull_"],
      mod_channels: [],
      debug: false
    ]
  ]
