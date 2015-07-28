require 'samantha_core'

module Lita
  module Handlers
    class Samantha < Handler
      config :db_url

      route %r{(what's happening|what's up|wazzup)}i,
        :whats_happening,
        command: true,
        help: {
          "what's happening" => "Get recent activity from Samantha's Knowledge Graph"}


      def whats_happening(response)
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
