require 'samantha_core'

module Lita
  module Handlers
    class Samantha < Handler
      config :db_url
      DUNNO = "Sorry, I don't know ¯\(°_o)/¯"

      route %r{(what's happening|what's up|wazzup)}i,
        :whats_happening,
        command: true,
        help: {
          "what's happening" => "Get recent activity from Samantha's Knowledge Graph"}

      route %r{experts? on\s(.+)}i,
        :expert_on,
        command: true,
        help: {
          "expert on TOPIC" => "Get the people who know most about TOPIC from Samantha's Knowledge Graph"}


      def whats_happening(response)
        results = sam.whats_happening()
        if results.any?
          reply_with(response, "Here is what I know:", results)
        else
          response.reply(DUNNO)
        end
      end

      def expert_on(response)
        topic = response.matches[0][0]
        results = sam.expert_on(topic)
        if results.any?
          reply_with(response, "These guys work with '#{topic}' the most:", results)
        else
          response.reply(DUNNO)
        end
      end

      def reply_with(response, msg, results)
        msg += "\n" + results.join("\n")
        response.reply(msg)
      end

      def sam
        @sam ||= SamanthaCore.new(Lita.config.handlers.samantha.db_url)
      end

    end

    Lita.register_handler(Samantha)
  end
end
