require 'samantha_core'

module Lita
  module Handlers
    class Samantha < Handler
      config :db_url
      DUNNO = "Sorry, I don't know ¯\(°_o)/¯"

      route %r{topics}i,
        :topics,
        command: true,
        help: {
          "topics" => "Get all TOPICS from Samantha's Knowledge Graph"}

      route %r{(what's happening|what's up|wazzup)}i,
        :whats_happening,
        command: true,
        help: {
          "what's happening" => "Get recent activity from Samantha's Knowledge Graph"}

      route %r{correlations? with\s(.+)}i,
        :correlations_with,
        command: true,
        help: {
          "correlations with TOPIC" => "Which other topics correlate with this TOPIC based on Samantha's Knowledge Graph"}

      route %r{experts? on\s(.+)}i,
        :expert_on,
        command: true,
        help: {
          "expert on TOPIC" => "Get the people who know most about TOPIC from Samantha's Knowledge Graph"}


      def topics(response)
        results = sam.topics()
        if results.any?
          reply_with(response, "Here are all the topics I know:", results)
        else
          response.reply(DUNNO)
        end
      rescue Exception => e
        response.reply(";-( ERROR: #{e.message}")
      end

      def correlations_with(response)
        topic = response.matches[0][0]
        results = sam.correlations_with(topic)
        if results.any?
          reply_with(response, "These topics correlate with '#{topic}' the most:", results)
        else
          response.reply(DUNNO)
        end
      rescue Exception => e
        response.reply(";-( ERROR: #{e.message}")
      end

      def whats_happening(response)
        results = sam.whats_happening()
        if results.any?
          reply_with(response, "Here is what I know:", results)
        else
          response.reply(DUNNO)
        end
      rescue Exception => e
        response.reply(";-( ERROR: #{e.message}")
      end

      def expert_on(response)
        topic = response.matches[0][0]
        results = sam.expert_on(topic)
        if results.any?
          reply_with(response, "These people work with '#{topic}' the most:", results)
        else
          response.reply(DUNNO)
        end
      rescue Exception => e
        response.reply(";-( ERROR: #{e.message}")
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
