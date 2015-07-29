require 'neo4j-core'
require 'pry-byebug'

module PrettyDate
  def time_ago
    a = (Time.now-self).to_i

    case a
      when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then a.to_s+' seconds ago'
      when 60..119 then 'a minute ago' #120 = 2 minutes
      when 120..3540 then (a/60).to_i.to_s+' minutes ago'
      when 3541..7100 then 'an hour ago' # 3600 = 1 hour
      when 7101..82800 then ((a+99)/3600).to_i.to_s+' hours ago'
      when 82801..172000 then 'a day ago' # 86400 = 1 day
      when 172001..518400 then ((a+800)/(60*60*24)).to_i.to_s+' days ago'
      when 518400..1036800 then 'a week ago'
      else ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
    end
  end
end

Time.send :include, PrettyDate

class SamanthaCore

      def initialize(db_url)
        @db_url = db_url
      end

      TOPICS_QUERY = %{
        (thing)-[:HAS_TOPIC]->(topic:Topic)
        RETURN  topic, count(thing) as score
        ORDER BY score DESC
        LIMIT 100
      }

      HISTORY_QUERY = %{
        MATCH (person:Person)-[r:CREATED]->(thing)-[:HAS_TOPIC]->(topic:Topic)
        RETURN person, r, thing, topic
        ORDER BY r.created_at DESC
        LIMIT 10
      }

      CORRELATIONS_QUERY = %{
        MATCH (topic:Topic)<-[:HAS_TOPIC]-(thing)-[:HAS_TOPIC]->(other_topic:Topic)
        WHERE topic.title = {topic_name}
        RETURN other_topic, count(thing) as score
        ORDER BY score DESC
        LIMIT 10
      }

      EXPERT_QUERY = %{
        MATCH (person:Person)-->(thing)-[:HAS_TOPIC]->(topic:Topic)
        WHERE topic.title = {topic_name}
        RETURN person, count(thing) as score
        ORDER BY score DESC
        LIMIT 5
      }

      def topics
        results = run_query(TOPICS_QUERY)
        results.map {|r| "'#{r.topic.attrs["title"]}' has been mentioned #{r.score} times" }
      end

      def whats_happening
        results = run_query(HISTORY_QUERY)
        messages = results.map {|r| history_message(r) }
        return messages
      end

      def correlations_with(topic_name)
        results = run_query(CORRELATIONS_QUERY, topic_name: topic_name)
        results.map {|r| "'#{r.other_topic.attrs["title"]}' has #{r.score} correlations" }
      end

      def expert_on(topic_name)
        results = run_query(EXPERT_QUERY, topic_name: topic_name)
        messages = results.map {|r| expert_message(r) }
        return messages
      end

      protected

      def history_message(result)
        name = result.person.props[:name]
        type_of_thing = result.thing.labels.first
        thing_name = result.thing.props[:title]
        topic = result.topic.props[:title]

        created_at = Time.at(result.r.props[:created_at])
        time_ago = created_at.time_ago
        "#{name} created #{type_of_thing}:'#{thing_name}' with topic '#{topic}' #{time_ago}"
      end

      def expert_message(result)
        name = result.person.props[:name]
        "#{name}'s score is #{result.score}"
      end

      def run_query(query, args = {})
        puts "running cypher query: #{query} with args: #{args}"
        session.query(query, args).to_a
      end

      def session
        @neo4j_session ||= Neo4j::Session.open(:server_db, @db_url )
      end
end
