use Mix.Config

config :tracker_bot,
      cowboy_opts: [
        port: 4443,
        otp_app: :tracker_bot,
        keyfile: "/home/deploy/.keys/bot.key",
        certfile: "/home/deploy/.keys/bot.pem"
      ]
