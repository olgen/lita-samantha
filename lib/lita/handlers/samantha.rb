require 'samantha_core'

module Lita
  module Handlers
    class Samantha < Handler
      config :db_url

      route(/what's happening|what's up|wazzup/, command: true) do |response|
        whats_happening?(response)
      end

      def whats_happening?(response)
        results = sam.whats_happening?()
        msg = "Not much...only this:\n"
        msg += results.join("\n")
        response.reply(msg)
      end

      def sam
        @sam ||= SamanthaCore.new(Lita.config.handlers.samantha.db_url)
      end

    end

    Lita.register_handler(Samantha)
  end
end
